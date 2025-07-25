import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseTheme {
  // Color get backGroundColor => fromHex('#6e3e92');
  Color get backGroundColor => fromHex('#009575');

  Color get backGroundColorGreen => fromHex('#4baf67');

  Color get foramTitleGroundColor => fromHex('#b662f5');

  Color get forumBackGround => fromHex('#6c3e91');

  Color get textButton => fromHex('#787878');

  Color get white => fromHex('#FFFFFFFF');

  Color get black => fromHex('#000000');

  Color get red => fromHex('#FF0000');

  Color get senderColor => fromHex('#d9fdd3');

  Color get chatBragroundColor => fromHex('#efeae2');

  Color get textColorOnBoarding => fromHex('#5D777D');

  Color get notActive => fromHex('#e1d6e6');

  // Color get active => fromHex('#009575');
  Color get active => fromHex('#18332C');

  Color get active2 => fromHex('#005240');

  Color get popUpSelected => fromHex('#00BA93');


  // Color get buttonGreen => fromHex('#3db06d');
  Color get buttonGreen => fromHex('#009575');
  Color get eyeOnOff => fromHex('#1C1B1F');

  Color get textColor1 => fromHex('#383838');

  Color get outLineBorderEditTextColor => fromHex('#D9D9D9');

  Color get editTextBackgroundColor => fromHex('#FFFFFF');

  Color get textColor2 => fromHex('#262F31');

  Color get textColor3 => fromHex('#aeaeae');

  Color get borderColor => fromHex('#8e8e8e');

  Color get textColor4 => fromHex('#5f5f5f');

  Color get textColor5 => fromHex('#FCFCFC');

  Color get chatBorderColr => fromHex('#EEE5E9');

  Color get textColor6 => fromHex('#909090');

  void showCircularDialog(BuildContext context) {
    CircularDialog.showLoadingDialog(context);
  }
}

BaseTheme get appTheme => BaseTheme();

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class CircularDialog {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              child: CircularProgressIndicator(color: appTheme.backGroundColor),
            ),
            onWillPop: () async {
              return false;
            });
      },
      barrierDismissible: false,
    );
  }
}

noInternetDialog(
    // {String title = "Error", String desc = "No Internet connection, Please check Internet connection "}) {
    {String title = "Error",
    String desc =
        "Sin conexión a Internet, compruebe la conexión a Internet"}) {
  return Get.defaultDialog(
      barrierDismissible: false,
      title: title,
      content: Text(desc),
      buttonColor: appTheme.backGroundColor,
      // textConfirm: "Ok",
      textConfirm: "De acuerdo",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      });
}

class Constants {
  static const submitButton = 'Confirmar contraseña';
  static const cancelButton = 'Cancelar';
  static const okButton = ' De acuerdo';
  static const acceptButton = 'Aceptar';
  static const deletetButton = 'Borrar';
  static const goButton = 'Salir';
  static const updatePassword = 'Actualiza contraseña';

  // static const something = 'Something went to Wrong';
  static const something = 'Algo salió mal';

  // static const TryAgain = 'Please Try Again Later';
  static const TryAgain = 'Por favor, inténtelo de nuevo más tarde';
  static const passwordDoNotMatch =
      'contraseña y confirme que la contraseña no coincide.';

  // static const Country = 'Country List Not Found';
  static const Country = 'Lista de país no encontrada';

  // static const Goal = 'Goal List not Found';
  static const Goal = 'Lista de objetivos no encontrada';

  // static const answer = 'Your Answer';
  static const answer = 'Tu Respuesta';
  static const answerEnter = 'Por favor ingrese la respuesta';

  // static const reviewwapp = 'Review My Application';
  static const reviewwapp = 'Revisar mi solicitud';

  // static const rateapp = 'Rate My Application';
  static const rateapp = ' Enviar Reseña';

  // static const reviewapp = 'Enter Your Review Here';
  static const reviewapp = 'Ingrese su reseña aquí';

  // static const forum = 'Your Forum';
  static const forum = 'Tu Foro';

  // static const submit = 'Submitted Successfully';
  static const submitSucess = 'Enviado satisfactoriamente';

  // static const otpSend = 'OTP Sent to your Registerd Email';
  static const otpSend = 'OTP enviado a su correo electrónico registrado';

  // static const otpexpire = 'OTP expire in 2 minutes';
  // static const otpexpire = 'OTP caduca en 2 minutos';
  static const otpexpire = 'El mensaje puede estar en la carpeta de spam.';

  // static const email = 'Email Not Found';
  static const email = 'El correo electrónico no encontrado';

  // static const emailEntered = 'Entered Email Is Invalid';
  static const emailEntered = 'El correo electrónico ingresado no es válido';

  // static const pswUpdate = 'Your Password Update Sucessfully';
  static const pswUpdate = 'Su contraseña fue actualizada con éxito';

  // static const pswUpdate = 'Your Profile Update Sucessfully';
  static const profileUpdate = 'Su perfil se actualizó exitosamente';

  // static const fail = 'Failed';
  static const fail = 'Fallido';

  // static const otherLogin = 'Please try other methode to login';
  static const otherLogin = 'Prueba con otro método para iniciar sesión';
  static const addforum = 'Por favor ingrese el título y la descripción';
  static const loginRequired =
      'Se requiere inicio de sesión Por favor, inicie sesión';
}
