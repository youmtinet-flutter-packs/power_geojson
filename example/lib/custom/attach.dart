import "package:power_geojson/power_geojson.dart";

/*    
{
    "Attachment": "iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAyFJREFUOE8Nkt1P2ncUxn9/xi6WZVmTrXXaaq0IgsiL1YlMnS+rk4roQEReRBEVHPMLiqWgWHwtRcuqofRltW3WZcmazKR7yRYvtsU0vV56t2TJduFVLz77Xpyccy7O85znPEe5t3vT+Li4I/KLEVGQkY/Pynpe7MQjYiMWEjH3kHhULon/Tk/F6Zs34rfjY3FyciL+ev1avHz1ShwfPRX3S0WxdackTmSvrM5OZO5lFylcE+wsRtlPxbi7EmdvaZ6C7BM+J78cPefff/7m5a8/89OLHzko3SWVyRKOzFPc2+XF0Q8cHj7m9z/+RIm7B8XeepaR8QCaJhM9He1sx0KkQ+Oshn2Ehwd49uQh3z39mqR3lPzmBouJOF2dnVTWqjBZOpiLxXEFwkzNJ1E2FmbFQeEmnw8N8uGFGs6crWDOZWdFAqanxgja+zl8cMBX+XWcFjP7knx3LU1w2IaxUYfBYMDj9dHd04u2pQulcD0unj8ssRWP0Ge5jKq2hmnHZ6zN+kmMD+O3X+HJ/TvsbmYQoTGuRaZIzkyyHPISsHUTGR/h+2ePeLC7TXd3H0p5IyO+2d8jFwsTdQ8xJQGSARdrM1KurP2Ofm4kI9xYnmd7bYlb62lupRJk5DkcH18mtxTl28MScz43kx43SlFuWM6lWfC5sJr1hBxXWJnykJHh7LIQnXBSyCXZXEmws5qgXNxi2uOkX6oZaDPitvWynU1zkF1mbnwURUoTqWiYVr2G9iY1Ub+XBf8Yaf8IXYYG5mTevB7j9voyuUySWemsqbWdt95+h94WA20GLXqjGf+QjR5JouR3CuKqY5Q+ayva+jrOVauxOYNM+4P0d1pZ/XJCmhBnKSEYdPm4qDVRrTHw7tlK6tRa6rV6zlScp76hkfeloUqmUBY2bwR1cwc1eguXzJ/QNuDl6oR8hVCCL6Z9xMJ+GswWqlRaNMaP0JgsnFc3cq5WzQfVdVTVNXBRZ+S9imoU10wyNZPK0/zpKNZBP10j01jtQTodk6ha+ujptzMZ8FCp0snhS9TqTNQbWiW4jqp6HZUS7IJGj6qpWRJZ+B+gkfC0tSqV4wAAAABJRU5ErkJggg=="
}
*/

class AttachmentSingle {
  final String attachment;
  AttachmentSingle({
    required this.attachment,
  });

  AttachmentSingle copyWith({
    String? attachment,
  }) {
    return AttachmentSingle(
      attachment: attachment ?? this.attachment,
    );
  }

  Map<String, Object?> toJson() {
    return {
      AttachmentSingleEnum.Attachment.name: attachment,
    };
  }

  factory AttachmentSingle.fromJson(Map<String, Object?> json) {
    return AttachmentSingle(
      attachment: json[AttachmentSingleEnum.Attachment.name] as String,
    );
  }

  factory AttachmentSingle.fromMap(Map<String, Object?> json, {String? id}) {
    return AttachmentSingle(
      attachment: json[AttachmentSingleEnum.Attachment.name] as String,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'AttachmentSingle(Attachment:$attachment)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentSingle &&
        other.runtimeType == runtimeType &&
        other.attachment == attachment;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      attachment,
    );
  }
}

enum AttachmentSingleEnum {
  Attachment,
  none,
}

extension AttachmentSingleSort on List<AttachmentSingle> {
  List<AttachmentSingle> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == AttachmentSingleEnum.Attachment.name) {
          // unsortable

          String akey = a.attachment;
          String bkey = b.attachment;

          return fact * (bkey.compareTo(akey));
        }

        return 0;
      });
  }
}
