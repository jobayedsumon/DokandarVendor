import 'package:dokandar_shop/features/splash/controllers/splash_controller.dart';
import 'package:dokandar_shop/helper/date_converter_helper.dart';
import 'package:dokandar_shop/util/dimensions.dart';
import 'package:dokandar_shop/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTimePickerWidget extends StatefulWidget {
  final String title;
  final String? time;
  final Function(String?) onTimeChanged;
  const CustomTimePickerWidget({super.key, required this.title, required this.time, required this.onTimeChanged});

  @override
  State<CustomTimePickerWidget> createState() => _CustomTimePickerWidgetState();
}

class _CustomTimePickerWidgetState extends State<CustomTimePickerWidget> {
  String? _myTime;

  @override
  void initState() {
    super.initState();

    _myTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        widget.title, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      InkWell(
        onTap: () async {
          TimeOfDay? time = await showTimePicker(
            context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: Get.find<SplashController>().configModel!.timeformat == '24',
                ),
                child: child!,
              );
            },
          );
          if(time != null) {
            setState(() {
              _myTime = DateConverterHelper.convertTimeToTime(DateTime(DateTime.now().year, 1, 1, time.hour, time.minute));
            });
            widget.onTimeChanged(_myTime);
          }
        },
        child: Container(
          height: 50, alignment: Alignment.center,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 5))],
          ),
          child: Row(children: [

            Text(
              _myTime != null ? DateConverterHelper.convertStringTimeToTime(_myTime!) : 'pick_time'.tr, style: robotoRegular,
              maxLines: 1,
            ),
            const Expanded(child: SizedBox()),

            const Icon(Icons.access_time, size: 20),

          ]),
        ),
      ),

    ]);
  }
}
