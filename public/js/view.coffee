root = exports ? this
root.View = {
  listElement : "#list-view",
  tagListElement : "#tagcloud",
  editingElement : null,
  loggedIn : false,
  setLoggedInOrOut : ->
    usr = $.cookie 'username'
    if usr
      $('#login-block').hide()
      $('#logout-block').show()
      $('#current-username').text(usr)
      @loggedIn=true
    else
      $('#login-block').show()
      $('#logout-block').hide()
      @loggedIn=false
  ,
  showTagList : ->
    $(@tagListElement).empty()
    for tag in Standard.tags
      $(@tagListElement).append _.template Template.tagcloudelement, {tag : tag}
    return
  ,
  showSelectedTags : ->
    $("#selectedtags").empty()
    for tag in Standard.tagfilter.sort()
      $("#selectedtags").append _.template Template.tagcloudelement, {tag : tag}
    return
  ,
  tagClicked : (ctag) ->
    i = Standard.tagfilter.indexOf ctag
    Standard.tagfilter.splice i,1 if i != -1
    Standard.tagfilter.push ctag if i == -1
    @showSelectedTags()
    @showFilteredStandards()
  ,
  doSearch :  ->
    Standard.queryTextFields $("#searchfilter").val(), ->
      Standard.tagfilter = []
      View.showSelectedTags()
      View.showFilteredStandards()
  ,
  clearSearch :  ->
    $("#searchfilter").val ""
    Standard.tagfilter = []
    Standard.idlist=[]
    Standard.searching = false
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
    if @loggedIn
      $("div.list-item-links").show()
      $("#list a.edit-link").click ->
        View.stopEditing()
        View.editStandard this,true
        return false
      $("#list a.del-link").click ->
        View.stopEditing()
        View.deleteStandard this
        return false
    else
      $("div.list-item-links").hide()
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
      if lab == 'tags'
        retval["tags"]=Standard.makeUniqueStrippedAndTrimmedArray $(tgt).val()
      else
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
    if _.isUndefined std[attr]
      val 
    else 
      if attr == 'tags'
        std['tags'].join(' ')
      else
        std[attr]
}
