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
SUB TitleMenu
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
'====================================================================================================='
'                           PROCEDURY - EDYTOR MAP - TRYB PELNY - PRZYBORNIK                          '
' tworzy liste znakow do umieszczenia na schemacie ukladu torowego oraz dla okna dialogowego rozjazdu '
'====================================================================================================='
SUB MapElems
   PosY = 2: PosX = 1: BtnPosY = PosY + 1: BtnPosX = PosX '                                                                                          'pozycja przybornika do edycji torowiska
   Prt PosY, PosX, 0, 3, "elementy do rysowania schematu ukladu torowego", 0 '                                                                       'tytul przybornika
   ElemStr$ = "-|/\" + CHR$(192) + CHR$(191) + CHR$(218) + CHR$(217) + "+X[]" + CHR$(16) + CHR$(17) + CHR$(30) + CHR$(31) + "><^v" + CHR$(127) + "*" 'ciag znakow na przyciski przybornika
   BtnStr$ = " " + MID$(ElemStr$, 1, 1) + " " '                                                                                                      'wybor znaku z ciagu
   Button BtnPosY, BtnPosX, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tor", BtnOff '                                                       'przycisk
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1) '                                                                                         'zaladuj znak zmiennej dla umieszczania go na schemacie
   BtnStr$ = " " + MID$(ElemStr$, 2, 1) + " "
   Button BtnPosY, BtnPosX + 3, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 3, 1) + " "
   Button BtnPosY, BtnPosX + 6, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 4, 1) + " "
   Button BtnPosY, BtnPosX + 9, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 5, 1) + " "
   Button BtnPosY, BtnPosX + 12, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "rozjazd", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 6, 1) + " "
   Button BtnPosY, BtnPosX + 15, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "rozjazd", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 7, 1) + " "
   Button BtnPosY, BtnPosX + 18, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "rozjazd", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 8, 1) + " "
   Button BtnPosY, BtnPosX + 21, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "rozjazd", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   IF SwitchDialogOpen = 1 THEN BtnOff = 1 ELSE BtnOff = 0 '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . wlacza uzaleznienie stanu przycisku od faktu otwarcia okna rozjazdu
   BtnStr$ = " " + MID$(ElemStr$, 9, 1) + " "
   Button BtnPosY, BtnPosX + 24, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "skrzyzowanie torow", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 10, 1) + " "
   Button BtnPosY, BtnPosX + 27, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "skrzyzowanie torow", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 11, 1) + " "
   Button BtnPosY, BtnPosX + 30, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "koziol oporowy", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 12, 1) + " "
   Button BtnPosY, BtnPosX + 33, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "koziol oporowy", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 13, 1) + " "
   Button BtnPosY, BtnPosX + 36, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "semafor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 14, 1) + " "
   Button BtnPosY, BtnPosX + 39, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "semafor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 15, 1) + " "
   Button BtnPosY, BtnPosX + 42, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "semafor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 16, 1) + " "
   Button BtnPosY, BtnPosX + 45, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "semafor", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 17, 1) + " "
   Button BtnPosY, BtnPosX + 48, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tarcza manewrowa", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 18, 1) + " "
   Button BtnPosY, BtnPosX + 51, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tarcza manewrowa", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 19, 1) + " "
   Button BtnPosY, BtnPosX + 54, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tarcza manewrowa", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 20, 1) + " "
   Button BtnPosY, BtnPosX + 57, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "tarcza manewrowa", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 21, 1) + " "
   Button BtnPosY, BtnPosX + 60, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "wykolejnica zamknieta", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   BtnStr$ = " " + MID$(ElemStr$, 22, 1) + " "
   Button BtnPosY, BtnPosX + 63, 3, 3, 8, 7, 0, 7, 7, 0, 4, 0, BtnStr$, "usuwanie znakow ze schematu", BtnOff
   IF BtnStat$ = "BtnAct" THEN Char$ = MID$(BtnStr$, 2, 1)
   IF BtnOff = 1 THEN BtnOff = 0 '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . wylacza uzaleznienie stanu przycisku od faktu otwarcia okna rozjazdu
