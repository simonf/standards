View = {
  listElement : null,
  tagListElement : null,
  editingElement : null,
  showTagList : ->
    $(View.tagListElement).empty()
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
    $("div.list-lifecycle").hide()
    $("span.sh-lifecycle a").click ->
      id = $(this).attr('data_id')
      tgt = "#life_#{id}"
      $(tgt).toggle()
      return false
    $("#list a.edit-link").click ->
      View.stopEditing()
      View.editStandard this,true
      return false
    $("#list a.view-link").click ->
      View.stopEditing()
      View.editStandard this,false
      return false
    $("#list a.del-link").click ->
      View.stopEditing()
      View.deleteStandard this
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
    Standard.addOrUpdate std, ->
      View.stopEditing()
      View.showFilteredStandards()
      View.showTagList()
      return
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
  ,
  deleteStandard : (row) ->
    id = $(row).attr "data-id"
    name = $(row).parent().siblings(".list-name").text()
    if confirm "Really delete #{name}?"
      Standard.deleteStandard id, ->
        View.showFilteredStandards()
        View.showTagList()
        return
    return
  ,
  getDefaultAttribute : (std, attr, val) ->
    if _.isUndefined std[attr] then val else std[attr]
}
