part of distributed_dart;

/**
 * set location of received .dart files
 * if not intialized, a default directory in a os specific cache folder
 * is returned
 */
String _workDirPath;

void registerNode(NodeAddress node, [bool allowremote=false, String workdir]) {
  //kregisterNode must not be called more than once
  if(NodeAddress._localhost != null) {
    throw new UnsupportedOperationError("Can only register node once");
  }

  // set local identification
  NodeAddress._localhost = node;
  
  // set path to where to store received files
  _workDirPath = (workdir == null) ? _getDefaultWorkDir() : workdir;
  
  // setup requesthandlers
  _RequestHandler.allow(_NETWORK_FILE_HANDLER);
  _RequestHandler.allow(_NETWORK_FILE_REQUEST_HANDLER);
  _RequestHandler.allow(_NETWORK_ISOLATE_DATA_HANDLER);
  
  if(allowremote){
    _RequestHandler.allow(_NETWORK_SPAWN_ISOLATE_HANDLER);
    _RequestHandler.allow(_NETWORK_SPAWN_RESPONSE_HANDLER);
  }
  
  // start listening for incomming requests
  _Network._initServer();
}

/// Returns a default value for working directory based on running OS.
String _getDefaultWorkDir() {
  String defaultPath;

  if (Platform.operatingSystem == "windows"){
    defaultPath = Platform.environment['LOCALAPPDATA'];
    defaultPath = path.join(defaultPath, 'distributed_dart');
  } else {
    defaultPath = Platform.environment['HOME'];
    defaultPath = path.join(defaultPath, '.cache/distributed_dart');
  }

  return defaultPath;
}