END SUB
'====================================================================================================='
'                         PROCEDURY - EDYTOR MAP - TRYB PELNY - ELEKTRYFIKACJA                        '
' ustawia element wybrany z przybornika jako tor zelektryfikowany lub niezelektryfikowany             '
'====================================================================================================='
SUB TrackElectrChoose (CharColor)
   PosY = 3: PosX = 67 '                                                                                                    'pozycja modulu
   'COLOR 0, 3: LOCATE 2, 67: PRINT "elektryfikacja"; '                                                                      'nazwa modulu
   Prt 2, 67, 0, 3, "elektryfikacja", 0
   IF CharColor = 0 THEN BtnStr$ = "" '                                                                                     'sytuacja wyjsciowa
   IF CharColor = 14 THEN BtnStr$ = "" '                                                                                    'sprawdzanie stanu zmiennej w celu zaznaczenia przycisku
   IF CharColor = 15 THEN BtnStr$ = " X"
   Button PosY, PosX, 3, 3, 8, 7, 0, 7, 7, 0, 4, 7, BtnStr$, "tor bez sieci", 0
   IF BtnStat$ = "BtnHov" THEN
      StatusTxt$ = "tor bez sieci"
   END IF
   IF BtnStat$ = "BtnAct" THEN
      CharColor = 15 '                                                                                                      'ustawienie zmiennej
   END IF
   IF CharColor = 14 THEN BtnStr$ = " X"
   IF CharColor = 15 THEN BtnStr$ = "" '                                                                                    'sprawdzanie stanu zmiennej w celu zaznaczenia przycisku
   Button PosY, PosX + 3, 3, 3, 8, 7, 0, 6, 7, 0, 4, 6, BtnStr$, "tor z siecia", 0
   IF BtnStat$ = "BtnHov" THEN
      StatusTxt$ = "tor z siecia"
   END IF
   IF BtnStat$ = "BtnAct" THEN
      CharColor = 14 '                                                                                                      'ustawienie zmiennej
   END IF
END SUB
'====================================================================================================='
'         PROCEDURY - EDYTOR MAP - TRYB PELNY - PRZYPISANIE ZNAKU ASCII DO KAZDEGO POLOZENIA          '
' Obsluguje przybornik w celu wpisania odpowiedniego znaku dla kazdego polozenia rozjazdu.            '
'====================================================================================================='
SUB SwitchCharBuild (PosY, PosX)
   MapElems '                                                                                 przybornik zwraca zmienna SwitchChar$
   IF CurY = PosY + 2 AND CurX = PosX + 2 AND _MOUSEBUTTON(1) AND Char$ <> "" THEN '          klikniecie na rozjezdzie na schemacie w okienku
      Unclick '                                                                               czysci bufor myszy
      SELECT CASE SwitchDirNum '                                                              zaleznie od wybranego numeru polozenia
         CASE 1: SwitchChar1 = ASC(Char$) '                                                   wstawia kod znaku do zmiennej potrzebnej do zapisu tabeli
         CASE 2: SwitchChar2 = ASC(Char$)
         CASE 3: SwitchChar3 = ASC(Char$)
         CASE 4: SwitchChar4 = ASC(Char$)
      END SELECT
   END IF
   IF Char$ <> "" THEN '                                                                      jesli uzyto przybornika
      SELECT CASE SwitchDirNum '                                                              zaleznie od wybranego polozenia
         CASE 1: IF SwitchChar1 <> 0 THEN Prt PosY + 2, PosX + 2, 4, 7, CHR$(SwitchChar1), 0 'jesli umieszczono znak to wyswietla rozjazd ze zmiennej
         CASE 2: IF SwitchChar2 <> 0 THEN Prt PosY + 2, PosX + 2, 4, 7, CHR$(SwitchChar2), 0
         CASE 3: IF SwitchChar3 <> 0 THEN Prt PosY + 2, PosX + 2, 4, 7, CHR$(SwitchChar3), 0
         CASE 4: IF SwitchChar4 <> 0 THEN Prt PosY + 2, PosX + 2, 4, 7, CHR$(SwitchChar4), 0
      END SELECT
   END IF
