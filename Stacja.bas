_CONTROLCHR OFF 'umozliwia wypisywanie na ekranie znakow kontrolnych
'$DYNAMIC 'umozliwia zmiane dlugosci tabeli poleceniem REDIM
OPTION BASE 1 'pierwszy rekord tabeli domyslnie bedzie mial numer 1 zamiast 0
'''''''''''''''''''''''''''''' deklaracje zmiennych ''''''''''''''''''''''''''''
'deklaruje zmienne, ktore musialyby byc przekazane do procedury razem z tabela
DIM SHARED MapTableRecCount AS INTEGER
DIM SHARED RecNr AS INTEGER
DIM SHARED FramePosX AS _UNSIGNED _BYTE
DIM SHARED FramePosY AS _UNSIGNED _BYTE
''''''''''''''''''''''''''''''' deklaracje stalych '''''''''''''''''''''''''''''
_TITLE "Stacja"
GameDir$ = ".\"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
LineCount = 90: ColumnCount = 200 'wymiary okna gry
'=============================================================================='
'                             DEKLARACJE TYPOW                                 '
'=============================================================================='
TYPE TypeMapTable '                  'typ dla tabeli mapy
   CharY AS SINGLE '                 'wspolrzedne znaku
   CharX AS SINGLE
   CharColor AS _BYTE
   CharCode AS _UNSIGNED _BYTE
END TYPE
TYPE TypeTableElems '                'typ dla tabeli przybornika
   TableElemsY AS SINGLE '           'polozenie znaku w przyborniku
   TableElemsX AS SINGLE
   TableElemsChar AS _UNSIGNED _BYTE 'kod ASCII znaku
   TableElemsDesc AS STRING '        'opis wyswietlany przy najechaniu kursorem
END TYPE
'=============================================================================='
'                              DEKLARACJE TABEL                                '
'=============================================================================='
DIM SHARED MapTable(1) AS TypeMapTable '    'tabela do przechowywania w pamieci mapy
DIM SHARED TableElems(22) AS TypeTableElems 'tabela przybornika
'------------------------------------------------------------------------------'
'                                 EKRAN TYTULOWY                               '
'------------------------------------------------------------------------------'
WIDTH ColumnCount, LineCount 'wymiary okna gry
DO
   tytul_logo 'logo gry
   COLOR 4, 1: LOCATE 30, 1: PRINT "v0.1 (c) 2023ö2025 Emil Sawicki";
   Key$ = UCASE$(INKEY$)
   DO: _LIMIT 500
      CurCoord CurX, CurY
      TitleMenu CurX, CurY 'rysowanie menu z podswietlaniem wskazanej opcji
      'zdarzenia myszy
      IF CurY = 17 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN Unclick: tytul_menu_nowagra 'submenu "Nowa gra"
      'IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_wczytaj
      IF CurY = 21 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN Unclick: tytul_menu_edytor
      IF CurY = 23 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN SYSTEM
   LOOP WHILE _MOUSEINPUT
   'zdarzenia klawiatury
   IF Key$ = "N" THEN tytul_menu_nowagra 'TitleMenuNewGame
   'IF klawisz$ = "W" THEN tytul_menu_wczytaj
   IF Key$ = "E" THEN tytul_menu_edytor
   IF Key$ = "K" OR Key$ = CHR$(27) THEN SYSTEM
LOOP

SUB tytul_menu_nowagra 'ekran tytulowy - submenu "Nowa gra"
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         COLOR 7, 8: LOCATE 17, 31: PRINT "     Nowa gra     " 'tytul tego menu jako nieaktywny "przycisk"
         CurCoord CurX, CurY
         'opcje menu i podswietlanie wskazanej
         IF CurY = 19 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis zwykly
            COLOR 4: LOCATE 19, 40: PRINT "p" 'czerwona litera
         END IF
         IF CurY = 21 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis zwykly
            COLOR 4: LOCATE 21, 37: PRINT "u" 'czerwona litera
         END IF
         IF CurY = 23 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 23, 31: PRINT "      Wstecz      " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 23, 31: PRINT "      Wstecz      " 'napis zwykly
            COLOR 4: LOCATE 23, 37: PRINT "W" 'czerwona litera
         END IF
         'mysz
         IF CurY = 19 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN
            'gra_tryb_pelny 'TYMCZASOWO WYLACZONE
            EXIT SUB 'po zakonczeniu gry powrot do glownego menu
         END IF
         'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
         '    gra_tryb_uproszczony
         'EXIT SUB
         'END IF
         IF CurY = 23 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN 'wstecz
            Unclick
            EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'klawiatura
      IF Key$ = "P" THEN
         'gra_tryb_pelny 'TYMCZASOWO WYLACZONE
         EXIT SUB 'po zakonczeniu gry powrot do glownego menu
      END IF
      'IF klawisz$ = "U" THEN
      '    gra_tryb_uproszczony
      'EXIT SUB
      'END IF
      IF Key$ = "W" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB

SUB tytul_menu_edytor 'ekran tytulowy - submenu "Edytor"
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         COLOR 7, 8: LOCATE 17, 31: PRINT "      Edytor      " 'tytul tego menu jako nieaktywny "przycisk"
         CurCoord CurX, CurY
         'opcje menu i podswietlanie wskazanej
         IF CurY = 19 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullMap TempVar: EXIT SUB 'po zakonczeniu edytora powrot do glownego menu ekranu tytulowego
         ELSE
            COLOR 0, 7: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis zwykly
            COLOR 4: LOCATE 19, 40: PRINT "p" 'czerwona litera
         END IF
         IF CurY = 21 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis zwykly
            COLOR 4: LOCATE 21, 37: PRINT "u" 'czerwona litera
         END IF
         IF CurY = 23 AND CurX > 30 AND CurX < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 23, 31: PRINT "      Wstecz      " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 23, 31: PRINT "      Wstecz      " 'napis zwykly
            COLOR 4: LOCATE 23, 37: PRINT "W" 'czerwona litera
         END IF
         'zdarzenia myszy
         IF CurY = 23 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'wstecz
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "P" THEN Unclick: EditFullMap TempVar: EXIT SUB
      'IF klawisz$ = "U" THEN
      '    edytor_tryb_uproszczony
      'EXIT SUB
      'END IF
      IF Key$ = "W" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB
'------------------------------------------------------------------------------'
'                                GRA - TRYB PELNY                              '
'------------------------------------------------------------------------------'
SUB gra_tryb_pelny
   gra_tryb_pelny_sprawdzanie_plikow
   DO
      COLOR 0, 7: LOCATE 1, 1: PRINT "        Pociagi  Sklady  Rozklad  Przebiegi                                     "; 'pierwsza pozycja paska "Plik" juz przerobiona ponizej
      COLOR 4: LOCATE 1, 6: PRINT "k": LOCATE 1, 9: PRINT "P": LOCATE 1, 18: PRINT "S": LOCATE 1, 26: PRINT "R" 'czerwone litery
      gra_tryb_pelny_mapa
      'gra_pelny_pociag
      'gra_pelny_semafor
      'gra_pelny_komunikaty
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord CurX, CurY
         'zdarzenia myszy
         'gorny pasek menu
         IF Y = 1 AND X > 1 AND X < 7 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 1, 2: PRINT " Plik " 'napis zwykly
            COLOR 4: LOCATE 1, 6: PRINT "N" 'czerwona litera
         END IF
         IF X > 1 AND X < 6 AND Y = 1 AND _MOUSEBUTTON(1) THEN gra_menu_plik TempVar
         IF X > 6 AND X < 14 AND Y = 1 AND _MOUSEBUTTON(1) THEN gra_tryb_pelny_okno_pociagi
      LOOP WHILE _MOUSEINPUT
      'klawiatura
      IF Key$ = "K" THEN gra_menu_plik TempVar
      IF TempVar = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna TempVar, ktora wychodzi z TEJ petli
      IF Key$ = "P" THEN gra_tryb_pelny_okno_pociagi
   LOOP
