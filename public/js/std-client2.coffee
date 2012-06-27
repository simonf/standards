Standard = {
  fields : ["_id", "name", "current", "emerging", "deprecated", "obsolete", "tags"],
  standards : [],
  tagfilter: [],
  getAllStandards : (callback) ->
    $.getJSON '/', (data) ->
      Standard.standards = data
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
  addOrUpdate : (std) ->
    settings = { url : "/", data : {} }
    for lab in Standard.fields
       settings.data[lab]=std[lab]
    settings.error = (jqxhr, status, err) ->
       alert status + err + jqxhr.getAllResponseHeaders()
       return
    if std._id == null || std._id == ""
       delete settings.data._id
       settings.type = "POST"
       settings.dataType = "json"
       settings.success = (data) ->
           std._id = data._id
           $(View.listElement).append View.makeStandardElement std
           Standards.standards.push std
           View.clearForm()
           return
    else
       settings.type = "PUT"
       settings.dataType = "text"
       settings.success = (data) ->
           $.each Standard.standards, (ndx,val) ->
             if val._id == std._id
               Standard.standards[ndx]=std
           View.clearForm()
           return
    $.ajax settings
    return
  ,
  matchTagList: (taglist, comma_separated) ->
    retval = true
    for tag in taglist
      retval = false if comma_separated.toLowerCase().indexOf tag.toLowerCase() == -1
    return retval
  ,
  getFilteredStandards :  ->
    standard for standard in Standard.standards when Standard.matchTagList Standard.tagfilter, standard.tags
}

View = {
  listElement : null,
  processClicks : ->
    $("#list a.edit-link").click ->
      View.showStandard $(this).attr("data-id"),true
      return false
    $("#list a.view-link").click ->
      View.showStandard $(this).attr("data-id"),false
      return false
    return
  ,
  showStandard : (id,editable) ->
    $.each Standard.standards, (ndx, val) ->
      if val._id == id
        View.populateFormFromStandard "#form", val, editable
    return
  ,
  showSomeStandards : (arr) ->
    $.each arr, (ndx,val) ->
      $(View.listElement).append View.makeStandardElement val
      return
    View.processClicks()
    return
  ,
  makeStandardElement : (std) ->
    View.makeListItem std
  ,
  makeListItem : (std) ->
    _.template Template.currentlist, { std : std }
  ,
  clearForm : ->
    document.forms["stdform"].reset()
    $("#stdform #_id").val("")
    return
  ,
  processForm : (elem, func) ->
    std = View.makeStandardFromForm elem
    func std
    return
  ,
  makeStandardFromForm : (elem) ->
    retval = {}
    for lab in Standard.fields
      tgt = "#{elem} ##{lab}"
      retval[lab] = $(tgt).val()
    return retval
  ,
  populateFormFromStandard : (elem, std, editable) ->
    $("#edit-buttons-wrap").show() if editable
    $("#edit-buttons-wrap").hide() if not editable
    for lab in Standard.fields
      tgt = "#{elem} ##{lab}"
      $(tgt).val(std[lab])
      $(tgt).attr("readonly","readonly") if not editable
      $(tgt).removeAttr("readonly") if editable
    return
}

Template = {
  linkinlist : "<div class='standard'><a href='' class='edit-link' data-id='<%= std._id %>'><%= std.name %></a></div>",
  currentlist: """
    <tr class='standard-row'> 
      <td><%= std.name %></td>
      <td><%= std.current %></td>
      <td>
        <a href='' class='view-link' data-id='<%= std._id %>'>View</a>
        <a href='' class='edit-link' data-id='<%= std._id %>'>Edit</a>
      </td>
    </tr>
"""
}