END SUB
'====================================================================================================='
'                  PROCEDURY - EDYTOR MAP - TRYB PELNY - POLE TEKSTOWE NUMERU ROZJAZDU                '
' Pole tekstowe do podawania numeru rozjazdu w oknie dialogowym.                                      '
'====================================================================================================='
SUB SwitchNrField (PosY, PosX, SwitchNr$)
   FieldPosY = PosY + 1: FieldPosX = PosX + 18 '                                                               polozenie pola tekstowego wzgledem poczatku ramki okna rozjazdu
   Prt PosY + 1, PosX + 4, 0, 3, " Nr rozjazdu: ", 0 '                                                         prompt
   IF CurY = FieldPosY AND CurX >= FieldPosX AND CurX <= FieldPosX + 3 THEN '. . . . . . . . . . . . . . . . . jesli kursor na polu tekstowym
      Prt FieldPosY, FieldPosX, 7, 0, "", 4 '                                                                  przygotuj pole dla numeru - negatyw
      IF SwitchNr$ <> "" THEN Prt FieldPosY, FieldPosX, 7, 0, SwitchNr$, 0 '                                   wyswietl numer na nieaktywnym polu - negatyw
      StatusTxt$ = "wpisz max. 4 cyfry" '                                                                      opis na pasek statusu
      StatusBar StatusTxt$ '                                                                                   wywolanie paska statusu
      IF _MOUSEBUTTON(1) THEN '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . jesli kliknieto na polu tekstowym
         Unclick '                                                                                             wyczysc bufor myszy
         Prt FieldPosY, FieldPosX, 0, 2, "", 4 '                                                               wyswietl puste aktywne pole tekstowe
         IF SwitchNr$ <> "" THEN Prt FieldPosY, FieldPosX, 0, 2, SwitchNr$, 0 '                                jesli nadano numer, to wyswietl go na aktywnym polu
         WHILE Key$ <> CHR$(13) '                                                                              opuszcza pole tekstowe po wcisnieciu [Enter]
            _LIMIT 500 '                                                                                       ograniczenie liczby iteracji petli na sekunde
            Key$ = INKEY$ '                                                                                    zarejestruj wpisany znak
            IF Key$ >= CHR$(48) AND Key$ <= CHR$(57) AND LEN(SwitchNr$) < 4 THEN SwitchNr$ = SwitchNr$ + Key$ 'jesli jest to cyfra to dopisz ja do numeru, max. 4 cyfry
            IF Key$ = CHR$(8) AND LEN(SwitchNr$) > 0 THEN '                                                    wcisnieto backspace
               SwitchNr$ = MID$(SwitchNr$, 1, LEN(SwitchNr$) - 1) '                                            usun ostatni znak z ciagu (ciag = ciag od 1. znaku do przedostatniego)
            END IF
            Prt PosY + 1, PosX + 18, 0, 2, "", 4 '                                                             przygotuj puste aktywne pole tekstowe
            IF SwitchNr$ <> "" THEN Prt FieldPosY, FieldPosX, 0, 2, SwitchNr$, 0 '                             wyswietl numer na aktywnym polu
            _DISPLAY
         WEND
         Unkey '                                                                                               czysci bufor klawiatury
      END IF
   ELSE '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . kursor poza polem tekstowym
      Prt FieldPosY, FieldPosX, 0, 7, "", 4 '                                                                  wyswietl puste nieaktywne pole tekstowe
      IF SwitchNr$ <> "" THEN Prt FieldPosY, FieldPosX, 0, 7, SwitchNr$, 0 '                                   wyswietl numer na nieaktywnym polu
   END IF
END SUB
'====================================================================================================='
'                     PROCEDURY - EDYTOR MAP - TRYB PELNY - WYBOR TYPU ROZJAZDU                       '
' Przycisk ze zmiennym opisem typu rozjazdu w oknie dialogowym.                                       '
'====================================================================================================='
SUB SwitchTypeChoose (PosY, PosX)
   Prt PosY + 2, PosX + 4, 0, 3, " Typ rozjazdu:", 0 '                                                      'prompt
   IF SwitchDirCount = 0 THEN '                                                                             'sytuacja poczatkowa
      SwitchDirCount = 2
      SwitchType$ = "zwyczajny"
   END IF
   BtnDesc$ = "wybierz typ rozjazdu"
   Button PosY + 2, PosX + 19, 1, 19, 8, 7, 0, 7, 7, 0, 4, 7, SwitchType$, BtnDesc$, 0 '        'przycisk wyboru typu
   IF BtnStat$ = "BtnAct" THEN '                                                                            'jesli kliknieto
      SELECT CASE SwitchDirCount '                                                                          '
         CASE 2: SwitchDirCount = 3: SwitchType$ = "krzyzowy pojedynczy": EXIT SELECT
         CASE 3: SwitchDirCount = 4: SwitchType$ = "krzyzowy podwojny": EXIT SELECT
         CASE 4
            SwitchDirCount = 2 '                                                                            'liczba polozen rozjazdu
            SwitchDirNum = 1 '                                                                              'zmiana typu rozjazdu na zwyczajny wymusza zmiane aktualnego numeru polozenia
            SwitchType$ = "zwyczajny"
            EXIT SELECT
      END SELECT
   END IF
