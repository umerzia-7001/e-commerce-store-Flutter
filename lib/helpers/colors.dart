
//palette.dart
import 'package:flutter/material.dart'; 
class Palette { 
  static const MaterialColor mainScheme = const MaterialColor( 
    0xFF8e24aa, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    const <int, Color>{ 
      50: const Color(0xff8e24aa ),//10% 

    }, 
  ); 
  static const MaterialColor secondaryTheme = const MaterialColor( 
    0xFF77b1fa2, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    const <int, Color>{ 
      50: const Color(0xff7b1fa2 ),//10% 
  
    }, 
  ); 


}
