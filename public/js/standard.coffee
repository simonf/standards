root = exports ? this
root.Standard = {
  fields : ["_id", "name", "current", "emerging", "deprecated", "obsolete", "notes", "owner", "updated", "tags"],
  standards : [],
  tagfilter: [],
  tags: [],
  getAllStandards : (callback) ->
    $.getJSON '/', (data) =>
      @standards = data
      @makeTagList()
      callback()
      return
    return
  ,
  getStandardByID : (id, callback) ->
    $.getJSON "/#{id}", (data) ->
      callback data
      return
    return
  ,
  addOrUpdate : (std,callback) ->
    if std._id == null || std._id == ""
      @postNew std, callback
    else
      @putUpdate std, callback
  ,
  postNew: (std, callback) ->
    tosend =  {} 
    for lab in @fields
      tosend[lab]=std[lab] if lab!="_id"
    $.post '/', tosend, (data) =>
      std._id = data._id
      @standards.push std
      @makeTagList()
      callback()
      return
    return
  ,
  putUpdate: (std, callback) ->  
    tosend =  {} 
    for lab in @fields
      tosend[lab]=std[lab]
    $.ajax {
      url: "/",
      type: "PUT",
      data: tosend,
      success: (data) =>
        foundndxs = i for val,i in @standards when val._id == std._id
        @standards[foundndxs]=std if foundndxs > -1
        @makeTagList()
        callback()
        return
      }
    return
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
            return
          }
    return
  ,
  makeTagList : ->
    @tags = []
    for std in @standards
      for tag in std.tags.split ','
        @tags.push tag.trim() if @tags.indexOf(tag.trim()) == -1
    return
  ,
  matchTagList: (taglist, comma_separated) ->
    retval = if taglist.length > 0 then false else true
    for tag in taglist
      retval = true if comma_separated.indexOf(tag.trim()) != -1
    return retval
  ,
  getFilteredStandards :  ->
    standard for standard in @standards when @matchTagList @tagfilter, standard.tags
}