END SUB
'====================================================================================================='
'              PROCEDURY - EDYTOR MAP - TRYB PELNY - PRZYCISK WYBORU POLOZENIA DO OPISU               '
' Przycisk 1ö4 w oknie dialogowym rozjazdu.                                                           '
'====================================================================================================='
SUB SwitchDirNrChoose (PosY, PosX, SwitchDirCount)
   Prt PosY + 3, PosX + 4, 0, 3, " Polozenie nr", 0 '                                              'prompt
   IF SwitchDirNum = 0 THEN '                                                                      'sytuacja poczatkowa
      SwitchDirNum = 1
   END IF
   BtnDesc$ = "wybierz numer polozenia do opisania"
   Button PosY + 3, PosX + 18, 1, 3, 7, 3, 0, 7, 7, 0, 4, 7, STR$(SwitchDirNum), BtnDesc$, 0 'przycisk z numerem polozenia 1ö4
   IF BtnStat$ = "BtnAct" THEN '                                                                   'jesli kliknieto
      SELECT CASE SwitchDirNum '                                                                   'sprawdza aktualnie wybrany numer polozenia
         CASE 1
            SwitchDirNum = 2
            EXIT SELECT
         CASE 2
            IF SwitchDirCount < 3 THEN
               SwitchDirNum = 1
               EXIT SELECT
            ELSE
               SwitchDirNum = 3
               EXIT SELECT
            END IF
         CASE 3
            IF SwitchDirCount < 4 THEN
               SwitchDirNum = 1
               EXIT SELECT
            ELSE
               SwitchDirNum = 4
               EXIT SELECT
            END IF
         CASE 4
            SwitchDirNum = 1
            EXIT SELECT '                               'petla - z ostatniej pozycji wraca do pierwszej
      END SELECT
   END IF
END SUB
'====================================================================================================='
'       PROCEDURY - EDYTOR MAP - TRYB PELNY - POLE TEKSTOWE DO OPISU POLOZENIA ROZJAZDU abcd-+        '
' Wyswietlane w oknie dialogowym rozjazdu.                                                            '
'====================================================================================================='
SUB SwitchDirDesc (PosY, PosX)
   FieldPosY = PosY + 3: FieldPosX = PosX + 22 '                                                                             wspolrzedne pola tekstowego
   IF SwitchDirL$ = "" THEN '                                                                                             jesli zmienna robocza pusta
      SELECT CASE SwitchDirNum '                                                                                          w zaleznosci od wybranego numeru polozenia rozjazdu
         CASE 1: SwitchDirL$ = SwitchDirA$ '                                                                              laduje zmienna z tabeli do zmiennej roboczej
         CASE 2: SwitchDirL$ = SwitchDirB$
         CASE 3: SwitchDirL$ = SwitchDirC$
         CASE 4: SwitchDirL$ = SwitchDirD$
      END SELECT
   END IF
   IF CurY = FieldPosY AND CurX >= FieldPosX AND CurX <= FieldPosX + 5 THEN '                                                jesli wskazano pole tekstowe
      Prt FieldPosY, FieldPosX, 7, 0, "", 6 '                                                                                przygotowuje pole dla oznaczenia - negatyw
      Prt FieldPosY, FieldPosX, 7, 0, SwitchDirL$, 0 '                                                                    wyswietla oznaczenie na nieaktywnym polu - negatyw
      StatusBar "wpisz max. 6 znakow sposrod nastepujacych: abcd-+, np. +, a-b-, ab-cd+" '                                   opis na pasek statusu
      IF _MOUSEBUTTON(1) THEN '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . jesli kliknieto na polu tekstowym
         Unclick '                                                                                                           czysci bufor myszy
         Prt FieldPosY, FieldPosX, 7, 2, "", 6 '                                                                             wyswietla puste aktywne pole tekstowe
         IF SwitchDirL$ <> "" THEN Prt FieldPosY, FieldPosX, 0, 2, SwitchDirL$, 0 '                                          wyswietla oznaczenie polozenia na aktywnym polu
         WHILE Key$ <> CHR$(13) '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . opuszcza pole tekstowe po wcisnieciu [Enter]
            _LIMIT 500
            Key$ = INKEY$ '                                                                                                  zarejestruj wpisany znak
            IF (Key$ >= CHR$(97) AND Key$ <= CHR$(100) OR Key$ = CHR$(43) OR Key$ = CHR$(45)) AND LEN(SwitchDirL$) < 6 THEN 'jesli uzyto prawidlowych oznaczen, max. 6 znakow
               SwitchDirL$ = SwitchDirL$ + Key$ '                                                                            dopisuje je do ciagu
            END IF
            IF Key$ = CHR$(8) AND LEN(SwitchDirL$) > 0 THEN '                                                                wcisnieto backspace
               SwitchDirL$ = MID$(SwitchDirL$, 1, LEN(SwitchDirL$) - 1) '                                                    usun ostatni znak z ciagu (ciag = ciag od 1. znaku do przedostatniego)
            END IF
            Prt FieldPosY, FieldPosX, 7, 2, "", 6 '                                                                          wyswietla puste aktywne pole tekstowe
            IF SwitchDirL$ <> "" THEN Prt FieldPosY, FieldPosX, 0, 2, SwitchDirL$, 0 '                                       wyswietla numer na aktywnym polu
            _DISPLAY
         WEND
         SELECT CASE SwitchDirNum '                                                                                          w zaleznosci od wybranego numeru polozenia 1ö4
            CASE 1: SwitchDirA$ = SwitchDirL$ '                                                                              przenosi ciag do odpowiedniej zmiennej potrzebnej do wpisania do tabeli
            CASE 2: SwitchDirB$ = SwitchDirL$
            CASE 3: SwitchDirC$ = SwitchDirL$
            CASE 4: SwitchDirD$ = SwitchDirL$
         END SELECT
      END IF
   ELSE '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . nie kliknieto na polu tekstowym
      Prt FieldPosY, FieldPosX, 0, 7, "", 6 '                                                                                wyswietla puste nieaktywne pole tekstowe
      Prt FieldPosY, FieldPosX, 0, 7, SwitchDirL$, 0 '                                                                       wyswietla oznaczenie na nieaktywnym polu
   END IF