END SUB

SUB gra_tryb_pelny_sprawdzanie_plikow
   CLS , 0
   CHDIR "D:\Gry\transportowe\Stacja\tryb pelny\Przykladowa Stacja" 'wejdz do folderu danej stacji
   IF _FILEEXISTS("mapa.txt") THEN
      COLOR 10, 0: LOCATE 1, 1: PRINT "Plik mapy istnieje."
   ELSE
      COLOR 12, 0: LOCATE 1, 1: PRINT "Plik mapy nie istnieje."
   END IF
   SLEEP 1
END SUB

SUB gra_menu_plik (TempVar)
   TempVar = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
   PosY = 2
   PosX = 1
   LineCount = 4
   TxtLength = 8
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
   'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord CurX, CurY
         'opcje menu i podswietlanie wskazanej
         IF CurY = 3 AND CurX > 1 AND CurX < 12 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 3, 2: PRINT " Nowa gra " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa gra " 'napis zwykly
            COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
         END IF
         IF CurY = 4 AND CurX > 1 AND CurX < 12 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 4, 2: PRINT " Zapisz   " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 4, 2: PRINT " Zapisz   " 'napis zwykly
            COLOR 4: LOCATE 4, 3: PRINT "Z" 'czerwona litera
         END IF
         IF CurY = 5 AND CurX > 1 AND CurX < 12 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 5, 2: PRINT " Wczytaj  " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 5, 2: PRINT " Wczytaj  " 'napis zwykly
            COLOR 4: LOCATE 5, 3: PRINT "W" 'czerwona litera
         END IF
         IF CurY = 6 AND CurX > 1 AND CurX < 12 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 6, 2: PRINT " Koniec   " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 6, 2: PRINT " Koniec   " 'napis zwykly
            COLOR 4: LOCATE 6, 3: PRINT "K" 'czerwona litera
         END IF
         'zdarzenia myszy
         IF (CurX > PosX + TxtLength + 3 OR CurY > PosY + LineCount + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
            CLS , 0
            EXIT SUB
         END IF
         IF CurY = 6 AND CurX > 1 AND CurX < 12 AND _MOUSEBUTTON(1) THEN 'koniec
            TempVar = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
            EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "K" THEN
         TempVar = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
         EXIT SUB
      END IF
      IF Key$ = CHR$(27) THEN
         CLS , 0
         EXIT SUB 'zamkniecie menu
      END IF
   LOOP
END SUB

SUB gra_tryb_pelny_okno_pociagi
   PosY = 3
   PosX = 7
   LineCount = 1
   TxtLength = 7
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(205): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 7, 0: LOCATE 1, 8: PRINT " Pociagi " 'odwroc kolory w nazwie otwartego okna
   'zawartosc okna
   COLOR 0, 7: LOCATE PosY + 1, PosX + 2: PRINT "Pociagi "
   'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie okna
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord CurX, CurY
         IF CurY = PosY AND CurX = PosX + TxtLength + 2 THEN 'kursor na przycisku
            COLOR 7, 0: LOCATE PosY, PosX + TxtLength + 2: PRINT "X" 'przycisk w negatywie
         ELSE
            COLOR 4, 7: LOCATE PosY, PosX + TxtLength + 2: PRINT "X" 'czerwona litera
         END IF
         'klikniecie przycisku zamkniecia
         IF CurY = PosY AND CurX = PosX + TxtLength + 2 AND _MOUSEBUTTON(1) THEN
            EXIT SUB
         END IF
         'klikniecie poza oknem
         IF (CurY < PosY OR CurY > PosY + LineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 3) AND _MOUSEBUTTON(1) THEN
            EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "X" OR Key$ = CHR$(27) THEN
         EXIT SUB
      END IF
   LOOP
END SUB

SUB gra_tryb_pelny_mapa
   MapCurX = 1: MapCurY = 10 'koordynaty lewego gornego rogu mapy
   'zmiana wymiarow okna
   'wczytanie mapy z pliku
   OPEN "mapa.txt" FOR INPUT AS #1
   COLOR 7, 0
   DO WHILE NOT EOF(1)
      '(przeniesc do taboru i elementow mapy) INPUT #1, nr_rek, klr_txt, klr_tlo, elem_map$, typ_elem$ 'nr_rekordu, kolor_tekstu, kolor_tla, element_mapy, typ_elementu (tor, semafor, rozjazd itd.)
      INPUT #1, RecNr, MapY, MapX, tresc_mapy$
      LOCATE MapY + MapCurY - 1, MapX + MapCurX - 1: PRINT tresc_mapy$ 'rysowanie torow
      '(przeniesc do taboru i elementow mapy) COLOR klr_txt, klr_tlo: LOCATE wiersz_mapy, 1: PRINT elem_map$
   LOOP
   CLOSE #1
END SUB
'------------------------------------------------------------------------------'
'                            GRA - TRYB UPROSZCZONY                            '
'------------------------------------------------------------------------------'
'nic
'------------------------------------------------------------------------------'
'                            EDYTOR MAP - TRYB PELNY                           '
'------------------------------------------------------------------------------'
'====================================================================================='
'                      EDYTOR MAP - TRYB PELNY - WARSTWA MAPY                         '
'====================================================================================='
'wybor edytora - nowa mapa lub istniejaca
SUB EditFullMap (TempVar) '1. warstwa - rysowanie schematu torow
   CLS , 1
   'edytor_tryb_pelny_sprawdzanie_plikow
   MapHeight = 25: MapWidth = 65 '            'domyslne wymiary nowej mapy
   MapPosX = 1: MapPosY = 6 '                 'poczatek ramki mapy
   MapY = MapPosY + 1: MapX = 1 = MapPosX + 1 'poczatek mapy
   CharColor = 15: BackColor = 0 '            'domyslne kolory: bialy i czarny
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CLS , 1
         FrameTop$ = CHR$(205): FrameBottom$ = CHR$(205): FrameSide$ = CHR$(186)
         FrameDraw MapPosX, MapPosY, MapHeight, MapWidth, 0, 3, FrameTop$, FrameBottom$, FrameSide$ 'ramka mapy
         CurCoord CurX, CurY
         MapCurX = CurX + MapPosX - 2: MapCurY = CurY - MapPosY 'obliczanie pozycji kursora na mapie
         MapCurXCapped = MapCurX: MapCurYCapped = MapCurY '     'wyswietlanie rzeczywistej pozycji kursora na mapie
         IF MapCurY < 1 THEN MapCurYCapped = 1 '                'ograniczenie w sytuacji wyjechania kursorem poza mape
         IF MapCurY > 25 THEN MapCurYCapped = 25
         IF MapCurX < 1 THEN MapCurXCapped = 1
         IF MapCurX > 65 THEN MapCurXCapped = 65
         COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT MapCurYCapped;
         LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT MapCurXCapped;
         'zdarzenia myszy
         COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Warstwy  Instrukcja  Slownik                                            "; 'PASEK MENU
         IF CurY = 1 AND CurX > 1 AND CurX < 8 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditMenuFile TempVar: CLS , 1
         ELSE
            COLOR 0, 7: LOCATE 1, 2: PRINT " Plik ": COLOR 4: LOCATE 1, 3: PRINT "P" '  'napis z czerwonym inicjalem
         END IF
         IF CurY = 1 AND CurX > 7 AND CurX < 17 THEN '                                  'kursor na napisie
            COLOR 7, 0: LOCATE 1, 8: PRINT " Warstwy " '                                'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullMenuLayer LayerNr: CLS , 1 '       'menu otwierane w edytorze w celu zmiany warstwy
         ELSE
            COLOR 0, 7: LOCATE 1, 8: PRINT " Warstwy ": COLOR 4: LOCATE 1, 9: PRINT "W" 'napis z czerwonym inicjalem
         END IF
         'edytor_pelny_menu_warstwa
         'okno mapy - etykieta koordynat kursora
         IF CurY = 2 AND CurX > 3 AND CurX < 27 THEN
            etykieta_mapa_koordynaty 'PRZEROBIC NA WSPOLNA PROCEDURE DLA WSZYSTKICH ETYKIET    'PopUp "koordynaty kursora"
            'ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, etykieta_wiersz_1$
            CLS , 1
         END IF
         EditFullMapTableDisplay MapTableRecCount, MapPosX, MapPosY, MapWidth, MapHeight, ShiftX, ShiftY 'rysuje ponownie mape
         PosX = 2: PosY = 2 '                                  'pozycja tablicy znakow do edycji torowiska
         '''''''''''''''''''' POCZATEK PROCEDURY PRZYBORNIKA
         COLOR 7, 1: LOCATE PosY, PosX: PRINT "elementy do rysowania schematu ukladu torowego";
         TableElems(1).TableElemsY = PosY + 2: TableElems(1).TableElemsX = PosX: TableElems(1).TableElemsChar = 45: TableElems(1).TableElemsDesc$ = "tor" '-
         TableElems(2).TableElemsY = PosY + 2: TableElems(2).TableElemsX = PosX + 3: TableElems(2).TableElemsChar = 124: TableElems(2).TableElemsDesc$ = "tor" '|
         TableElems(3).TableElemsY = PosY + 2: TableElems(3).TableElemsX = PosX + 6: TableElems(3).TableElemsChar = 47: TableElems(3).TableElemsDesc$ = "tor" '/
         TableElems(4).TableElemsY = PosY + 2: TableElems(4).TableElemsX = PosX + 9: TableElems(4).TableElemsChar = 92: TableElems(4).TableElemsDesc$ = "tor" '\
         TableElems(5).TableElemsY = PosY + 2: TableElems(5).TableElemsX = PosX + 12: TableElems(5).TableElemsChar = 43: TableElems(5).TableElemsDesc$ = "skrzyzowanie torow" '+
         TableElems(6).TableElemsY = PosY + 2: TableElems(6).TableElemsX = PosX + 15: TableElems(6).TableElemsChar = 88: TableElems(6).TableElemsDesc$ = "skrzyzowanie torow" 'X
         TableElems(7).TableElemsY = PosY + 2: TableElems(7).TableElemsX = PosX + 18: TableElems(7).TableElemsChar = 192: TableElems(7).TableElemsDesc$ = "rozjazd na bok" 'Ŕ
         TableElems(8).TableElemsY = PosY + 2: TableElems(8).TableElemsX = PosX + 21: TableElems(8).TableElemsChar = 191: TableElems(8).TableElemsDesc$ = "rozjazd na bok" 'ż
         TableElems(9).TableElemsY = PosY + 2: TableElems(9).TableElemsX = PosX + 24: TableElems(9).TableElemsChar = 218: TableElems(9).TableElemsDesc$ = "rozjazd na bok" 'Ú
         TableElems(10).TableElemsY = PosY + 2: TableElems(10).TableElemsX = PosX + 27: TableElems(10).TableElemsChar = 217: TableElems(10).TableElemsDesc$ = "rozjazd na bok" 'Ů
         TableElems(11).TableElemsY = PosY + 2: TableElems(11).TableElemsX = PosX + 30: TableElems(11).TableElemsChar = 93: TableElems(11).TableElemsDesc$ = "uporek" ']
         TableElems(12).TableElemsY = PosY + 2: TableElems(12).TableElemsX = PosX + 33: TableElems(12).TableElemsChar = 91: TableElems(12).TableElemsDesc$ = "uporek" '[
         TableElems(13).TableElemsY = PosY + 2: TableElems(13).TableElemsX = PosX + 36: TableElems(13).TableElemsChar = 16: TableElems(13).TableElemsDesc$ = "semafor" '
         TableElems(14).TableElemsY = PosY + 2: TableElems(14).TableElemsX = PosX + 39: TableElems(14).TableElemsChar = 17: TableElems(14).TableElemsDesc$ = "semafor" '
         TableElems(15).TableElemsY = PosY + 2: TableElems(15).TableElemsX = PosX + 42: TableElems(15).TableElemsChar = 30: TableElems(15).TableElemsDesc$ = "semafor" '
         TableElems(16).TableElemsY = PosY + 2: TableElems(16).TableElemsX = PosX + 45: TableElems(16).TableElemsChar = 31: TableElems(16).TableElemsDesc$ = "semafor" '
         TableElems(17).TableElemsY = PosY + 2: TableElems(17).TableElemsX = PosX + 48: TableElems(17).TableElemsChar = 62: TableElems(17).TableElemsDesc$ = "tarcza manewrowa" '>
         TableElems(18).TableElemsY = PosY + 2: TableElems(18).TableElemsX = PosX + 51: TableElems(18).TableElemsChar = 60: TableElems(18).TableElemsDesc$ = "tarcza manewrowa" '<
         TableElems(19).TableElemsY = PosY + 2: TableElems(19).TableElemsX = PosX + 54: TableElems(19).TableElemsChar = 94: TableElems(19).TableElemsDesc$ = "tarcza manewrowa" '^
         TableElems(20).TableElemsY = PosY + 2: TableElems(20).TableElemsX = PosX + 57: TableElems(20).TableElemsChar = 118: TableElems(20).TableElemsDesc$ = "tarcza manewrowa" 'v
         TableElems(21).TableElemsY = PosY + 2: TableElems(21).TableElemsX = PosX + 60: TableElems(21).TableElemsChar = 127: TableElems(21).TableElemsDesc$ = "wykolejnica zamknieta" '
         TableElems(22).TableElemsY = PosY + 2: TableElems(22).TableElemsX = PosX + 63: TableElems(22).TableElemsChar = 42: TableElems(22).TableElemsDesc$ = "kasowanie" '*
         FOR i = 1 TO 22 ' . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  'petla obslugi przybornika
            IF CurY > TableElems(i).TableElemsY - 2 AND CurY < TableElems(i).TableElemsY + 2 AND CurX > TableElems(i).TableElemsX - 2 AND CurX < TableElems(i).TableElemsX + 2 THEN 'kursor znajduje sie nad znakiem
               COLOR 0, 3: LOCATE TableElems(i).TableElemsY - 1, TableElems(i).TableElemsX - 1: PRINT "   " '                                                                       'powierzchnia przycisku
               LOCATE TableElems(i).TableElemsY, TableElems(i).TableElemsX - 1: PRINT " " + CHR$(TableElems(i).TableElemsChar) + " "; '                                             'wyswietlenie znaku w negatywie
               LOCATE TableElems(i).TableElemsY + 1, TableElems(i).TableElemsX - 1: PRINT "   " '                                                                                   'powierzchnia przycisku
               COLOR 11, 1: LOCATE TableElems(i).TableElemsY + 1, TableElems(i).TableElemsX + 3: PRINT TableElems(i).TableElemsDesc; '                                              'wyswietlenie etykiety z opisem
               IF _MOUSEBUTTON(1) THEN '                                                                                                                                            'klikniecie na znaku
                  Char$ = CHR$(TableElems(i).TableElemsChar) '                                                                                                                      'i zaladowanie go do zmiennej
               END IF
            ELSE '                                                                                                                                                                  'kursor poza znakiem
               COLOR 7, 1: LOCATE TableElems(i).TableElemsY, TableElems(i).TableElemsX: PRINT CHR$(TableElems(i).TableElemsChar); '                                                 'wyswietlenie znaku zwyklego
            END IF
         NEXT i ' . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 'koniec petli obslugi przybornika
         COLOR 7, 1: LOCATE PosY, PosX + 68: PRINT "elektryfikacja";
         IF CurX > PosX + 66 AND CurX < PosX + 70 AND CurY > PosY AND CurY < PosY + 4 THEN 'kursor znajduje sie nad przyciskiem
            COLOR , 7: LOCATE PosY + 1, PosX + 67: PRINT "   "; '                          '\
            LOCATE PosY + 2, PosX + 67: PRINT "   "; '                                     '  > przycisk w negatywie
            LOCATE PosY + 3, PosX + 67: PRINT "   "; '                                     '/
            COLOR 11, 1: LOCATE PosY + 3, PosX + 71: PRINT "tor bez sieci" '               'wyswietlenie etykiety z opisem
            IF _MOUSEBUTTON(1) THEN '                                                      'klikniecie przycisku
               Unclick: CharColor = 15 '                                                   'ustaw bialy kolor znakow na schemacie
            END IF
         ELSE '                                                                            'kursor poza przyciskiem
            COLOR 15,: LOCATE PosY + 1, PosX + 67: PRINT CHR$(219); CHR$(219); CHR$(219); ''\
            LOCATE PosY + 2, PosX + 67: PRINT CHR$(219); CHR$(219); CHR$(219); '           '  > przycisk zwykly
            LOCATE PosY + 3, PosX + 67: PRINT CHR$(219); CHR$(219); CHR$(219); '           '/
         END IF
         IF CurX > PosX + 69 AND CurX < PosX + 73 AND CurY > PosY AND CurY < PosY + 4 THEN 'kursor znajduje sie nad przyciskiem
            COLOR , 6: LOCATE PosY + 1, PosX + 70: PRINT "   "; '                          '\
            LOCATE PosY + 2, PosX + 70: PRINT "   "; '                                     '  > przycisk w negatywie
            LOCATE PosY + 3, PosX + 70: PRINT "   "; '                                     '/
            COLOR 11, 1: LOCATE PosY + 3, PosX + 71: PRINT "tor z siecia" '                'wyswietlenie etykiety z opisem
            IF _MOUSEBUTTON(1) THEN '                                                      'klikniecie przycisku
               Unclick: CharColor = 14 '                                                   'ustaw zolty kolor znakow na schemacie
            END IF
         ELSE '                                                                            'kursor poza przyciskiem
            COLOR 14,: LOCATE PosY + 1, PosX + 70: PRINT CHR$(219); CHR$(219); CHR$(219); ''\
            LOCATE PosY + 2, PosX + 70: PRINT CHR$(219); CHR$(219); CHR$(219); '           '  > przycisk zwykly
            LOCATE PosY + 3, PosX + 70: PRINT CHR$(219); CHR$(219); CHR$(219); '           '/
         END IF
         IF CharColor = 15 THEN
            COLOR 0, 7: LOCATE PosY + 2, PosX + 68: PRINT "X"; '                             'zaznaczenie aktywnego koloru
         END IF
         IF CharColor = 14 THEN
            COLOR 0, 6: LOCATE PosY + 2, PosX + 71: PRINT "X"; '                             'zaznaczenie aktywnego koloru
         END IF
         ''''''''''''''''''''KONIEC PROCEDURY PRZYBORNIKA
         IF MapCurX >= 1 AND MapCurX <= 65 AND MapCurY >= 1 AND MapCurY <= 25 AND _MOUSEBUTTON(1) AND Char$ <> "" THEN 'klikniecie w ramce mapy
            Unclick
            '1. WPISYWANIE DO TABELI
            IF Char$ <> CHR$(42) THEN 'znak nie jest *
               IF MapTableRecCount = UBOUND(MapTable) THEN 'jezeli do tabeli juz cos wpisano:
                  FOR i = 1 TO UBOUND(MapTable) 'przeszukaj tabele
                     IF MapCurY = MapTable(i).CharY AND MapCurX = MapTable(i).CharX THEN RecNr = i: EditFullMapTableDel: EXIT FOR 'jesli istnieje juz wpis o tych wspolrzednych to go usun
                  NEXT i 'koniec przeszukiwania tabeli pod katem wpisu o tych samych koordynatach
                  IF UBOUND(MapTable) = 0 THEN REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable
                  IF MapTable(1).CharY <> 0 THEN 'pierwszy wiersz tabeli nie zawiera wpisu 0,0,0,0
                     REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable 'powieksz tabele tworzac nowy, pusty rekord
                  ELSE
                     RecNr = UBOUND(MapTable) 'pierwszy rekord zawiera zera wiec nadpisac go
                  END IF
               END IF
               RecNr = UBOUND(MapTable) '                                          'przenosi miejsce wpisania nowego rekordu na koniec tabeli
               IF ASC(Char$) <> 0 THEN '                                           'zapobiega utworzeniu pustego rekordu
                  MapTable(RecNr).CharY = MapCurY: MapTable(RecNr).CharX = MapCurX 'zapisuje do tabeli polozenie kursora na mapie
                  MapTable(RecNr).CharColor = CharColor '                          'DODAC KOLOR TLA ZNAKU : MapTable(RecNr).CharBack = CharBack
                  MapTable(RecNr).CharCode = ASC(Char$) '                          'zapisuje do tabeli kod ASCII znaku
                  MapTableRecCount = MapTableRecCount + 1 '                        'aktualizuje licznik rekordow
               END IF
               EditFullMapTableDisplay MapTableRecCount, MapPosX, MapPosY, MapWidth, MapHeight, ShiftX, ShiftY
               '2. USUWANIE Z TABELI
            ELSE 'znak jest * o wspolrzednych MapY, MapX AND liczba_rekordow_tabeli_mapy > 0   AND liczba_rekordow_tabeli_mapy = UBOUND(tabela_mapa)
               'pobranie do zmiennej RecNr numeru wpisu o wspolrzednych wiersz_mapy i kolumna_mapy
               FOR i = 1 TO UBOUND(MapTable) 'wyszkuje w tabeli rekord o podanych wspolrzednych
                  IF MapCurY = MapTable(i).CharY AND MapCurX = MapTable(i).CharX THEN
                     RecNr = i
                     EditFullMapTableDel
                     COLOR , 1: LOCATE CurY, CurX: PRINT " "; 'czysci znak z podgladu mapy
                     EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                  END IF
               NEXT i
               EditFullMapTableDisplay MapTableRecCount, MapPosX, MapPosY, MapWidth, MapHeight, ShiftX, ShiftY
            END IF
            '3. AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
            OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1
            FOR RecNr = 1 TO UBOUND(MapTable)
               WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode
            NEXT RecNr
            CLOSE #1
         END IF
         EditFullMapMove CurX, CurY, MapPosX, MapPosY, MapHeight, MapWidth 'przesuwanie mapy
         'pasek_informacyjny pasek_informacyjny_tresc
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "P" THEN EditMenuFile TempVar 'procedura menu zwraca zmienna TempVar
      IF TempVar = 1 THEN CLS , 1: EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna TempVar, ktora wychodzi z TEJ petli
      IF Key$ = "W" THEN EditFullMenuLayer LayerNr
   LOOP
END SUB
'========================================================================================='
'                 EDYTOR MAP - TRYB PELNY - WARSTWA PARAMETROW TOROW                      '
'========================================================================================='
SUB EditFullTracks '2. warstwa - oznaczanie parametrow torow na schemacie
   DO
      DO: _LIMIT 500
         PosX = 1: PosY = 2 'polozenie poczatku ramki
         MapHeight = 23: MapWidth = 65 'wymiary wnetrza ramki
         FrameCharColor = 0: FrameBackColor = 3 'kolory ramki
         FrameTop$ = CHR$(205): FrameBottom$ = CHR$(205): FrameSide$ = CHR$(186)
         FrameDraw PosY, PosX, MapHeight, MapWidth, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$ 'ramka mapy
         CurCoord CurX, CurY
         'obliczanie pozycji kursora na mapie
         MapY = CurY - MapCurY
         MapX = CurX + MapCurX - 3
         'wyswietlanie pozycji kursora na mapie
         MapYCapped = MapY
         MapXCapped = MapX
         IF MapY < 1 THEN MapYCapped = 1
         IF MapY > 25 THEN MapYCapped = 25
         IF MapX < 1 THEN MapXCapped = 1
         IF MapX > 68 THEN MapXCapped = 60
         COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT MapYCapped;
         LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT MapXCapped;
         'pasek menu
         COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Warstwy  Instrukcja  Slownik                                            ";
         COLOR 4: LOCATE 1, 6: PRINT "k"; 'czerwone litery
         LOCATE 1, 9: PRINT "W";
         'ramka mapy
         'wspolrzedne kursora na mapie
         'wyswietlanie mapy z pliku
         'zdarzenia myszy
         IF CurY = 1 AND _MOUSEBUTTON(1) THEN
            Unclick
            IF CurX > 1 AND CurX < 6 THEN EditMenuFile TempVar
            IF CurX > 7 AND CurX < 17 THEN EditFullMenuLayer LayerNr
            CLS , 1
         END IF
         '1. klikanie LPM na mapie w celu podswietlenia elementow
         IF CurY > FramePosY AND CurY < FramePosY + FrameLineCount + 1 AND CurX > FramePosX AND CurX < FramePosX + FrameTxtLength + 1 AND _MOUSEBUTTON(1) THEN 'sprawdzenie, czy klikniecie jest wewnatrz ramki
            'wyszukanie w tabeli mapy kliknietego elementu i podswietlenie go (negatyw) NIE DZIALA
            FOR i = 1 TO UBOUND(MapTable) 'przeszukaj tabele
               IF MapY = MapTable(i).CharY AND MapX = MapTable(i).CharX THEN
                  COLOR 0, 3: LOCATE MapTable(i).CharY, MapTable(i).CharX: PRINT Char$
                  EXIT FOR 'jesli znaleziono element, to mozna wyjsc z szukania i wrocic do klikania
               END IF
            NEXT i
         END IF
         '2. klikniecie PPM na zaznaczeniu otwiera dialog z parametrami toru (szlakowy/stacyjny, glowny/boczny) i polami tekstowymi dla jego numeru oraz dlugosci
         '3. zamkniecie wypelnionego dialogu uruchamia zapis tabeli do pliku toru, np. tor1szl.txt, tor169sta.txt
         '4. mozliwosc edycji i skasowania utworzonej tabeli i pliku (PPM -> edytuj/skasuj)
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
   LOOP
END SUB
'========================================================================================='
'                 EDYTOR MAP - TRYB PELNY - WARSTWA URZADZEN I SYGNALOW                   '
'========================================================================================='
SUB EditFullDevices
END SUB
'========================================================================================='
'                    EDYTOR MAP - TRYB PELNY - WARSTWA PRZEBIEGOW                         '
'========================================================================================='
SUB EditFullWays
END SUB
'========================================================================================='
'                  EDYTOR MAP - TRYB PELNY - WARSTWA ROZKLADU JAZDY                       '
'========================================================================================='
SUB EditFullSched
END SUB
'========================================================================================='
'                         EDYTOR MAP - TRYB PELNY - MENU WARSTW                           '
'========================================================================================='
SUB EditFullMenuLayer (TempVar) 'menu Warstwy w edytorze trybu pelnego
   TempVar = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
   PosX = 7: PosY = 2 'wspolrzedne poczatku ramki
   LineCount = 5: TxtLength = 22 'liczba pozycji menu, dlugosc pozycji menu ze spacjami
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosX, PosY, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 8, 0: LOCATE PosY - 1, PosX + 1: PRINT " Warstwy " 'odwroc kolory w nazwie otwartego menu
   DO 'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord CurX, CurY
         'opcje menu i podswietlanie wskazanej
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 3 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 1, PosX + 1: PRINT " Schemat torow        " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullMap TempVar 'procedura rysowania schematu torow
         ELSE
            COLOR 0, 7: LOCATE PosY + 1, PosX + 1: PRINT " Schemat torow        " 'napis zwykly
            COLOR 4: LOCATE PosY + 1, PosX + 2: PRINT "S" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 4 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 2, PosX + 1: PRINT " Oznaczanie torow     " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullTracks 'procedura oznaczania parametrow torow
         ELSE
            COLOR 0, 7: LOCATE PosY + 2, PosX + 1: PRINT " Oznaczanie torow     " 'napis zwykly
            COLOR 4: LOCATE PosY + 2, PosX + 2: PRINT "O" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 5 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 3, PosX + 1: PRINT " Urzadzenia i sygnaly " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullDevices 'procedura oznaczania urzadzen i sygnalow
         ELSE
            COLOR 0, 7: LOCATE PosY + 3, PosX + 1: PRINT " Urzadzenia i sygnaly " 'napis zwykly
            COLOR 4: LOCATE PosY + 3, PosX + 2: PRINT "U" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 6 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 4, PosX + 1: PRINT " Przebiegi            " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullWays 'procedura oznaczania przebiegow
         ELSE
            COLOR 0, 7: LOCATE PosY + 4, PosX + 1: PRINT " Przebiegi            " 'napis zwykly
            COLOR 4: LOCATE PosY + 4, PosX + 2: PRINT "P" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 7 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 5, PosX + 1: PRINT " Rozklad jazdy        " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullSched 'procedura ukladania rozkladu jazdy
         ELSE
            COLOR 0, 7: LOCATE PosY + 5, PosX + 1: PRINT " Rozklad jazdy        " 'napis zwykly
            COLOR 4: LOCATE PosY + 5, PosX + 2: PRINT "R" 'czerwona litera
         END IF
         IF (CurX < PosX OR CurX > PosX + TxtLength + 1 OR CurY < PosY OR CurY > PosY + LineCount + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klik poza menu
      LOOP WHILE _MOUSEINPUT
      SELECT CASE Key$ 'obsluga menu klawiszami
         CASE "S"
            EditFullMap TempVar: EXIT SUB
         CASE "O"
            EditFullTracks: EXIT SUB
         CASE "U"
            EditFullDevices: EXIT SUB
         CASE "P"
            EditFullWays: EXIT SUB
         CASE "R"
            EditFullSched: EXIT SUB
         CASE CHR$(27) '[Esc]
            CLS , 0: EXIT SUB
      END SELECT
   LOOP
END SUB
'=============================================================================='
'                 EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY                   '
'=============================================================================='
SUB EditFullMapMove (CurX, CurY, MapPosX, MapPosY, MapHeight, MapWidth)
   COLOR 7, 1: LOCATE 14, 70: PRINT "przesuwanie";
   COLOR 7, 1: LOCATE 15, 71: PRINT "mapy";
   IF CurX = 71 AND CurY = 16 THEN ' . . . . . . . . . . . . LEFT. . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 71: PRINT CHR$(17); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveLeft MapPosX, MapPosY, MapHeight, MapWidth '                         'wywolaj procedure przesuwania mapy
         ELSE
            COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                                 'pasek powiadomien
         END IF
      END IF
   ELSE '                                                                                                'kursor poza przyciskiem
      COLOR 7, 1: LOCATE 16, 71: PRINT CHR$(17); '                                                       'strzalka zwykla
   END IF
   IF CurX = 73 AND CurY = 16 THEN ' . . . . . . . . . . . . RIGHT . . . . . . . . . . . . . . . . . . . 'kursor na strzalce
      COLOR 0, 3: LOCATE 16, 73: PRINT CHR$(16); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveRight MapPosX, MapPosY, MapHeight, MapWidth '                        'wywolaj procedure przesuwania mapy
         ELSE
            COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                                 'pasek powiadomien
         END IF
      END IF
   ELSE '                                                                                                'kursor poza przyciskiem
      COLOR 7, 1: LOCATE 16, 73: PRINT CHR$(16); '                                                       'strzalka zwykla
   END IF
   IF CurX = 75 AND CurY = 16 THEN ' . . . . . . . . . . . . UP. . . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 75: PRINT CHR$(30); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveUp MapPosX, MapPosY, MapHeight, MapWidth '                           'wywolaj procedure przesuwania mapy
         ELSE
            COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                                 'pasek powiadomien
         END IF
      END IF
   ELSE '                                                                                                'kursor poza przyciskiem
      COLOR 7, 1: LOCATE 16, 75: PRINT CHR$(30); '                                                       'strzalka zwykla
   END IF
   IF CurX = 77 AND CurY = 16 THEN ' . . . . . . . . . . . . DOWN. . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 77: PRINT CHR$(31); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveDown MapPosX, MapPosY, MapHeight, MapWidth '                         'wywolaj procedure przesuwania mapy
         ELSE
            COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                                 'pasek powiadomien
         END IF
      END IF
   ELSE '                                                                                                'kursor poza przyciskiem
      COLOR 7, 1: LOCATE 16, 77: PRINT CHR$(31); '                                                       'strzalka zwykla
   END IF
END SUB
'=============================================================================='
'              EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W LEWO               '
'=============================================================================='
SUB EditFullMapMoveLeft (MapPosX, MapPosY, MapHeight, MapWidth)
   FOR RecNr = 1 TO UBOUND(MapTable) '                                                                            'bierze po jednym rekordzie
      IF MapTable(RecNr).CharX > MapPosX AND MapTable(RecNr).CharX < MapPosX + MapWidth AND MapTable(RecNr).CharY > MapPosY AND MapTable(RecNr).CharY < MapPosY + MapHeight THEN 'uniemozliwia nadpisanie znaku poza ramka mapy
         COLOR , 1: LOCATE MapTable(RecNr).CharY + MapPosY, MapTable(RecNr).CharX + MapPosX: PRINT " " '                      'nadpisuje stary znak na mapie, +2 i +1 to offset mapy wzgledem okna
      END IF
      MapTable(RecNr).CharX = MapTable(RecNr).CharX - 1 '                                                         'zmienia wspolrzedna w tym rekordzie
   NEXT RecNr
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1 '                               'zapisz tabele do pliku tymczasowego
   FOR RecNr = 1 TO UBOUND(MapTable)
      WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode 'wypisuje znak na nowej pozycji
   NEXT RecNr
   CLOSE #1
END SUB
'=============================================================================='
'             EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W PRAWO               '
'=============================================================================='
SUB EditFullMapMoveRight (MapPosX, MapPosY, MapHeight, MapWidth)
   FOR RecNr = 1 TO UBOUND(MapTable) '                                                                            'bierze po jednym rekordzie
      IF MapTable(RecNr).CharX > MapPosX AND MapTable(RecNr).CharX < MapPosX + MapWidth AND MapTable(RecNr).CharY > MapPosY AND MapTable(RecNr).CharY < MapPosY + MapHeight THEN 'uniemozliwia nadpisanie znaku poza ramka mapy
         COLOR , 1: LOCATE MapTable(RecNr).CharY + MaPosY, MapTable(RecNr).CharX + MapPosX: PRINT " " '                      'nadpisuje stary znak na mapie, +2 i +1 to offset mapy wzgledem okna
      END IF
      MapTable(RecNr).CharX = MapTable(RecNr).CharX + 1 '                                                         'zmienia wspolrzedna w tym rekordzie
   NEXT RecNr
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1 '                               'zapisz tabele do pliku tymczasowego
   FOR RecNr = 1 TO UBOUND(MapTable)
      WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode 'wypisuje znak na nowej pozycji
   NEXT RecNr
   CLOSE #1
END SUB
'=============================================================================='
'              EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W GORE               '
'=============================================================================='
SUB EditFullMapMoveUp (MapPosX, MapPosY, MapHeight, MapWidth)
   FOR RecNr = 1 TO UBOUND(MapTable) '                                                                            'bierze po jednym rekordzie
      IF MapTable(RecNr).CharX > MapPosX AND MapTable(RecNr).CharX < MapPosX + MapWidth AND MapTable(RecNr).CharY > MapPosY AND MapTable(RecNr).CharY < MapPosY + MapHeight THEN 'uniemozliwia nadpisanie znaku poza ramka mapy
         COLOR , 1: LOCATE MapTable(RecNr).CharY + MapPosY, MapTable(RecNr).CharX + MapPosX: PRINT " " '                      'nadpisuje stary znak na mapie, +2 i +1 to offset mapy wzgledem okna
      END IF
      MapTable(RecNr).CharY = MapTable(RecNr).CharY - 1 '                                                         'zmienia wspolrzedna w tym rekordzie
   NEXT RecNr
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1 '                               'zapisz tabele do pliku tymczasowego
   FOR RecNr = 1 TO UBOUND(MapTable)
      WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode 'wypisuje znak na nowej pozycji
   NEXT RecNr
   CLOSE #1
END SUB
'=============================================================================='
'               EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W DOL               '
'=============================================================================='
SUB EditFullMapMoveDown (MapPosX, MapPosY, MapHeight, MapWidth)
   FOR RecNr = 1 TO UBOUND(MapTable) '                                                                            'bierze po jednym rekordzie
      IF MapTable(RecNr).CharX > MapPosX AND MapTable(RecNr).CharX < MapPosX + MapWidth AND MapTable(RecNr).CharY > MapPosY AND MapTable(RecNr).CharY < MapPosY + MapHeight THEN 'uniemozliwia nadpisanie znaku poza ramka mapy
         COLOR , 1: LOCATE MapTable(RecNr).CharY + MapPosY, MapTable(RecNr).CharX + MapPosX: PRINT " " '                      'nadpisuje stary znak na mapie, +2 i +1 to offset mapy wzgledem okna
      END IF
      MapTable(RecNr).CharY = MapTable(RecNr).CharY + 1 '                                                         'zmienia wspolrzedna w tym rekordzie
   NEXT RecNr
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1 '                               'zapisz tabele do pliku tymczasowego
   FOR RecNr = 1 TO UBOUND(MapTable)
      WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode 'wypisuje znak na nowej pozycji
   NEXT RecNr
   CLOSE #1
END SUB
'------------------------------------------------------------------------------'
'                        EDYTOR MAP - TRYB UPROSZCZONY                         '
'------------------------------------------------------------------------------'
'wybor edytora - nowa mapa lub istniejaca
'------------------------------------------------------------------------------'
'                                 EDYTOR TABORU                                '
'------------------------------------------------------------------------------'
'nic
'=============================================================================='
'            EDYTOR MAP - TRYB PELNY - WYSWIETLANIE TABELI MAPY                '
'=============================================================================='
SUB EditFullMapTableDisplay (MapTableRecCount, MapPosX, MapPosY, MapWidth, MapHeight, ShiftX, ShiftY)
   IF MapTableRecCount > 0 THEN 'tylko jesli cokolwiek wpisano do tabeli
      FOR RecNr = 1 TO UBOUND(MapTable) 'wyswietl kazdy znak ktory miesci sie w ramce mapy
         IF MapTable(RecNr).CharX + ShiftX > MapPosX - 1 AND MapTable(RecNr).CharX + ShiftX < MapPosX + MapWidth AND MapTable(RecNr).CharY + ShiftY > MapPosY - 2 AND MapTable(RecNr).CharY + ShiftY < MapPosY + MapHeight - 1 THEN
            COLOR MapTable(RecNr).CharColor, 1: LOCATE MapTable(RecNr).CharY + MapPosY + ShiftY, MapTable(RecNr).CharX + MapPosX + ShiftX: PRINT CHR$(MapTable(RecNr).CharCode)
            COLOR 2, 6: LOCATE 13, 13: PRINT ShiftX;
         END IF
      NEXT RecNr
   END IF
END SUB
'=============================================================================='
'              EDYTOR MAP - TRYB PELNY - USUWANIE Z TABELI MAPY                '
'=============================================================================='
SUB EditFullMapTableDel
   'usuwanie konkretnego wpisu: za dany wpis podstawia sie ostatni
   MapTable(RecNr).CharY = MapTable(UBOUND(MapTable)).CharY
   MapTable(RecNr).CharX = MapTable(UBOUND(MapTable)).CharX
   MapTable(RecNr).CharColor = MapTable(UBOUND(MapTable)).CharColor
   MapTable(RecNr).CharCode = MapTable(UBOUND(MapTable)).CharCode
   'ostatni wpis teraz jest dublem wiec trzeba upierdolic tabele o ten rekord
   REDIM _PRESERVE MapTable(UBOUND(MapTable) - 1) AS TypeMapTable '_PRESERVE zeby REDIM nie czyscil rekordow przy zmianie wielkosci tabeli
   MapTableRecCount = MapTableRecCount - 1 'aktualizuj licznik rekordow
END SUB
'=============================================================================='
'                     EDYTOR MAP - OBA TRYBY - MENU PLIK                       '
'=============================================================================='
SUB EditMenuFile (TempVar)
   TempVar = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
   PosX = 1: PosY = 2
   LineCount = 4: TxtLength = 11
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosX, PosY, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 8, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
   DO 'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord CurX, CurY
         'opcje menu i podswietlanie wskazanej
         IF CurY = 3 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 3, 2: PRINT " Nowa mapa " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: edytor_dialog_nowa_mapa CurY, CurX: EXIT SUB 'okienko dialogowe do rozpoczynania nowej, czystej mapy
         ELSE
            COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa mapa " 'napis zwykly
            COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
         END IF
         IF CurY = 4 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 4, 2: PRINT " Wczytaj   " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: edytor_dialog_wczytaj CurY, CurX: EXIT SUB 'okienko zapisu mapy do pliku mapa.txt
         ELSE
            COLOR 0, 7: LOCATE 4, 2: PRINT " Wczytaj   " 'napis zwykly
            COLOR 4: LOCATE 4, 3: PRINT "W" 'czerwona litera
         END IF
         IF CurY = 5 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 5, 2: PRINT " Zapisz    " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: edytor_dialog_zapisz CurY, CurX: EXIT SUB 'okienko zapisu mapy do pliku mapa.txt
         ELSE
            COLOR 0, 7: LOCATE 5, 2: PRINT " Zapisz    " 'napis zwykly
            COLOR 4: LOCATE 5, 3: PRINT "Z" 'czerwona litera
         END IF
         IF CurY = 6 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 6, 2: PRINT " Koniec    " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: TempVar = 1: EXIT SUB 'koniec, TempVar po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
         ELSE
            COLOR 0, 7: LOCATE 6, 2: PRINT " Koniec    " 'napis zwykly
            COLOR 4: LOCATE 6, 3: PRINT "K" 'czerwona litera
         END IF
         'zdarzenia myszy
         IF (CurX > PosX + TxtLength + 3 OR CurY = 1 OR CurY > PosY + LineCount + 1) AND _MOUSEBUTTON(1) THEN Unclick: CLS , 0: EXIT SUB 'klikniecie poza menu
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "N" THEN edytor_dialog_nowa_mapa CurX, CurY: EXIT SUB 'okienko rozpoczynania nowej, czystej mapy
      IF Key$ = "W" THEN edytor_dialog_wczytaj CurX, CurY: EXIT SUB
      IF Key$ = "Z" THEN edytor_dialog_zapisz CurX, CurY: EXIT SUB
      IF Key$ = "K" THEN TempVar = 1: EXIT SUB 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
      IF Key$ = CHR$(27) THEN CLS , 0: EXIT SUB 'Esc
   LOOP
END SUB

SUB edytor_dialog_nowa_mapa (CurX, CurY) 'okienko dialogowe do rozpoczynania nowej, czystej mapy
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: LineCount = 4: TxtLength = 22
         FrameDraw PosX, PosY, LineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Nowa mapa "
         LOCATE PosY + 1, PosX + 1: PRINT " Dotychczasowy postep ";
         LOCATE PosY + 2, PosX + 1: PRINT " zostanie utracony.   ";
         LOCATE PosY + 3, PosX + 1: PRINT "      Na pewno?       ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak            Nie  ";
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T";
         LOCATE PosY + 4, PosX + 18: PRINT "N";
         CurCoord CurX, CurY
         'zdarzenia myszy
         IF CurY = PosY + 4 AND CurX > PosX + 1 AND CurX < PosX + 7 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 2: PRINT " Tak "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: REDIM MapTable(1) AS TypeMapTable: MapTableRecCount = 0: EXIT SUB 'przewymiaruj tabele i zamknij okienko
         END IF
         IF CurY = PosY + 4 AND CurX > PosX + 16 AND CurX < PosX + 22 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 17: PRINT " Nie "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "T" OR Key$ = CHR$(13) THEN REDIM MapTable(1) AS TypeMapTable: EXIT SUB 'przewymiaruj tabele bez zachowania tresci i zamknij okienko
      IF Key$ = "N" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB
'====================================================================='
'                EDYTOR - OBA TRYBY - DIALOG WCZYTAJ                  '
'====================================================================='
SUB edytor_dialog_wczytaj (CurX, CurY)
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: LineCount = 4: TxtLength = 22
         FrameDraw PosX, PosY, LineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Wczytaj "
         LOCATE PosY + 1, PosX + 1: PRINT " Dotychczasowy postep ";
         LOCATE PosY + 2, PosX + 1: PRINT " zostanie utracony.   ";
         LOCATE PosY + 3, PosX + 1: PRINT "      Na pewno?       ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak            Nie  ";
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T";
         LOCATE PosY + 4, PosX + 18: PRINT "N";
         CurCoord CurX, CurY
         'zdarzenia myszy
         IF CurY = PosY + 4 AND CurX > PosX + 1 AND CurX < PosX + 7 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 2: PRINT " Tak "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN
               Unclick
               REDIM MapTable(1) AS TypeMapTable 'przygotuj tabele na nowe dane
               MapTableRecCount = 0
               OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR INPUT AS #1 'otworz plik mapa.txt i wczytaj go do tabeli
               DO WHILE NOT EOF(1)
                  IF UBOUND(MapTable) = MapTableRecCount THEN REDIM _PRESERVE MapTable(UBOUND(MapTable) + 1) AS TypeMapTable 'jesli brak pustego rekordu to dodaj go
                  INPUT #1, MapTable(UBOUND(MapTable)).CharY, MapTable(UBOUND(MapTable)).CharX, MapTable(UBOUND(MapTable)).CharColor, MapTable(UBOUND(MapTable)).CharCode
                  MapTableRecCount = MapTableRecCount + 1
               LOOP
               CLOSE #1
               EXIT SUB
            END IF
         END IF
         IF CurY = PosY + 4 AND CurX > PosX + 16 AND CurX < PosX + 20 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 17: PRINT " Nie "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EXIT SUB
         END IF
         IF (CurY < PosY OR CurY > PosY + LineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klikniecie poza ramka
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "T" OR Key$ = CHR$(13) THEN
         REDIM MapTable(1) AS TypeMapTable 'przygotuj tabele na nowe dane
         MapTableRecCount = 0
         OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR INPUT AS #1 'otworz plik mapa.txt i wczytaj go do tabeli
         DO WHILE NOT EOF(1)
            IF UBOUND(MapTable) = MapTableRecCount THEN REDIM MapTable(UBOUND(MapTable) + 1) AS TypeMapTable 'jesli brak pustego rekordu to dodaj go
            INPUT #1, MapTable(UBOUND(MapTable)).CharY, MapTable(UBOUND(MapTable)).CharX, MapTable(UBOUND(MapTable)).CharColor, MapTable(UBOUND(MapTable)).CharCode
            MapTableRecCount = MapTableRecCount + 1
         LOOP
         CLOSE #1
         EXIT SUB
      END IF
      IF Key$ = "N" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB
'====================================================================='
'                EDYTOR - OBA TRYBY - DIALOG ZAPISZ                   '
'====================================================================='
SUB edytor_dialog_zapisz (CurX, CurY)
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: LineCount = 4: TxtLength = 20
         FrameDraw PosX, PosY, LineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Zapisz "
         LOCATE PosY + 1, PosX + 1: PRINT " Zostanie nadpisany ";
         LOCATE PosY + 2, PosX + 1: PRINT " plik mapa.txt.     ";
         LOCATE PosY + 3, PosX + 1: PRINT "     Na pewno?      ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak          Nie  ";
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T": LOCATE PosY + 4, PosX + 16: PRINT "N";
         CurCoord CurX, CurY
         'zdarzenia myszy
         IF CurY = PosY + 4 AND CurX > PosX + 1 AND CurX < PosX + 7 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 2: PRINT " Tak "; 'napis w negatywie
            IF MapTableRecCount > 0 THEN 'wykluczenie mozliwosci zapisu pustej mapy
               IF _MOUSEBUTTON(1) THEN
                  Unclick: OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1
                  FOR RecNr = 1 TO UBOUND(MapTable)
                     WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode
                  NEXT RecNr
                  CLOSE #1
                  EXIT SUB
               END IF
            ELSE
               COLOR 4, 0: LOCATE 25, 1: PRINT "Nie mozna zapisac pustej mapy."; 'PRZENIESC TO NA PASEK KOMUNIKATOW
            END IF
         END IF
         IF CurY = PosY + 4 AND CurX > PosX + 14 AND CurX < PosX + 20 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 15: PRINT " Nie "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EXIT SUB
         END IF
         IF (CurY < PosY OR CurY > PosY + LineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klikniecie poza ramka
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "T" OR Key$ = CHR$(13) THEN
         IF MapTableRecCount > 0 THEN 'wykluczenie mozliwosci zapisu pustej mapy
            OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1
            FOR RecNr = 1 TO UBOUND(MapTable)
               WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode
            NEXT RecNr
            CLOSE #1
            EXIT SUB
         ELSE
            COLOR 4, 0: LOCATE 25, 1: PRINT "Nie mozna zapisac pustej mapy."; 'PRZENIESC TO NA PASEK KOMUNIKATOW
         END IF
      END IF
      IF Key$ = "N" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB

'$include: 'procedury.bi'
