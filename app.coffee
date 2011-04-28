connect = require('./lib/connect')
coffeekup = require('./lib/coffeekup')
meryl = require('meryl')
now = require("now")

meryl.p(connect.static('public'))

meryl.get '/', (req, resp) ->
  resp.render 'layout',
    content: 'index'

server = connect(
  meryl.cgi
    templateExt: '.coffee'
    templateFunc: coffeekup.adapters.meryl
    templateDir: 'views'
    connect.logger()
)
#server.listen(80)
server.listen(8888)

console.log 'listening...'

everyone = now.initialize(server)
everyone.connected(  (message) ->
  everyone.now.receiveMessage(this.now.name, message)
)
everyone.now.distributeMessage = (message) ->
  everyone.now.receiveMessage(this.now.name, message)
everyone.now.updateElement = (className, top, left) ->
  everyone.now.receiveElement(className, top, left)
everyone.now.distributeSound = (audiotag) ->
  everyone.now.receiveSound(audiotag)

