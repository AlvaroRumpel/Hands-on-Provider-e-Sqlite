import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/todo_list_icons.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validador;

  TodoListField({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.validador,
  })  : assert(
          obscureText ? suffixIconButton == null : true,
          'obscureText não pode ser enviado em conjunto com suffixIconButton',
        ),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: obscureTextVN,
        builder: (_, obscureTextValue, child) {
          return TextFormField(
            controller: controller,
            validator: validador,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              isDense: true,
              suffixIcon: suffixIconButton ??
                  (obscureText
                      ? IconButton(
                          onPressed: () =>
                              obscureTextVN.value = !obscureTextValue,
                          icon: Icon(
                            obscureTextValue
                                ? TodoListIcons.eye
                                : TodoListIcons.eye_slash,
                            size: 16,
                          ),
                        )
                      : null),
            ),
            obscureText: obscureTextValue,
          );
        });
  }
}
