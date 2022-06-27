import 'package:flutter/material.dart';
 class CustomDropDown extends StatelessWidget {
   final lable;
   final initialvalue;
   final List item;
   final Function(String) onchange;
   const CustomDropDown({Key? key, this.lable, this.initialvalue, required this.item, required this.onchange}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(lable),
         const SizedBox(height: 10,),
         Container(
         width: 300,
           height: 45,
           decoration: BoxDecoration(
               color: Colors.grey[200],
               borderRadius: BorderRadius.circular(5)
           ),
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: DropdownButton(
               value: initialvalue,
               underline: SizedBox(),
               isExpanded: true,
               items:item.map((e){
               return DropdownMenuItem(
               child: Text(e),
               value: e
                      );
                    }).toList(),
               onChanged: (value){
               onchange(value.toString());
               }),
           ),
              )
       ],
     );
   }
 }
