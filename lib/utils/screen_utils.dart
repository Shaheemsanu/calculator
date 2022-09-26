class ScreenUtils {
  static double? screenwidht;
  static double? screenheight ;

  static void screensize( double width,double  height) {
    
    screenheight = height;
    screenwidht = width;
   
  }

  static getscreenheight() {
    return (screenheight);
  }
   static getscreenwidth() {
    return (screenwidht);
  }
}
