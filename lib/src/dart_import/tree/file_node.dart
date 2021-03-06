part of distributed_dart;

/// Represents a file in the tree without dependencies.
class _FileNode {
  String _filePath;
  List<int> _fileHash;

  _FileNode(this._filePath, this._fileHash);
  
  /// File name of the file the object represent.
  String get name => path.basename(_filePath);
  
  /// [Path] to the file the object represent.
  String get filePath => _filePath;
  
  /// SHA1 checksum of the file the object represent as a [String].
  String get fileHashString => _hashListToString(_fileHash);
  
  /// SHA1 checksum of the file the object represent as a [List<int>]. The 
  /// returned list is not growable.
  List<int> get fileHash => _fileHash.toList(growable: false);
  
  /// Insert this object into a [Set] and return the [Set]. If [set] is
  /// provided the method will use this [Set] instead of creating a new one.
  Set<_FileNode> getFileNodes([Set<_FileNode> set]) {
    if (set == null) {
      set = new Set<_FileNode>();
    }
    set.add(this);
    return set;
  }
  
  /// Returns a copy of this object.
  _FileNode get copy => new _FileNode(_filePath, _fileHash);
  
  int get hashCode => _filePath.hashCode;
  
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    
    if (other is _FileNode) {
      if (_filePath.toString() != other._filePath.toString()) return false;
      if (!_compareLists(this._fileHash, other._fileHash)) return false;
      
      return true;
    } else {
      return false;
    }
  }
}