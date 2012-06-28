Standard = {
  fields : ["_id", "name", "current", "emerging", "deprecated", "obsolete", "tags"],
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
       settings.error = (jqxhr, txt, err) ->
           alert "#{txt}: #{err}"
           alert jqxhr.getAllResponseHeaders().toString()
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

View = {
  listElement : null,
  tagListElement : null,
  editingElement : null,
  showTagList : ->
    for tag in Standard.tags
      $(View.tagListElement).append _.template Template.tagcloudelement, {tag : tag}
  ,
  showSelectedTags : ->
    $("#tagfilter").val Standard.tagfilter.sort().join(' ')
  ,
  tagClicked : (ctag) ->
    i = Standard.tagfilter.indexOf ctag
    Standard.tagfilter.splice i,1 if i != -1
    Standard.tagfilter.push ctag if i == -1
    View.showSelectedTags()
    View.showFilteredStandards()
    return
  ,
  setFilter : (elem) ->
    v = $("#tagfilter").val()
    va = v.split(/[ ,]/)
    Standard.tagfilter = (v for v in va when v.length > 0)
    View.showSelectedTags()
    View.showFilteredStandards()
    return
  ,
  clearFilter : (elem) ->
    Standard.tagfilter = []
    View.showSelectedTags()
    View.showFilteredStandards()
    return
  ,
  processClicks : ->
    $("#list a.edit-link").click ->
      View.stopEditing()
      View.editStandard this,true
      return false
    $("#list a.view-link").click ->
      View.stopEditing()
      View.editStandard this,false
      return false
    return
  ,
  showFilteredStandards : ->
    View.showSomeStandards Standard.getFilteredStandards()
  ,
  showSomeStandards : (arr) ->
    View.stopEditing()
    $(View.listElement).empty()
    $.each arr, (ndx,val) ->
      $(View.listElement).append View.makeListItem val
      return
    View.processClicks()
    return
  ,
  makeListItem : (std) ->
    _.template Template.currentlist, { std : std }
  ,
  processForm : (elem, func) ->
    std = View.makeStandardFromForm "#form"
    Standard.addOrUpdate std
    if std._id == null || std._id == ""
      Standards.standards.push std
    else
      $.each Standard.standards, (ndx,val) ->
        if val._id == std._id
          Standard.standards[ndx]=std
    View.stopEditing()
    View.showFilteredStandards()    
    return
  ,
  makeStandardFromForm : (elem) ->
    retval = {}
    for lab in Standard.fields
      tgt = "#{elem} ##{lab}"
      retval[lab] = $(tgt).val()
    return retval
  ,
  stopEditing : ->
    $("#form").remove()
    if View.editingElement != null
      $(View.editingElement).show()
      View.editingElement=null
  ,
  configureForm : (elem, editable) ->
    View.editingElement.after elem
    View.editingElement.hide()
    $("#form").submit ->
      View.processForm()
      return false
    $("#cancel-button").click ->
      View.stopEditing()
      return false
    $("#edit-buttons-wrap").show() if editable
    $("#edit-buttons-wrap").hide() if not editable
    $("#form input").attr "readonly","readonly" if not editable
    $("#form input").removeAttr "readonly" if editable
    return
  ,
  showNewForm : ->
    std= {}
    for lab in Standard.fields
      std[lab] = ""
    elem= _.template Template.stdform, {std : std}
    View.editingElement = $(View.listElement)
    View.configureForm elem, true
    return
  ,
  editStandard : (row,editable) ->
    id = $(row).attr "data-id"
    $.each Standard.standards, (ndx, val) ->
      if val._id == id
        View.editingElement = $(row).closest ".standard-row"
        elem= _.template Template.stdform, {std :val}
        View.configureForm elem, editable
    return
}

Template = {
  tagcloudelement : "<a class='taginlist' href='' onclick='javascript:View.tagClicked(\"<%= tag %>\"); return false;'><%= tag %></a>",
  linkinlist : "<div class='standard'><a href='' class='edit-link' data-id='<%= std._id %>'><%= std.name %></a></div>",
  currentlist: """
    <div class='standard-row'> 
      <div class='list-name'><%= std.name %></div>
      <div class='list-current'><%= std.current %></div>
      <div class='list-view-link'><a href='' class='view-link' data-id='<%= std._id %>'>View</a></div>
      <div class='list-edit-link'><a href='' class='edit-link' data-id='<%= std._id %>'>Edit</a></div>
    </div>
""",
  stdform: """
      <div id='form'>
	<form id='stdform' method='post' action=''>
	  <input type='hidden' id='_id' value='<%= std._id %>'/>
	  <div id='name-wrap'>
	    <label for='name'>Name</label>
	    <input id='name' type='text' value='<%=std.name %>'/>
	  </div>
	  <div id='current-wrap'>
	    <label for='current'>Current</label>
	    <textarea id='current' rows='3'><%= std.current %></textarea>
	  </div>
	  <div id='emerging-wrap'>
	    <label for='emerging'>Emerging</label>
	    <textarea id='emerging' rows='3'><%= std.emerging %></textarea>
	  </div>
	  <div id='deprecated-wrap'>
	    <label for='deprecated'>Deprecated</label>
	    <textarea id='deprecated' rows='3'><%= std.deprecated %></textarea>
	  </div>
	  <div id='obsolete-wrap'>
	    <label for='obsolete'>Obsolete</label>
	    <textarea id='obsolete' rows='3'><%= std.obsolete %></textarea>
	  </div>
	  <div id='tags-wrap'>
	    <label for='tags'>Tags (comma separated)</label>
	    <input id='tags' type='text' value='<%= std.tags %>'/>
	  </div>
          <div id='edit-buttons-wrap'>
	    <input type='submit' value='Submit' id='submit'></input>
	  </div>
          <div id='cancel-wrap'>
	    <a href='' id='cancel-button'>Cancel</a>
          </div>
	</form>
      </div>
"""
}