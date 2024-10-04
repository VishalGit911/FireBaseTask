import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CommonBotton(
    {required isloading, required void Function()? onPressed, required text}) {
  return Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade800,
                fixedSize: Size(400, 60)),
            onPressed: onPressed,
            child: isloading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: TextStyle(fontSize: 20),
                  )),
      ),
    ),
  );
}
