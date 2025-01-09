import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controller/popup_controller.dart';
import '../controller/popup_controller_event.dart';
import '../controller/popup_controller_impl.dart';
import '../popup_spec.dart';
import 'popup_event.dart';
import 'popup_state.dart';
import 'popup_state_impl.dart';
import 'package:provider/provider.dart';

/// Looks for a [PopupState] in the current BuildContext or creates a new one.
/// Events emitted by the provided [PopupController] are applied to the
/// [PopupState].
class PopupScope extends StatefulWidget {
  /// If provided may be used to show/hide popups.
  final PopupController? popupController;

  /// The PopupSpecs for which a popup should be initially visible.
  final List<PopupSpec>? initiallySelected;

  /// An optional callback which can be used to react to [PopupControllerEvent]s. The
  /// [selectedMarkers] is the list of [Marker]s which are selected *after*
  /// the [event] is applied.
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  /// The child widget of the PopupScope.
  final Widget child;

  /// Creates a PopupState for descendants of this widget.
  const PopupScope({
    super.key,
    this.popupController,
    this.initiallySelected,
    this.onPopupEvent,
    required this.child,
  });

  @override
  State<PopupScope> createState() => _PopupScopeState();
}

class _PopupScopeState extends State<PopupScope> {
  bool _initialized = false;
  late final PopupStateImpl _popupState;

  StreamSubscription<PopupEvent>? _popupStateSubscription;
  StreamSubscription<PopupControllerEvent>? _popupControllerSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Find or create the PopupState.
    if (_initialized) return;
    _popupState = PopupStateImpl(
      initiallySelected: widget.initiallySelected ?? <PopupSpec>[],
    );

    // Set the state listener.
    _setPopupStateListener();

    // Start listening to the controller.
    _setPopupControllerListener();

    _initialized = true;
  }

  @override
  void didUpdateWidget(covariant PopupScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.popupController != widget.popupController) {
      _setPopupControllerListener();
    }

    if ((oldWidget.onPopupEvent == null) != (widget.onPopupEvent == null)) {
      _setPopupStateListener();
    }
  }

  void _setPopupStateListener() {
    _popupStateSubscription?.cancel();
    _popupStateSubscription = null;

    if (widget.onPopupEvent != null) {
      _popupStateSubscription = _popupState.stream.listen((PopupEvent popupEvent) {
        widget.onPopupEvent?.call(popupEvent, _popupState.selectedMarkers);
      });
    }
  }

  void _setPopupControllerListener() {
    _popupControllerSubscription?.cancel();
    _popupControllerSubscription = null;

    final PopupController? popupController = widget.popupController;
    if (popupController != null) {
      _popupControllerSubscription = (popupController as PopupControllerImpl).stream.listen((PopupControllerEvent event) {
        _popupState.applyEvent(event);
      });
    }
  }

  @override
  void dispose() {
    _popupState.dispose();
    _popupControllerSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PopupState>.value(
      value: _popupState,
      child: Builder(
        builder: (BuildContext context) => widget.child,
      ),
    );
  }
}