END SUB
'====================================================================================================='
'                              PROCEDURY UNIWERSALNE - KOORDYNATY KURSORA                             '
'====================================================================================================='
SUB CurCoord
   CurY = _MOUSEY: CurX = _MOUSEX
   PrtTxt$ = "wiersz=" + STR$(CurY): Prt 40, 56, 4, 0, PrtTxt$, 0
   PrtTxt$ = ", kolumna=" + STR$(CurX): Prt 40, 67, 4, 0, PrtTxt$, 0
END SUB
'====================================================================================================='
'                                    PROCEDURY UNIWERSALNE - UNCLICK                                  '
'====================================================================================================='
SUB Unclick '
   DO '                           'uzyc po kazdym _MOUSEBUTTON(1)
      z = _MOUSEINPUT '           'wstrzymuje program do momentu zakonczenia klikniecia
   LOOP UNTIL NOT _MOUSEBUTTON(1) 'zmienna "z" musi tu byc i sluzy tylko do poprawnego dzialania
END SUB '
'WHILE _MOUSEINPUT: WEND czysci takze bufor ruchu, do wyprobowania
'====================================================================================================='
'                                     PROCEDURY UNIWERSALNE - UNKEY                                   '
'====================================================================================================='
SUB Unkey
   'DO: Key$ = INKEY$: LOOP UNTIL Key$ = "" 'dosc szybkie
   'alternatywnie DO UNTIL INKEY$ = "": LOOP 'do sprawdzenia
   DO: LOOP UNTIL INKEY$ = "" 'do sprawdzenia
   'WHILE INKEY$ <> "": WEND 'dosc szybkie
   'alternatywnie:
   'DO
   '   A$ = INKEY$ 'Try to get a key
   'LOOP UNTIL LEN(A$) = 0 'Continue until no more
END SUB
'====================================================================================================='
'                                   PROCEDURY UNIWERSALNE - PRT                                       '
'====================================================================================================='
SUB Prt (PrtY, PrtX, PrtClr, PrtBg, PrtTxt$, PrtSpc)
   LOCATE PrtY, PrtX: COLOR PrtClr, PrtBg: PRINT PrtTxt$;
   IF PrtSpc <> 0 THEN PRINT SPC(PrtSpc);
