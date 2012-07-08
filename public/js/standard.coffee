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
    retval.push term.trim() for term in str.split /[\s,]+/ when not (term.trim() in retval)
    retval
  ,
  accumulateTags : (std) ->
#    @tags.push tag.trim() for tag in std.tags.split /[\s,]+/ when not (tag.trim() in @tags)
    @tags.push tag for tag in @makeUniqueStrippedAndTrimmedArray(std.tags) when not (tag in @tags)
    return
  ,
  matchTagList: (taglist, comma_separated) ->
    retval = if taglist.length > 0 then false else true
    for tag in taglist
      if comma_separated.indexOf(tag.trim()) >=0
        return true
    return retval
  ,
  getFilteredStandards :  ->
    if @searching
      standard for standard in @standards when standard._id in @idlist
    else
      standard for standard in @standards when @matchTagList @tagfilter, standard.tags
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
