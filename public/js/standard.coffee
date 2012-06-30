Standard = {
  fields : ["_id", "name", "current", "emerging", "deprecated", "obsolete", "notes", "owner", "updated", "tags"],
  standards : [],
  tagfilter: [],
  tags: [],
  getAllStandards : (callback) ->
    $.getJSON '/', (data) ->
      Standard.standards = data
      Standard.makeTagList()
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
      Standard.postNew std, callback
    else
      Standard.putUpdate std, callback
  ,
  postNew: (std, callback) ->
    tosend =  {} 
    for lab in Standard.fields
      tosend[lab]=std[lab] if lab!="_id"
    $.post '/', tosend, (data) ->
      std._id = data._id
      Standard.standards.push std
      Standard.makeTagList()
      callback()
      return
    return
  ,
  putUpdate: (std, callback) ->  
    tosend =  {} 
    for lab in Standard.fields
      tosend[lab]=std[lab]
    $.ajax {
      url: "/",
      type: "PUT",
      data: tosend,
      success: (data) ->
        foundndxs = i for val,i in Standard.standards when val._id == std._id
        Standard.standards[foundndxs]=std if foundndxs > -1
        Standard.makeTagList()
        callback()
        return
      }
    return
  ,
  deleteStandard : (id, callback) ->
    for std in Standard.standards
      if std._id == id
        $.ajax {
          url: "/#{id}",
          type: "DELETE",
          success: (data) ->
            foundndxs = i for val,i in Standard.standards when val._id == id
            Standard.standards.splice foundndxs,1 if foundndxs > -1
            Standard.makeTagList()
            callback()
            return
          }
    return
  ,
  makeTagList : ->
    Standard.tags = []
    for std in Standard.standards
      for tag in std.tags.split ','
        Standard.tags.push tag.trim() if Standard.tags.indexOf(tag.trim()) == -1
    return
  ,
  matchTagList: (taglist, comma_separated) ->
    retval = if taglist.length > 0 then false else true
    for tag in taglist
      retval = true if comma_separated.indexOf(tag.trim()) != -1
    return retval
  ,
  getFilteredStandards :  ->
    standard for standard in Standard.standards when Standard.matchTagList Standard.tagfilter, standard.tags
}