END SUB
'====================================================================================================='
'                               PROCEDURY UNIWERSALNE - RYSOWANIE RAMEK                               '
' procedura rysujaca ramke dla elementow interfejsu na podstawie danych: wspolrzedne lewego, gornego  '
' rogu, liczby wierszy tekstu, dlugosci linii tekstu, kolorow krawedzi i tla ramki oraz ich ksztaltu  '
'====================================================================================================='
SUB FrameDraw (PosY, PosX, FrameLineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$)
   COLOR FrameCharColor, FrameBackColor
   'ksztalt naroznikow ustalany automatycznie, aby pasowal do ksztaltu bokow
   LOCATE PosY, PosX '                                                      'lewy gorny naroznik
   IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN Prt PosY, PosX, FrameCharColor, FrameBackColor, CHR$(218), 0
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN Prt PosY, PosX, FrameCharColor, FrameBackColor, CHR$(213), 0
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN Prt PosY, PosX, FrameCharColor, FrameBackColor, CHR$(201), 0
   LOCATE PosY, PosX + TxtLength + 1 '                                      'prawy gorny naroznik
   IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN Prt PosY, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, CHR$(191), 0
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN Prt PosY, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, CHR$(184), 0
   IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN Prt PosY, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, CHR$(187), 0
   LOCATE PosY + FrameLineCount + 1, PosX '                                      'lewy dolny naroznik
   IF FrameSide$ = CHR$(179) THEN Prt PosY + FrameLineCount + 1, PosX, FrameCharColor, FrameBackColor, CHR$(192), 0
   IF FrameSide$ = CHR$(186) THEN Prt PosY + FrameLineCount + 1, PosX, FrameCharColor, FrameBackColor, CHR$(200), 0
   LOCATE PosY + FrameLineCount + 1, PosX + TxtLength + 1 '                      'prawy dolny naroznik
   IF FrameSide$ = CHR$(179) THEN Prt PosY + FrameLineCount + 1, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, CHR$(217), 0
   IF FrameSide$ = CHR$(186) THEN Prt PosY + FrameLineCount + 1, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, CHR$(188), 0
   FOR i = 1 TO TxtLength '                                                 'rysuj poziome scianki ramki
      Prt PosY, PosX + i, FrameCharColor, FrameBackColor, FrameTop$, 0
      Prt PosY + FrameLineCount + 1, PosX + i, FrameCharColor, FrameBackColor, FrameBottom$, 0
   NEXT i
   FOR i = 1 TO FrameLineCount '                                                 'rysuj pionowe scianki ramki
      Prt PosY + i, PosX, FrameCharColor, FrameBackColor, FrameSide$, 0
      Prt PosY + i, PosX + TxtLength + 1, FrameCharColor, FrameBackColor, FrameSide$, 0
   NEXT i
