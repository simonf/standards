express = require "express"
mongodb = require "mongodb"
util = require 'util'

mongoserver = new mongodb.Server "127.0.0.1", 27017, { auto_reconnect : true}
db_connector = new mongodb.Db "standards", mongoserver, {}
mydb = null

app = express.createServer()

app.configure ->
    app.use express.methodOverride()
    app.use express.bodyParser()
    app.use '/public', express.static __dirname + '/public'
    return

app.get "/",(req,res) ->
    mydb.collection "standards", (err,coll) ->
        coll.find().toArray (err,docs) ->
            console.log "Sending #{docs.length} docs"
            res.send docs
        return
    return

app.get "/:id",(req,res) ->
    mydb.collection "standards", (err,coll) ->
        tgt = { "_id" : req.params.id }
        console.log "Getting "+req.params.id
        coll.findOne tgt, (err,doc) ->
            console.log doc
            res.send doc
        return
    return

app.post "/", (req,res) ->
    console.log "Inbound post"
    saveorupdate req,res
    return

app.put "/", (req,res) ->
    console.log "Inbound put"
    saveorupdate req,res
    return

app.delete "/:id",(req,res) ->
    console.log "Request to delete #{req.params.id}"
    mydb.collection "standards", (err,coll) ->
        tgt = { "_id" : new mongodb.ObjectID(req.params.id) }
        coll.remove tgt, {safe: true}, (err,cnt) ->
          console.log "Deleted #{cnt} documents"
          if err or cnt==0
            console.log err
            res.send err,404
          else
            console.log "Deleted"
            res.send()
          return
        return
    return

saveorupdate = (req,res) ->
#    console.log util.inspect req.body
    if typeof req.body._id != 'undefined' && req.body._id != null
        console.log typeof req.body._id
        req.body._id = new mongodb.ObjectID(req.body._id)
    mydb.collection "standards", (err,coll) ->
        req.body.updated = new Date()
        console.log "Saving #{req.body.name} with id #{req.body._id}"
        coll.save req.body, {safe : true }, (err, op) ->
            if err==null
                console.log "success"
#                console.log util.inspect op
                if op == 1
                    res.send 200
                else
                    console.log "Sending json object back"
                    res.json op,200
            else
                console.log "error: #{err}"
                res.send err,400
            return
        return
    return

db_connector.open (err,db) ->
    console.log "Mongo: " + db.state
    mydb = db
    app.listen 3000
    console.log "listening on 3000"


