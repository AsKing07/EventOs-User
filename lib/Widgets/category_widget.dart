import 'package:flutter/material.dart';
import 'package:flutter_project/Models/category.dart';
import 'package:flutter_project/config/config.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onCategoryTap;
  const CategoryWidget(
      {Key? key,
      required this.category,
      required this.isSelected,
      required this.onCategoryTap})
      : super(key: key);
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isSelected) {
          widget.onCategoryTap();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 90,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.isSelected ? Colors.white : Color(0x99FFFFFF),
              width: 3),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: widget.isSelected ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.category.icon,
              color: widget.isSelected
                  ? Theme.of(context).primaryColor
                  : AppColors.secondary,
              size: 40,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              widget.category.name!,
              style: widget.isSelected
                  ? const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF4700),
                    )
                  : TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
