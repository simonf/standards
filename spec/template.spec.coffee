tpl = require '../public/js/template'
describe 'template', ->
  it 'should provide a comment form for a standard', ->
    expect(tpl.Template.commentform).toEqual jasmine.any String
    expect(tpl.Template.commentform).toContain 'form' 
    expect(tpl.Template.commentform).toContain '%= std._id' 

  it 'should fail when called with an arbitrary string', ->
    expect(tpl.Template.foobar).toBeUndefined()

  it 'should provide a tag cloud element that wraps a tag with an HTML anchor', ->
    expect(tpl.Template.tagcloudelement).toContain '<a'
    expect(tpl.Template.tagcloudelement).toContain '%= tag'

  it 'should provide an edit link for a standard', ->
    expect(tpl.Template.linkinlist).toContain '<a'
    expect(tpl.Template.linkinlist).toContain '%= std._id'

  it 'should provide a standard row template', ->
    for x in ['std._id','name','current','emerging','tags']
      expect(tpl.Template.currentlist).toContain x

  it 'should provide a form for creating a new standard', ->
    expect(tpl.Template.stdform).toContain '<form'
    for x in ['_id','name','current','emerging','deprecated','obsolete','notes','tags']
      expect(tpl.Template.stdform).toContain "std.#{x}"
