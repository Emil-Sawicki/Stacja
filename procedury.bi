'=============================================================================='
'                               EKRAN TYTULOWY                                 '
'=============================================================================='
SUB tytul_logo
   COLOR 0, 2: LOCATE 1, 1
   PRINT "                                                                                "
   PRINT "    SSSSSSSS  TTTTTTTTTTTT   AAAAAAA     CCCCCCCC  JJJJJJJJJJJ   AAAAAAA        "
   PRINT "   S::::::::S T::::::::::T  A:::::::A   C::::::::C J:::::::::J  A:::::::A       "
   PRINT "  S:::SSSSSS  TTTTT::TTTTT A:::AAA:::A C:::CCCCCC  JJJJJJJJ::J A:::AAA:::A      "
   PRINT "  S::S            T::T     A::A   A::A C::C               J::J A::A   A::A      "
   PRINT "  S:::SSSSS       T::T     A::A   A::A C::C               J::J A::A   A::A      "
   PRINT "   S:::::::S      T::T     A::AAAAA::A C::C               J::J A::AAAAA::A      "
   PRINT "    SSSSS:::S     T::T     A:::::::::A C::C               J::J A:::::::::A      "
   PRINT "         S::S     T::T     A::AAAAA::A C::C               J::J A::AAAAA::A      "
   PRINT "   SSSSSS:::S     T::T     A::A   A::A C:::CCCCCC   JJJJJJ:::J A::A   A::A      "
   PRINT "  S::::::::S      T::T     A::A   A::A  C::::::::C J::::::::J  A::A   A::A      "
   PRINT "   SSSSSSSS       TTTT     AAAA   AAAA   CCCCCCCC   JJJJJJJJ   AAAA   AAAA      "
   PRINT "                                                                                "
   PRINT "                    symulator prowadzenia ruchu pociagow                        "
   PRINT "                                                                                "
END SUB
'=============================================================================='
'                                MENU GLOWNE                                   '
'=============================================================================='
SUB TitleMenu (CurX, CurY)
   IF CurY = 17 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
      COLOR 7, 0: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis w negatywie
   ELSE
      COLOR 0, 7: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis zwykly
      COLOR 4: LOCATE 17, 36: PRINT "N" 'czerwona litera
   END IF
   IF CurY = 19 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
      COLOR 7, 0: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis w negatywie
   ELSE
      COLOR 0, 7: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis zwykly
      COLOR 4: LOCATE 19, 36: PRINT "W" 'czerwona litera
   END IF
   IF CurY = 21 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
      COLOR 7, 0: LOCATE 21, 31: PRINT "      Edytor      " 'napis w negatywie
   ELSE
      COLOR 0, 7: LOCATE 21, 31: PRINT "      Edytor      " 'napis zwykly
      COLOR 4: LOCATE 21, 37: PRINT "E" 'czerwona litera
   END IF
   IF CurY = 23 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
      COLOR 7, 0: LOCATE 23, 31: PRINT "      Koniec      " 'napis w negatywie
   ELSE
      COLOR 0, 7: LOCATE 23, 31: PRINT "      Koniec      " 'napis zwykly
      COLOR 4: LOCATE 23, 37: PRINT "K" 'czerwona litera
   END IF
END SUB
'========================================================================================='
'               PROCEDURY - EDYTOR MAP - TRYB PELNY - WARSTWA SCHEMATU TOROW              '
'========================================================================================='
'========================================================================================='
'                     PROCEDURY - EDYTOR MAP - TRYB PELNY - PRZYBORNIK                    '
'========================================================================================='
'------------------------------------------------------------------------------'
'                             PROCEDURY UNIWERSALNE                            '
'------------------------------------------------------------------------------'
SUB CurCoord (CurX, CurY)
   CurY = _MOUSEY: CurX = _MOUSEX
   COLOR 4, 1: LOCATE 30, 56: PRINT "wiersz="; CurY; 'OPCJA DEBUG
   LOCATE 30, 67: PRINT ", kolumna="; CurX; 'OPCJA DEBUG
END SUB
'====================================================================================================='
'                                    PROCEDURY UNIWERSALNE - UNCLICK                                  '
'====================================================================================================='
SUB Unclick '                      \
   DO '                              \   uzyc po kazdym _MOUSEBUTTON(1)
      z = _MOUSEINPUT '                > wstrzymuje program do momentu zakonczenia klikniecia
   LOOP UNTIL NOT _MOUSEBUTTON(1) '  /   zmienna "z" musi tu byc i sluzy tylko do poprawnego dzialania
END SUB '                          /

SUB etykieta_mapa_koordynaty 'PRZEROBIC NA WSPOLNA PROCEDURE DLA WSZYSTKICH ETYKIET
   DO
      DO: _LIMIT 500
         CurCoord CurX, CurY
         FrameDraw 3, 3, 1, 18, 0, 3, CHR$(196), CHR$(196), CHR$(179)
         COLOR 0, 3: LOCATE 4, 4: PRINT " koordynaty kursora ";
      LOOP WHILE _MOUSEINPUT
   LOOP UNTIL CurY <> 2 OR CurX < 4 OR CurX > 26
END SUB

'====================================================================================='
'                       PROCEDURY UNIWERSALNE - RYSOWANIE RAMEK                       '
'====================================================================================='
SUB FrameDraw (PosX, PosY, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$)
   COLOR FrameCharColor, FrameBackColor
   'narozniki ustalane automatycznie na podstawie ksztaltu bokow
   LOCATE PosY, PosX 'lewy gorny naroznik
   IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(218);
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(213);
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN PRINT CHR$(201);
   LOCATE PosY, PosX + TxtLength + 1 'prawy gorny naroznik
   IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(191);
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(184);
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN PRINT CHR$(187);
   LOCATE PosY + LineCount + 1, PosX 'lewy dolny naroznik
   IF FrameSide$ = CHR$(179) THEN PRINT CHR$(192);
   IF FrameSide$ = CHR$(186) THEN PRINT CHR$(200);
   LOCATE PosY + LineCount + 1, PosX + TxtLength + 1 'prawy dolny naroznik
   IF FrameSide$ = CHR$(179) THEN PRINT CHR$(217);
   IF FrameSide$ = CHR$(186) THEN PRINT CHR$(188);
   FOR i = 1 TO TxtLength 'rysuj poziome scianki ramki
      LOCATE PosY, PosX + i: PRINT FrameTop$;
      LOCATE PosY + LineCount + 1, PosX + i: PRINT FrameBottom$;
   NEXT
   FOR i = 1 TO LineCount 'rysuj pionowe scianki ramki
      LOCATE PosY + i, PosX: PRINT FrameSide$;
      LOCATE PosY + i, PosX + TxtLength + 1: PRINT FrameSide$;
   NEXT
END SUB

SUB pasek_informacyjny (pasek_informacyjny_tresc)
   'rysuj pasek
   'wpisuj tresc
END SUB
