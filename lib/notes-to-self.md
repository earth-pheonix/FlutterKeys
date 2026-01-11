
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
The following assertion was thrown during performLayout():
RenderFlex children have non-zero flex but incoming width constraints are unbounded.
When a row is in a parent that does not provide a finite width constraint, for example if it is in a
horizontal scrollable, it will try to shrink-wrap its children along the horizontal axis. Setting a
flex on a child (e.g. using Expanded) indicates that the child is to expand to fill the remaining
space in the horizontal direction.
These two directives are mutually exclusive. If a parent is to shrink-wrap its child, the child
cannot simultaneously expand to fit its parent.
Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible
children (using Flexible rather than Expanded). This will allow the flexible children to size
themselves to less than the infinite remaining space they would otherwise be forced to take, and
then will cause the RenderFlex to shrink-wrap the children rather than expanding to fit the maximum
constraints provided by the parent.
If this message did not help you determine the problem, consider using debugDumpRenderTree():
  https://flutter.dev/to/debug-render-layer
  https://api.flutter.dev/flutter/rendering/debugDumpRenderTree.html
The affected RenderFlex is:
  RenderFlex#f8ea4 relayoutBoundary=up34 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE(creator: Row ← Padding ← SizedBox ← DefaultTextStyle ← Stack ← Listener ←
  RawGestureDetector ← GestureDetector ← Semantics ← DefaultSelectionStyle ← Builder ← MouseRegion ← ⋯, parentData: offset=Offset(0.0, 0.0) (can use size), constraints:
  BoxConstraints(unconstrained), size: MISSING, direction: horizontal, mainAxisAlignment: spaceBetween, mainAxisSize: min, crossAxisAlignment: center, textDirection:
  ltr, verticalDirection: down, spacing: 0.0)
The creator information is set to:
  Row ← Padding ← SizedBox ← DefaultTextStyle ← Stack ← Listener ← RawGestureDetector ←
  GestureDetector ← Semantics ← DefaultSelectionStyle ← Builder ← MouseRegion ← ⋯
