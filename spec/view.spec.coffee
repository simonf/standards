mod = require '../public/js/view'
describe 'view', ->
  it 'should initialize some variables', ->
    expect(mod.View.listElement).toBeDefined()
    expect(mod.View.tagListElement).toBeDefined()
    expect(mod.View.editingElement).toBeNull()
    expect(mod.View.loggedIn).toBeFalsy()
