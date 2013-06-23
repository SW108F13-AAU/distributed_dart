part of distributed_dart;

/**
 * Handler, responsible for setting up an isolate
 */
const String _NETWORK_SPAWN_ISOLATE_HANDLER = "spawn_isolate";
_spawnIsolateHandler(dynamic request, NodeAddress sender) {
  var req = new _spawnIsolateRequest.fromJsonMap(request);
  
  // callback, start isolate and send [_RemoteSendPort] to [senderAddress]
  spawn(String uri){
    var sendport = spawnUri(uri);
    var local = new _LocalIsolate.fromSendPort(sendport);
    var remote = local.toRemoteSendPort();
    var response = new _spawnIsolateResponse(req.id, remote);
    response.sendTo(sender);
  }
  // setup local environment and spawn isolate
  req.code.createSpawnUriEnvironment(new Network(sender)).then(spawn);
}

/**
 * Handler, receives a [_RemoteSendPort] as response to a spawnRemoteUri call
 */
const String _NETWORK_SPAWN_RESPONSE_HANDLER = "spawn_isolate";
_spawnIsolateResponseHandler(dynamic request, NodeAddress sender){
  var req = new _spawnIsolateRequest.fromJsonMap(request);
  _RemoteProxy.notify(req.id, req.sendport);
}


class _spawnIsolateRequest {
  final _IsolateId id;
  final _DartProgram code;
  
  _spawnIsolateRequest(this.id,this.code);
  _spawnIsolateRequest.fromJsonMap(Map m):
    id = m['id'],
    code = m['code'];  

  sendTo(NodeAddress node){
    new Network(node).send(_NETWORK_SPAWN_ISOLATE_HANDLER, this);
  }
  Map<String,dynamic> toJson() => { 'id' : id, 'code' : code };
}

class _spawnIsolateResponse {
  final _IsolateId id;
  final _RemoteSendPort sendport;

  _spawnIsolateResponse(this.id,this.sendport);
  _spawnIsolateResponse.fromJsonMap(Map m):
    id = m['id'],
    sendport = m['sendport'];
  
  sendTo(NodeAddress node){
    new Network(node).send(_NETWORK_SPAWN_RESPONSE_HANDLER, this);
  }
  
  Map<String,dynamic> toJson() => { 'id' : id, 'sendport' : sendport };
}
