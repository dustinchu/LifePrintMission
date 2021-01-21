class LayerEditState {
  static final LayerEditState _layerEditState = new LayerEditState._internal();
  LayerEditState._internal();
  static LayerEditState get instance => _layerEditState;
  bool state =false;
}
