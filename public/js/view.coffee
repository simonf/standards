root = exports ? this
root.View = {
  listElement : null,
  tagListElement : null,
  editingElement : null,
  showTagList : ->
    $(@tagListElement).empty()
    for tag in Standard.tags
      $(@tagListElement).append _.template Template.tagcloudelement, {tag : tag}
  ,
  showSelectedTags : ->
    $("#tagfilter").val Standard.tagfilter.sort().join(' ')
  ,
  tagClicked : (ctag) ->
    i = Standard.tagfilter.indexOf ctag
    Standard.tagfilter.splice i,1 if i != -1
    Standard.tagfilter.push ctag if i == -1
    @showSelectedTags()
    @showFilteredStandards()
  ,
  setFilter : (elem) ->
    v = $("#tagfilter").val()
    va = v.split(/[ ,]/)
    Standard.tagfilter = (v for v in va when v.length > 0)
    @showSelectedTags()
    @showFilteredStandards()
  ,
  clearFilter : (elem) ->
    Standard.tagfilter = []
    @showSelectedTags()
    @showFilteredStandards()
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
  ,
  showFilteredStandards : ->
    @showSomeStandards Standard.getFilteredStandards()
  ,
  showSomeStandards : (arr) ->
    @stopEditing()
    $(@listElement).empty()
    $.each arr, (ndx,val) =>
      $(@listElement).append @makeListItem val
      return
    @processClicks()
  ,
  makeListItem : (std) ->
    _.template Template.currentlist, { std : std }
  ,
  processForm : (elem, func) ->
    std = @makeStandardFromForm "#form"
    Standard.addOrUpdate std, =>
      @stopEditing()
      @showFilteredStandards()
      @showTagList()
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
    if @editingElement != null
      $(@editingElement).show()
      @editingElement=null
  ,
  configureForm : (elem, editable) ->
    @editingElement.after elem
    @editingElement.hide()
    $("#form").submit =>
      @processForm()
      return false
    $("#cancel-button").click =>
      @stopEditing()
      return false
    $("#edit-buttons-wrap").show() if editable
    $("#edit-buttons-wrap").hide() if not editable
    $("#form input").attr "readonly","readonly" if not editable
    $("#form input").removeAttr "readonly" if editable
  ,
  showNewForm : ->
    std= {}
    std[lab]="" for lab in Standard.fields
    elem= _.template Template.stdform, {std : std}
    @editingElement = $(@listElement)
    @configureForm elem, true
  ,
  editStandard : (row,editable) ->
    id = $(row).attr "data-id"
    for val in Standard.standards
      if val._id == id
        @editingElement = $(row).closest ".standard-row"
        elem= _.template Template.stdform, {std :val}
        @configureForm elem, editable
    return
  ,
  deleteStandard : (row) ->
    id = $(row).attr "data-id"
    name = $(row).parent().siblings(".list-name").text()
    if confirm "Really delete #{name}?"
      Standard.deleteStandard id, =>
        @showFilteredStandards()
        @showTagList()
        return
    return
  ,
  getDefaultAttribute : (std, attr, val) ->
    if _.isUndefined std[attr] then val else std[attr]
}