END SUB
'====================================================================================================='
'                                   PROCEDURY UNIWERSALNE - BUTTON                                    '
' rysuje interaktywny przycisk przy uzyciu zadanych parametrow i zwraca do programu jego stan         '
'====================================================================================================='
SUB Button (BtnPosY, BtnPosX, BtnHeight, BtnLength, BtnOffStrClr, BtnOffBack, BtnInactStrClr, BtnInactBack, BtnHovStrClr, BtnHovBack, BtnActStrClr, BtnActBack, BtnStr$, BtnDesc$, BtnOff)
   IF CurY >= BtnPosY AND CurY <= BtnPosY + BtnHeight - 1 AND CurX >= BtnPosX AND CurX <= BtnPosX + BtnLength - 1 THEN 'kursor na przycisku
      IF _MOUSEBUTTON(1) THEN '                                                                                        'klikniecie
         Unclick
         SELECT CASE BtnOff
            CASE 0 '                                                                                                   'przycisk dostepny
               FOR i = 1 TO BtnHeight '                                                                                'dla kazdego wiersza
                  Prt BtnPosY + i - 1, BtnPosX, 0, BtnActBack, "", BtnLength '                                         'narysuj tlo
               NEXT i
               SELECT CASE BtnHeight
                  CASE 1: Prt BtnPosY, BtnPosX, BtnActStrClr, BtnActBack, BtnStr$, 0 '                                 'jesli przycisk jest wysoki na 1 wiersz, umiesc napis
                  CASE 3: Prt BtnPosY + 1, BtnPosX, BtnActStrClr, BtnActBack, BtnStr$, 0 '                             'jesli przycisk jest wysoki na 3 wiersze, umiesc napis
               END SELECT
               BtnStat$ = "BtnAct" '                                                                                   'poinformuj program, ze kliknieto przycisk
               StatusBar BtnDesc$
            CASE 1
               FOR i = 1 TO BtnHeight '                                                                                'dla kazdego wiersza
                  Prt BtnPosY + i - 1, BtnPosX, 0, BtnOffBack, "", BtnLength '                                         'narysuj tlo
               NEXT i
               SELECT CASE BtnHeight '                                                                                 'sprawdza zadana wysokosc przycisku
                  CASE 1: Prt BtnPosY, BtnPosX, BtnOffStrClr, 0, BtnStr$, 0 '                                          'jesli przycisk jest wysoki na 1 wiersz, umiesc napis
                  CASE 3: Prt BtnPosY + 1, BtnPosX, BtnOffStrClr, 0, BtnStr$, 0 '                                      'jesli przycisk jest wysoki na 3 wiersze
               END SELECT
               BtnStat$ = "BtnOff" '                                                                                   'poinformuj program, ze przycisk niedostepny
         END SELECT
      ELSE '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . nie kliknieto
         SELECT CASE BtnOff '                                                                                          'sprawdz, czy przycisk jest ustawiony jako niedostepny
            CASE 0 '                                                                                                   'przycisk dostepny
               FOR i = 1 TO BtnHeight '                                                                                'dla kazdego wiersza
                  Prt BtnPosY + i - 1, BtnPosX, 0, BtnHovBack, "", BtnLength '                                         'narysuj tlo
               NEXT i
               SELECT CASE BtnHeight '                                                                                 'sprawdz zadana wysokosc przycisku
                  CASE 1: Prt BtnPosY, BtnPosX, BtnHovStrClr, 0, BtnStr$, 0 '                                          'jesli przycisk jest wysoki na 1 wiersz, umiesc napis
                  CASE 3: Prt BtnPosY + 1, BtnPosX, BtnHovStrClr, 0, BtnStr$, 0 '                                      'jesli przycisk jest wysoki na 3 wiersze, umiesc napis
               END SELECT
               BtnStat$ = "BtnHov" '                                                                                   'poinformuj program, ze kursor na przycisku
               StatusBar BtnDesc$
            CASE 1
               FOR i = 1 TO BtnHeight '                                                                                'dla kazdego wiersza
                  Prt BtnPosY + i - 1, BtnPosX, BtnOffStrClr, BtnOffBack, "", BtnLength '                              'narysuj tlo
               NEXT i
               SELECT CASE BtnHeight
                  CASE 1: Prt BtnPosY, BtnPosX, BtnOffStrClr, 7, BtnStr$, 0 '                                          'jesli przycisk jest wysoki na 1 wiersz, umiesc napis
                  CASE 3: Prt BtnPosY + 1, BtnPosX, BtnOffStrClr, 7, BtnStr$, 0 '                                      'jesli przycisk jest wysoki na 3 wiersze, umiesc napis
               END SELECT
               BtnStat$ = "BtnOff" '                                                                                   'poinformuj program, ze przycisk niedostepny
               StatusBar "przycisk niedostepny"
         END SELECT
      END IF
   ELSE ' . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . kursor poza przyciskiem
      SELECT CASE BtnOff '                                                                                             'sprawdza, czy przycisk jest ustawiony jako niedostepny
         CASE 0 '                                                                                                      'przycisk dostepny
            FOR i = 1 TO BtnHeight '                                                                                   'dla kazdego wiersza
               Prt BtnPosY + i - 1, BtnPosX, 7, BtnInactBack, "", BtnLength '                                          'narysuj tlo
            NEXT i
            SELECT CASE BtnHeight '                                                                                    'sprawdza zadana wysokosc przycisku
               CASE 1: Prt BtnPosY, BtnPosX, BtnInactStrClr, 7, BtnStr$, 0 '                                           'jesli przycisk jest wysoki na 1 wiersz, umiesc napis
               CASE 3: Prt BtnPosY + 1, BtnPosX, BtnInactStrClr, 7, BtnStr$, 0 '                                       'jesli przycisk jest wysoki na 3 wiersze, umiesc napis
            END SELECT
            BtnStat$ = "BtnInact" '                                                                                    'informuje program, ze kursor poza przyciskiem
         CASE 1 '                                                                                                      'przycisk niedostepny
            FOR i = 1 TO BtnHeight '                                                                                   'dla kazdego wiersza
               Prt BtnPosY + i - 1, BtnPosX, 7, BtnOffBack, "", BtnLength '                                            'rysuje tlo
            NEXT i
            SELECT CASE BtnHeight '                                                                                    'sprawdza zadana wysokosc przycisku
               CASE 1: Prt BtnPosY, BtnPosX, BtnOffStrClr, 7, BtnStr$, 0 '                                             'jesli przycisk jest wysoki na 1 wiersz, umieszcza napis
               CASE 3: Prt BtnPosY + 1, BtnPosX, BtnOffStrClr, 7, BtnStr$, 0 '                                         'jesli przycisk jest wysoki na 3 wiersze, umieszcza napis
            END SELECT
            BtnStat$ = "BtnOff" '                                                                                      'informuje program, ze przycisk niedostepny
      END SELECT
   END IF
