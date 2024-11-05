'------------------------------------------------------------------------------'
'                              EKRAN TYTULOWY                                  '
'------------------------------------------------------------------------------'

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

'====================================================================================='
'             PROCEDURY - EDYTOR MAP - TRYB PELNY - WARSTWA SCHEMATU TOROW            '
'====================================================================================='
'========================================================================================='
'       PROCEDURY - EDYTOR MAP - TRYB PELNY - TABLICA ELEMENTOW DO RYSOWANIA MAPY         '
'========================================================================================='
SUB EditFullElems (PosX, PosY, CurX, CurY, TempX, TempY, Char$, CharColor)
   COLOR 7, 1
   LOCATE PosY, PosX: PRINT " elementy  ";
   LOCATE PosY + 1, PosX: PRINT " torowiska ";
   LOCATE PosY + 2, PosX: PRINT "           "; 'proste tory
   LOCATE PosY + 3, PosX: PRINT "           "; 'rozjazdy
   LOCATE PosY + 4, PosX: PRINT "           "; 'uporki
   LOCATE PosY + 5, PosX: PRINT "           "; 'wykolejnica i tarcze manewrowe
   LOCATE PosY + 6, PosX: PRINT "           "; 'semafory
   LOCATE PosY + 7, PosX: PRINT "           ";
   'DOKLEPAC WYBOR ELEMENTU KLAWISZEM + OPIS SKROTU W RAMCE
   DIM TableElemsY(20), TableElemsX(20), TableElemsChar(20) 'tabela znakow do uzytku w edytorze
   'umieszczenie znakow w tabeli - do rekordu o numerze (i) laduje kod znaku i jego polozenie na ekranie
   TableElemsY(1) = PosY + 2: TableElemsX(1) = PosX + 2: TableElemsChar(1) = 45 '-
   TableElemsY(2) = PosY + 2: TableElemsX(2) = PosX + 4: TableElemsChar(2) = 47 '/
   TableElemsY(3) = PosY + 2: TableElemsX(3) = PosX + 6: TableElemsChar(3) = 124 '|
   TableElemsY(4) = PosY + 2: TableElemsX(4) = PosX + 8: TableElemsChar(4) = 92 '\
   TableElemsY(5) = PosY + 3: TableElemsX(5) = PosX + 2: TableElemsChar(5) = 192 'À
   TableElemsY(6) = PosY + 3: TableElemsX(6) = PosX + 4: TableElemsChar(6) = 191 '¿
   TableElemsY(7) = PosY + 3: TableElemsX(7) = PosX + 6: TableElemsChar(7) = 218 'Ú
   TableElemsY(8) = PosY + 3: TableElemsX(8) = PosX + 8: TableElemsChar(8) = 217 'Ù
   TableElemsY(9) = PosY + 4: TableElemsX(9) = PosX + 2: TableElemsChar(9) = 93 ']
   TableElemsY(10) = PosY + 4: TableElemsX(10) = PosX + 4: TableElemsChar(10) = 91 '[
   TableElemsY(11) = PosY + 4: TableElemsX(11) = PosX + 6: TableElemsChar(11) = 127 ' granica przetaczania
   TableElemsY(12) = PosY + 4: TableElemsX(12) = PosX + 8: TableElemsChar(12) = 88 'X skrzyzowanie torow
   TableElemsY(13) = PosY + 5: TableElemsX(13) = PosX + 2: TableElemsChar(13) = 94 '^ wykolejnica
   TableElemsY(14) = PosY + 5: TableElemsX(14) = PosX + 4: TableElemsChar(14) = 60 '<
   TableElemsY(15) = PosY + 5: TableElemsX(15) = PosX + 6: TableElemsChar(15) = 62 '>
   TableElemsY(16) = PosY + 5: TableElemsX(16) = PosX + 8: TableElemsChar(16) = 42 '* kasowanie
   TableElemsY(17) = PosY + 6: TableElemsX(17) = PosX + 2: TableElemsChar(17) = 16 '
   TableElemsY(18) = PosY + 6: TableElemsX(18) = PosX + 4: TableElemsChar(18) = 17 '
   TableElemsY(19) = PosY + 6: TableElemsX(19) = PosX + 6: TableElemsChar(19) = 30 '
   TableElemsY(20) = PosY + 6: TableElemsX(20) = PosX + 8: TableElemsChar(20) = 31 '
   FOR i = 1 TO 20
      IF Y = TableElemsY(i) AND X = TableElemsX(i) THEN 'kursor na znaku
         COLOR 0, 3: LOCATE TableElemsY(i), TableElemsX(i): PRINT CHR$(TableElemsChar(i)); 'znak w negatywie
         IF _MOUSEBUTTON(1) THEN
            Char$ = CHR$(TableElemsChar(i)) 'klikniecie na znaku i zaladowanie go do zmiennej
            TempY = TableElemsY(i)
            TempX = TableElemsX(i)
         END IF
      ELSE
         COLOR 7, 1: LOCATE TableElemsY(i), TableElemsX(i): PRINT CHR$(TableElemsChar(i)); 'znak zwykly
      END IF
   NEXT i
   COLOR 7, 1
   LOCATE PosY + 8, PosX: PRINT "  kolor    ";
   LOCATE PosY + 9, PosX: PRINT " elementu  ";
   COLOR 15: LOCATE PosY + 10, PosX: PRINT " "; CHR$(219); CHR$(219); CHR$(219); CHR$(219); "      ";
   COLOR 14: LOCATE PosY + 10, PosX + 6: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
   IF CurY = PosY + 10 AND CurX > PosX AND CurX < PosX + 5 AND _MOUSEBUTTON(1) THEN
      CharColor = 15 'bialy - tor niezelektryfikowany
      TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
   END IF
   IF CurY = PosY + 10 AND CurX > PosX + 5 AND CurX < PosX + 10 AND _MOUSEBUTTON(1) THEN
      CharColor = 14 'zolty - tor zelektryfikowany
      TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
   END IF
   IF CurY = PosY + 10 AND CurX > PosX AND CurX < PosX + 5 THEN COLOR 7: LOCATE PosY + 10, PosX + 1: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219); 'podswietlenie wskazanego
   IF CurY = PosY + 10 AND CurX > PosX + 5 AND CurX < PosX + 10 THEN COLOR 6: LOCATE PosY + 10, PosX + 6: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
   IF CharColor = 15 THEN COLOR 0, 7: LOCATE PosY + 10, PosX + 1: PRINT "[": LOCATE PosY + 10, PosX + 4: PRINT "]"; 'zaznaczenie aktywnego
   IF CharColor = 14 THEN COLOR 0, 6: LOCATE PosY + 10, PosX + 6: PRINT "[": LOCATE PosY + 10, PosX + 9: PRINT "]";
END SUB
'------------------------------------------------------------------------------'
'                             PROCEDURY UNIWERSALNE                            '
'------------------------------------------------------------------------------'
SUB CurCoord (CurX, CurY)
   CurY = _MOUSEY: CurX = _MOUSEX
   COLOR 4, 1: LOCATE 30, 56: PRINT "wiersz="; CurY; 'OPCJA DEBUG
   LOCATE 30, 67: PRINT ", kolumna="; CurX; 'OPCJA DEBUG
END SUB

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

SUB spluczka 'czysci bufor myszy
   z = 0
   DO
      z = z + 1
   LOOP WHILE _MOUSEINPUT
END SUB

