import 'package:flutter/material.dart';
import 'package:zhayra/shared/helpers/text_widget.dart';

class CarPart extends StatelessWidget {
  final bool state;
  final String name;
  final VoidCallback onTap;
  const CarPart(
      {super.key,
      required this.state,
      required this.name,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: state ? Colors.red : Colors.transparent,
                blurRadius: state ? 50 : 0,
              )
            ],
            color: state ? Colors.red : Colors.black.withOpacity(.5),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(name, 20, Colors.white, FontWeight.bold),
                const SizedBox(
                  height: 10,
                ),
                text(state ? "Opened" : "Closed", 15,
                    Colors.white.withOpacity(.5), FontWeight.bold),
              ],
            ),
            const Spacer(),
            Transform.rotate(
              angle: -1.6,
              child: Transform.scale(
                scaleX: 1.0,
                scaleY: 1.0,
                child: Switch(
                  activeColor: Colors.red,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(.1),
                  value: state,
                  onChanged: (value) => onTap(),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