END SUB
'====================================================================================================='
'                                PROCEDURY UNIWERSALNE - PASEK STATUSU                                '
' Wyswietla informacje na temat wskazanych kursorem obiektow, uzywa jednego koloru tekstu i tla, ma   '
' jeden wiersz. Umieszczony na samym dole okna gry.                                                   '
'====================================================================================================='
SUB StatusBar (StatusTxt$)
   FOR i = 1 TO ColumnCount
      Prt LineCount - 1, i, 0, 3, CHR$(196), 0 '                         pozioma kreska ponad linia tekstu
   NEXT i
   IF StatusTxt$ = "StatusBarReset" THEN '                               jesli przyjdzie polecenie reset
      FOR i = 1 TO ColumnCount
         Prt LineCount, 1 * i, 0, 3, " ", 0 '                            czysci pasek statusu
      NEXT i
   ELSE '                                                                jesli przyjdzie inny tekst
      Prt LineCount, 1, 0, 3, StatusTxt$, ColumnCount - LEN(StatusTxt$) 'wypisuje zadany tekst
   END IF
END SUB
'====================================================================================================='
'                              PROCEDURY UNIWERSALNE - PASEK POWIADOMIEN                              '
' Wyswietla powiadomienia generowane przez gre, uzywa roznych kolorow i dopisuje nowa wiadomosc       '
' pod/nad starsza. Umieszczony ponad paskiem statusu.                                                 '
'====================================================================================================='
SUB MessBar (Message$, MessageClr, MessageBack)
   Prt LineCount - 2, 0, MessageClr, MessageBack, Message$, 0
END SUB
'====================================================================================================='
'                              PROCEDURY UNIWERSALNE - RYSOWANIE ETYKIET                              '
' Rysuje etykiete z opisem wskazanego elementu. Ramka zawsze z pojedynczych kresek. Wymiary dobierane '
' automatycznie na podstawie dlugosci tekstu.                                                         '
'====================================================================================================='
SUB Label (LabelPosY, LabelPosX, LabelChrClr, LabelBackClr, LabelText$)
   Prt LabelPosY, LabelPosX, LabelChrClr, LabelBackClr, CHR$(218), 0 '                      lewy gorny naroznik
   FOR i = 1 TO LEN(LabelText$) '                                                           gorna krawedz
      Prt LabelPosY, LabelPosX + 1 * i, LabelChrClr, LabelBackClr, CHR$(196), 0
   NEXT i
   Prt LabelPosY, LabelPosX + LEN(LabelText$), LabelChrClr, LabelBackClr, CHR$(191), 0 '    prawy gorny naroznik
   Prt LabelPosY + 1, LabelPosX, LabelChrClr, LabelBackClr, CHR$(179), 0 '                  lewy bok
   Prt LabelPosY + 1, LabelPosX + 1, LabelChrClr, LabelBackClr, LabelText$, 0 '             wypisuje tresc etykiety
   Prt LabelPosY + 1, LabelPosX + LEN(LabelText$), LabelChrClr, LabelBackClr, CHR$(179), 0 'prawy bok
   Prt LabelPosY + 2, LabelPosX, LabelChrClr, LabelBackClr, CHR$(192), 0 '                  lewy dolny naroznik
   FOR i = 1 TO LEN(LabelText$) '                                                           dolna krawedz
      Prt LabelPosY + 2, LabelPosX + 1 * i, LabelChrClr, LabelBackClr, CHR$(196), 0
   NEXT i
   Prt LabelPosY + 2, LabelPosX + LEN(LabelText$), LabelChrClr, LabelBackClr, CHR$(217), 0 'prawy dolny naroznik
END SUB
'====================================================================================================='
'                                  PROCEDURY UNIWERSALNE - DZIENNIK                                   '
' zapisuje nazwe i stan kazdej zmiennej wraz z data i godzina                                         '
'====================================================================================================='