The nearest ancestor providing an unbounded width constraint is: _RenderSingleChildViewport#6552c relayoutBoundary=up22 NEEDS-LAYOUT NEEDS-PAINT
NEEDS-COMPOSITING-BITS-UPDATE:
  needs compositing
  creator: _SingleChildViewport ← IgnorePointer-[GlobalKey#58df0] ← Semantics ← Listener ←
    _GestureSemantics ← RawGestureDetector-[LabeledGlobalKey<RawGestureDetectorState>#0da0a] ←
    Listener ← _ScrollableScope ← _ScrollSemantics-[GlobalKey#07c0a] ←
    NotificationListener<ScrollMetricsNotification> ← Scrollable ← SingleChildScrollView ← ⋯
  parentData: <none> (can use size)
  constraints: BoxConstraints(0.0<=w<=1053.0, 0.0<=h<=Infinity)
  size: MISSING
  offset: Offset(-0.0, 0.0)
See also: https://flutter.dev/unbounded-constraints
If none of the above helps enough to fix this problem, please don't hesitate to file a bug:
  https://github.com/flutter/flutter/issues/new?template=02_bug.yml

The relevant error-causing widget was:
  DropdownButton<int>
  DropdownButton:file:///Users/pheonix/flutterkeysaac/lib/Variables/settings/ui_settings.dart:834:9

When the exception was thrown, this was the stack:
#0      RenderFlex.performLayout.<anonymous closure> (package:flutter/src/rendering/flex.dart:1252:9)
#1      RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1255:6)
#2      RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#3      RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:243:12)
#4      RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#5      RenderConstrainedBox.performLayout (package:flutter/src/rendering/proxy_box.dart:293:14)
#6      RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#7      ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#8      RenderStack._computeSize (package:flutter/src/rendering/stack.dart:645:43)
#9      RenderStack.performLayout (package:flutter/src/rendering/stack.dart:680:12)
#10     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#11     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#12     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#13     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#14     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#15     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#16     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#17     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#18     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#19     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#20     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#21     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#22     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#23     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#24     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#25     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#26     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#27     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#28     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#29     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#30     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#31     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#32     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#33     _RenderSingleChildViewport.performLayout (package:flutter/src/widgets/single_child_scroll_view.dart:502:14)
#34     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#35     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#36     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#37     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#38     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#39     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#40     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#41     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#42     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#43     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#44     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#45     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#46     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#47     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#48     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#49     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#50     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#51     RenderConstrainedBox.performLayout (package:flutter/src/rendering/proxy_box.dart:293:14)
#52     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#53     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#54     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#55     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#56     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#57     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:243:12)
#58     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#59     RenderPositionedBox.performLayout (package:flutter/src/rendering/shifted_box.dart:465:14)
#60     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#61     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#62     RenderOffstage.performLayout (package:flutter/src/rendering/proxy_box.dart:3848:13)
#63     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#64     RenderPositionedBox.performLayout (package:flutter/src/rendering/shifted_box.dart:465:14)
#65     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#66     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#67     _RenderCustomClip.performLayout (package:flutter/src/rendering/proxy_box.dart:1481:11)
#68     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#69     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:62:11)
#70     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:1161:28)
#71     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:1257:32)
#72     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#73     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:243:12)
#74     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#75     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#76     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#77     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#78     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#79     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:115:18)
#80     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#81     RenderSliverList.performLayout.advance (package:flutter/src/rendering/sliver_list.dart:253:18)
#82     RenderSliverList.performLayout (package:flutter/src/rendering/sliver_list.dart:283:12)
#83     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#84     RenderSliverEdgeInsetsPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:133:12)
#85     RenderSliverPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:371:11)
#86     RenderObject.layout (package:flutter/src/rendering/object.dart:2775:7)
#87     RenderViewportBase.layoutChildSequence (package:flutter/src/rendering/viewport.dart:673:13)
#88     RenderViewport._attemptLayout (package:flutter/src/rendering/viewport.dart:1684:12)
#89     RenderViewport.performLayout (package:flutter/src/rendering/viewport.dart:1575:20)
#90     RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2623:7)
#91     PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1170:18)
#92     PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1183:15)
#93     RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:629:23)
#94     WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:1264:13)
#95     RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:495:5)
#96     SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1434:15)
#97     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1347:9)
#98     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1200:5)
#99     _invoke (dart:ui/hooks.dart:356:13)
#100    PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:444:5)
#101    _drawFrame (dart:ui/hooks.dart:328:31)

The following RenderObject was being processed when the exception was fired: RenderFlex#f8ea4 relayoutBoundary=up34 NEEDS-LAYOUT NEEDS-PAINT
NEEDS-COMPOSITING-BITS-UPDATE:
  creator: Row ← Padding ← SizedBox ← DefaultTextStyle ← Stack ← Listener ← RawGestureDetector ←
    GestureDetector ← Semantics ← DefaultSelectionStyle ← Builder ← MouseRegion ← ⋯
  parentData: offset=Offset(0.0, 0.0) (can use size)
  constraints: BoxConstraints(unconstrained)
  size: MISSING
  direction: horizontal
  mainAxisAlignment: spaceBetween
  mainAxisSize: min
  crossAxisAlignment: center
  textDirection: ltr
  verticalDirection: down
  spacing: 0.0
This RenderObject had the following descendants (showing up to depth 5):
    child 1: RenderIndexedStack#b7b4f NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
      child 1: _RenderVisibility#bf014 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
        child: RenderIgnorePointer#e454b NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
          child: RenderConstrainedBox#f46af NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
            child: RenderIgnorePointer#2c1ea NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
    child 2: RenderSemanticsAnnotations#33ada NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
      child: RenderExcludeSemantics#516ba NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
        child: RenderConstrainedBox#c798a NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
          child: RenderPositionedBox#b77f5 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
            child: RenderParagraph#e464d NEEDS-LAYOUT NEEDS-PAINT
════════════════════════════════════════════════════════════════════════════════════════════════════

Another exception was thrown: RenderBox was not laid out: RenderFlex#f8ea4 relayoutBoundary=up34 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPadding#fa830 relayoutBoundary=up33 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderConstrainedBox#dc692 relayoutBoundary=up32 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderStack#c9f06 relayoutBoundary=up31 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPointerListener#f830c relayoutBoundary=up30 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderSemanticsAnnotations#02318 relayoutBoundary=up29 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderMouseRegion#6bc3c relayoutBoundary=up28 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderSemanticsAnnotations#d241c relayoutBoundary=up27 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderSemanticsAnnotations#e7c35 relayoutBoundary=up26 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderFlex#24a55 relayoutBoundary=up25 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderFlex#458f9 relayoutBoundary=up24 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderFlex#b3385 relayoutBoundary=up23 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: _RenderSingleChildViewport#6552c relayoutBoundary=up22 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderIgnorePointer#bb6b0 relayoutBoundary=up21 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderSemanticsAnnotations#13dad relayoutBoundary=up20 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPointerListener#83fcd relayoutBoundary=up19 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderSemanticsGestureHandler#8ccc1 relayoutBoundary=up18 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPointerListener#3b985 relayoutBoundary=up17 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: _RenderScrollSemantics#7cd93 relayoutBoundary=up16 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderFlex#a4087 relayoutBoundary=up15 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderConstrainedBox#b3645 relayoutBoundary=up14 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderFlex#e93c1 relayoutBoundary=up13 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPadding#a89ae relayoutBoundary=up12 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderPositionedBox#8fcb9 relayoutBoundary=up11 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: RenderOffstage#8e4c5 relayoutBoundary=up10 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown: RenderBox was not laid out: _RenderSingleChildViewport#6552c relayoutBoundary=up22 NEEDS-PAINT
Another exception was thrown: RenderBox was not laid out: RenderPadding#c42af NEEDS-LAYOUT NEEDS-PAINT
Another exception was thrown: RenderBox was not laid out: RenderOffstage#8e4c5 relayoutBoundary=up10
Another exception was thrown: RenderBox was not laid out: RenderPadding#c42af NEEDS-LAYOUT NEEDS-PAINT
Lost connection to device.