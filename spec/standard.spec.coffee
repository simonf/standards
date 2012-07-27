mod = require '../public/js/standard'
describe 'standard', ->
  it 'should keep track of all the attributes of a standard', ->
    flds = ["_id", "name", "current", "emerging", "deprecated", "obsolete", "notes", "owner", "updated", "tags"]
    expect(mod.Standard.fields).toEqual flds

  it 'should make an AJAX call to retrieve all standards', ->
    tdata = [{name: "dummy", tags: "one, two"}]
    jasmine.getGlobal().$ = {
      getJSON:  (url,cb) ->
        cb tdata
    }
    expect(jasmine.getGlobal().$.getJSON).toBeDefined()
    spyOn(mod.Standard,'makeTagList')
    a = mod.Standard.getAllStandards ->
      "OK"
    expect(mod.Standard.makeTagList).toHaveBeenCalled()
    expect(a).toEqual "OK"
    expect(mod.Standard.standards.length).toEqual 1

  it 'should return some ids when passed some search terms', ->
    jasmine.getGlobal().$ = {
      post:  (url,data,cb) ->
        cb [1,2,3]
    }
    aCallback=createSpy 'acallback'
    jasmine.getGlobal().Standard=mod.Standard
    mod.Standard.queryTextFields 'one two', aCallback
    expect(aCallback).toHaveBeenCalled
    expect(mod.Standard.idlist.length).toEqual 3
    
