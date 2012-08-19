root = exports ? this
root.Standard = {
  fields : ["_id", "name", "current", "emerging", "deprecated", "obsolete", "notes", "owner", "updated", "tags"],
  standards : [],
  tagfilter: [],
  tags: [],
  idlist: [],
  searching: false,
  getAllStandards : (callback) ->
    $.getJSON '/', (data) =>
      @standards = data
      @makeTagList()
      callback()
  ,
  queryTextFields : (searchTerms, callback) ->
    qrystring = @makeQueryParamFromSearchTerms searchTerms
    tosend = {}
    tosend["qrystring"]=qrystring
    $.post '/query', tosend, (data) ->
      Standard.idlist=[]
      Standard.idlist.push row._id for row in data
      Standard.searching=true
      callback()
  ,
  getStandardByID : (id, callback) ->
    $.getJSON "/#{id}", (data) ->
      callback data
  ,
  addOrUpdate : (std,callback) ->
    if not std._id? or std._id is ""
      @postNew std, callback
    else
      @putUpdate std, callback
  ,
  postNew: (std, callback) ->
    tosend =  {} 
    tosend[lab]=std[lab] for lab in @fields when lab!="_id"
    $.post '/', tosend, (data) =>
      std._id = data._id
      @standards.push std
      @makeTagList()
      callback()
  ,
  putUpdate: (std, callback) ->  
    tosend =  {} 
    tosend[lab]=std[lab] for lab in @fields
    $.ajax {
      url: "/",
      type: "PUT",
      data: tosend,
      success: (data) =>
        foundndxs = i for val,i in @standards when val._id == std._id
        @standards[foundndxs]=std if foundndxs > -1
        @makeTagList()
        callback()
      }
  ,
  deleteStandard : (id, callback) ->
    for std in @standards
      if std._id == id
        $.ajax {
          url: "/#{id}",
          type: "DELETE",
          success: (data) =>
            foundndxs = i for val,i in @standards when val._id == id
            @standards.splice foundndxs,1 if foundndxs > -1
            @makeTagList()
            callback()
          }
  ,
  makeTagList : ->
    @tags = []
    @accumulateTags std for std in @standards
    return
  ,
  makeUniqueStrippedAndTrimmedArray: (str) ->
    retval=[]
    retval.push term.trim() for term in str.trim().split /[\s,]+/ when ((not (term.trim() in retval)) and term.trim().length > 0)
    retval
  ,
  accumulateTags : (std) ->
    @tags.push tag for tag in std.tags when not (tag in @tags)
    return
  ,
  matchTagList: (taglist, tagarray) ->
    retval = if taglist.length > 0 then false else true
    matchcnt=0
    for tag in taglist
      for t in tagarray
        if t == tag.trim()
          matchcnt += 1
          retval = true if matchcnt == taglist.length
    return retval
  ,
  getFilteredStandards : (pageSize, startRow) ->
    if @searching
      filtered = (standard for standard in @standards when standard._id in @idlist)
      standard for standard,i in filtered when (i >= startRow and i <= startRow + pageSize)
    else
      filtered = (standard for standard in @standards when @matchTagList(@tagfilter, standard.tags)) 
      standard for standard, i in filtered when (i >= startRow and i <= startRow + pageSize)
  ,
  makeQueryParamFromSearchTerms: (srchString) ->
    # space or comma separated should be treated as different terms with an implicit "AND"
    qa=@makeUniqueStrippedAndTrimmedArray srchString
    retval = ""
    first=true
    for term in qa
      if not first then retval = retval + "|" else first=false
      retval = retval + term
    retval
}
