_CONTROLCHR OFF 'umozliwia wypisywanie na ekranie znakow kontrolnych
'$DYNAMIC 'umozliwia zmiane dlugosci tabeli poleceniem REDIM
'$DEBUG
OPTION BASE 1 'pierwszy rekord tabeli domyslnie bedzie mial numer 1 zamiast 0
'====================================================================================================='
'                                        DEKLARACJE ZMIENNYCH                                         '
'====================================================================================================='
DIM BtnOff AS _UNSIGNED _BIT '                 przycisk niedostepny tak/nie
DIM SHARED BtnStat AS STRING '                 status przycisku
DIM SHARED Char AS STRING '                    przenosi znak z przybornika na schemat
DIM SHARED ColumnCount AS _UNSIGNED _BYTE
DIM SHARED CurY AS _UNSIGNED _BYTE '           wspolrzedne kursora w oknie programu
DIM SHARED CurX AS _UNSIGNED _BYTE
DIM SHARED LineCount AS _UNSIGNED _BYTE
DIM SHARED SwitchChar1 AS _UNSIGNED _BYTE '    kod ASCII znaku przedstawiajacego rozjazd w oknie dialogowym
DIM SHARED SwitchChar2 AS _UNSIGNED _BYTE '                          -||-
DIM SHARED SwitchChar3 AS _UNSIGNED _BYTE '                          -||-
DIM SHARED SwitchChar4 AS _UNSIGNED _BYTE '                          -||-
DIM SHARED SwitchDialogOpen AS _UNSIGNED _BIT 'okno dialogowe rozjazdu otwarte tak/nie
DIM SHARED SwitchDirX AS STRING '              robocza wersja dwucyfrowego ciagu opisujacego polozenie rozjazdu
DIM SHARED SwitchDir1 AS STRING '              gotowy dwucyfrowy ciag opisujacy polozenie rozjazdu
DIM SHARED SwitchDir2 AS STRING '                                    -||-
DIM SHARED SwitchDir3 AS STRING '                                    -||-
DIM SHARED SwitchDir4 AS STRING '                                    -||-
DIM SHARED SwitchDirA AS STRING '              oznaczenie polozenia rozjazdu z uzyciem znakow abcd-+
DIM SHARED SwitchDirB AS STRING '                                    -||-
DIM SHARED SwitchDirC AS STRING '                                    -||-
DIM SHARED SwitchDirD AS STRING '                                    -||-
DIM SHARED SwicthDirL AS STRING '              robocze oznaczenie polozenia rozjazdu z uzyciem znakow abcd-+ przed przypisaniem do numeru polozenia
DIM SHARED SwitchDirCount AS _UNSIGNED _BYTE ' liczba polozen rozjazdu 2ö4
DIM SwitchDirKeep AS _UNSIGNED _BYTE '         wybrany do zachowania numer znaku w ciagu j. w.
DIM SHARED SwitchDirNum AS _UNSIGNED _BYTE '   liczba mozliwych polozen rozjazdu 1ö4
DIM SwitchDirStrLen AS _UNSIGNED _BYTE '       dlugosc ciagu okreslajacego kierunki rozjazdu, moze byc 1 lub 2
DIM SHARED SwitchType AS STRING '              typ rozjazdu: zwyczajny, krzyzowy pojedynczy, krzyzowy podwojny
DIM SHARED MapTableRecCount AS INTEGER
DIM SHARED FramePosX AS _UNSIGNED _BYTE
DIM SHARED FramePosY AS _UNSIGNED _BYTE
'====================================================================================================='
'                                          DEKLARACJE STALYCH                                         '
'====================================================================================================='
_TITLE "Stacja"
GameDir$ = ".\"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
LineCount = 50: ColumnCount = 80 'wymiary okna gry
'====================================================================================================='
'                                           DEKLARACJE TYPOW                                          '
'====================================================================================================='
TYPE TypeMapTable '                  'typ dla tabeli mapy
   CharY AS SINGLE '                 'wspolrzedne znaku
   CharX AS SINGLE
   CharColor AS _BYTE
   CharCode AS _UNSIGNED _BYTE
END TYPE
TYPE TypeSwitchTable '               'typ danych w tabeli rozjazdow
   SwitchY AS SINGLE '               'wspolrzedne rozjazdu
   SwitchX AS SINGLE
   SwitchNr AS STRING '              'numer rozjazdu
   SwitchDirCount AS _UNSIGNED _BYTE 'liczba polozen rozjazdu
   SwitchChar1 AS _UNSIGNED _BYTE '  'kod ASCII znaku
   SwitchDir1 AS STRING '            'dwucyfrowy ciag okreslajacy polozenie rozjazdu
   SwitchDirA AS STRING '            'polozenie rozjazdu abcd+-
   SwitchChar2 AS _UNSIGNED _BYTE
   SwitchDir2 AS STRING
   SwitchDirB AS STRING
   SwitchChar3 AS _UNSIGNED _BYTE
   SwitchDir3 AS STRING
   SwitchDirC AS STRING
   SwitchChar4 AS _UNSIGNED _BYTE
   SwitchDir4 AS STRING
   SwitchDirD AS STRING
END TYPE
'=============================================================================='
'                                DEKLARACJE TABEL                              '
'=============================================================================='
DIM SHARED MapTable(1) AS TypeMapTable '     'tabela do przechowywania mapy w pamieci
DIM SHARED SwitchTable(1) AS TypeSwitchTable 'tabela rozjazdow
'=============================================================================='
'                                 EKRAN TYTULOWY                               '
'=============================================================================='
SCREEN 0
WIDTH ColumnCount, LineCount 'wymiary okna gry
DO
   tytul_logo 'logo gry
   COLOR 4, 1: LOCATE 30, 1: PRINT "v0.1 (c) 2023ö2025 Emil Sawicki";
   Key$ = UCASE$(INKEY$)
   DO: _LIMIT 500
      CurCoord
      TitleMenu 'rysowanie menu z podswietlaniem wskazanej opcji
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
LOOP

SUB tytul_menu_nowagra 'ekran tytulowy - submenu "Nowa gra"
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         COLOR 7, 8: LOCATE 17, 31: PRINT "     Nowa gra     " 'tytul tego menu jako nieaktywny "przycisk"
         CurCoord
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
         CurCoord
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
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500 '                                                                                                   'zdarzenia myszy
         CurCoord
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
   FrameLineCount = 4
   TxtLength = 8
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, FrameLineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
   'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord
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
         IF (CurX > PosX + TxtLength + 3 OR CurY > PosY + FrameLineCount + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
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
   FrameLineCount = 1
   TxtLength = 7
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(205): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, FrameLineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 7, 0: LOCATE 1, 8: PRINT " Pociagi " 'odwroc kolory w nazwie otwartego okna
   'zawartosc okna
   COLOR 0, 7: LOCATE PosY + 1, PosX + 2: PRINT "Pociagi "
   'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie okna
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord
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
         IF (CurY < PosY OR CurY > PosY + FrameLineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 3) AND _MOUSEBUTTON(1) THEN
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
'====================================================================================================='
'                               EDYTOR MAP - TRYB PELNY - WARSTWA MAPY                                '
' Rysowanie schematu stacji znakami ASCII; opisywanie parametrow torow, rozjazdow i sygnalizatorow.   '
'====================================================================================================='
'wybor edytora - nowa mapa lub istniejaca
SUB EditFullMap (TempVar) '1. warstwa - rysowanie schematu torow
   CLS , 0
   'edytor_tryb_pelny_sprawdzanie_plikow
   MapHeight = 25: MapWidth = 65 '            'wymiary ramki mapy
   MapPosX = 1: MapPosY = 6 '                 'poczatek ramki mapy
   MapY = MapPosY + 1: MapX = 1 = MapPosX + 1 'poczatek mapy
   CharColor = 15: BackColor = 0 '            'domyslne kolory: bialy i czarny
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CLS , 0
         FrameTop$ = CHR$(205): FrameBottom$ = CHR$(205): FrameSide$ = CHR$(186)
         FrameDraw MapPosY, MapPosX, MapHeight, MapWidth, 0, 3, FrameTop$, FrameBottom$, FrameSide$ 'ramka mapy
         CurCoord
         MapCurY = CurY - MapPosY: MapCurX = CurX - MapPosX 'obliczanie pozycji kursora na mapie
         MapCurXCapped = MapCurX: MapCurYCapped = MapCurY ' 'wyswietlanie rzeczywistej pozycji kursora na mapie
         IF MapCurY < 1 THEN MapCurYCapped = 1 '            'ograniczenie w sytuacji wyjechania kursorem poza mape
         IF MapCurY > 25 THEN MapCurYCapped = 25
         IF MapCurX < 1 THEN MapCurXCapped = 1
         IF MapCurX > 65 THEN MapCurXCapped = 65
         Prt MapPosY, MapPosX + 2, 0, 3, " wiersz:   ", 0: Prt MapPosY, MapPosX + 10, 0, 3, STR$(MapCurYCapped), 0 '   'wspolrzedne kursora na mapie
         Prt MapPosY, MapPosX + 13, 0, 3, ", kolumna:    ", 0: Prt MapPosY, MapPosX + 23, 0, 3, STR$(MapCurXCapped), 0 '         -||-
         StatusBar "StatusBarReset" '                                                                                  'czysci pasek statusu
         MapElems '                                                                                         'przybornik
         TrackElectrChoose CharColor '                                                                     'wywolanie procedury wyboru typu toru: zelektryfikowany lub niezelektryfikowany
         Prt 1, 1, 0, 7, "  Plik  Warstwy  Instrukcja  Slownik                                            ", 0
         'zdarzenia myszy
         IF CurY = 1 AND CurX > 1 AND CurX < 8 THEN '             'kursor na przycisku
            Prt 1, 2, 7, 0, " Plik ", 0 '                         'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditMenuFile TempVar 'otwiera menu plik
         ELSE '                                                   'kursor poza przyciskiem
            Prt 1, 2, 0, 7, " Plik ", 0: Prt 1, 3, 4, 7, "P", 0 ' 'napis z czerwonym inicjalem
         END IF
         IF CurY = 1 AND CurX > 7 AND CurX < 17 THEN '                                  'kursor na napisie
            COLOR 7, 0: LOCATE 1, 8: PRINT " Warstwy " '                                'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: EditFullMenuLayer LayerNr: CLS , 0 '       'menu otwierane w edytorze w celu zmiany warstwy
         ELSE
            COLOR 0, 7: LOCATE 1, 8: PRINT " Warstwy ": COLOR 4: LOCATE 1, 9: PRINT "W" 'napis z czerwonym inicjalem
         END IF
         IF MapCurY >= MapPosY - 5 AND MapCurY <= MapPosY + MapHeight - 1 AND MapCurX >= MapPosX AND MapCurX <= MapPosX + MapWidth - 1 AND _MOUSEBUTTON(1) AND Char$ <> "" THEN 'klikniecie w ramce mapy
            Unclick
            '1. WPISYWANIE DO TABELI
            IF Char$ <> "*" THEN '                                                                                                'znak nie jest *
               IF MapTableRecCount = UBOUND(MapTable) THEN '                                                                      'jezeli do tabeli juz cos wpisano:
                  FOR DelRecNr = 1 TO UBOUND(MapTable) '                                                                                 'przeszukaj tabele
                     IF MapCurY = MapTable(DelRecNr).CharY AND MapCurX = MapTable(DelRecNr).CharX THEN EditFullMapTableDel DelRecNr: EXIT FOR 'jesli istnieje juz wpis o tych wspolrzednych to go usun
                  NEXT DelRecNr '                                                                                                        'koniec przeszukiwania tabeli pod katem wpisu o tych samych koordynatach
                  IF UBOUND(MapTable) = 0 THEN REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable '              'jesli po usunieciu dubla tabela zostanie pusta to zrob miejsce na 1. rekord
                  IF MapTable(1).CharY <> 0 OR UBOUND(MapTable) = 0 THEN '                                                        'pierwszy wiersz tabeli nie zawiera wpisu 0,0,0,0
                     REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable '                                        'powieksz tabele tworzac nowy, pusty rekord
                  ELSE '                                                                                                          'pierwszy wiersz tabeli zawiera wpis 0,0,0,0
                     MapRecNr = UBOUND(MapTable) '                                                                                   'pierwszy rekord zawiera zera wiec nadpisac go
                  END IF
               END IF
               MapRecNr = UBOUND(MapTable) '                                                                                         'przenosi miejsce wpisania nowego rekordu na koniec tabeli
               IF Char$ <> "" THEN '                                                                                              'zapobiega utworzeniu pustego rekordu
                  MapTable(MapRecNr).CharY = MapCurY: MapTable(MapRecNr).CharX = MapCurX '                                              'zapisuje do tabeli polozenie kursora na mapie
                  MapTable(MapRecNr).CharColor = CharColor
                  MapTable(MapRecNr).CharCode = ASC(Char$) '                                                                         'zapisuje do tabeli kod ASCII znaku
                  MapTableRecCount = MapTableRecCount + 1 '                                                                       'aktualizuje licznik rekordow
               END IF
               '2. USUWANIE Z TABELI
            ELSE 'znak jest *
               FOR DelRecNr = 1 TO UBOUND(MapTable) 'wyszkuje w tabeli rekord o podanych wspolrzednych
                  IF MapCurY = MapTable(DelRecNr).CharY AND MapCurX = MapTable(DelRecNr).CharX THEN
                     EditFullMapTableDel DelRecNr
                     COLOR , 0: LOCATE CurY, CurX: PRINT " "; 'czysci znak z podgladu mapy
                     EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                  END IF
               NEXT DelRecNr
            END IF
            '3. AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
            OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1
            FOR RecNr = 1 TO UBOUND(MapTable)
               WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode
            NEXT RecNr
            CLOSE #1
         END IF
         EditFullMapTableDisplay MapTableRecCount, MapPosY, MapPosX, MapWidth, MapHeight 'rysuje ponownie mape
         'OZNACZANIE ROZJAZDOW
         IF CurX > MapPosX AND CurX < MapPosX + MapWidth AND CurY > MapPosY AND CurY < MapPosY + MapHeight AND _MOUSEBUTTON(2) THEN '                'jesli kliknieto PPM w ramce mapy
            Unclick
            MapCurX = CurX + MapPosX - 2: MapCurY = CurY - MapPosY '                                                                                 'obliczanie pozycji kursora na mapie
            PosX = 15: PosY = 15 '                                                                                                                   'polozenie okna dialogowego rozjazdu
            DO '                                                                                                                                     'POCZATEK PETLI OKNA DIALOGOWEGO ROZJAZDU
               Key$ = UCASE$(INKEY$)
               DO: _LIMIT 500
                  CurCoord
                  FOR i = 1 TO UBOUND(MapTable) '                                                                                                          'dla kazdego elementu w tabeli
                     IF MapCurY = MapTable(i).CharY AND MapCurX = MapTable(i).CharX THEN '                                                                 'jesli wspolrzedne klikniecia odpowiadaja elementowi w tabeli
                        SwitchY = MapCurY: SwitchX = MapCurX '                                                                                             'wspolrzedne rozjazdu do zmiennych potrzebnych do zapisu w tabeli rozjazdow
                        FrameDraw PosY, PosX, 5, 37, 0, 3, CHR$(205), CHR$(196), CHR$(179) '                                                               'rysuj okno dialogowe rozjazdu
                        SwitchDialogOpen = 1 '                                                                                                             'otwarto okno rozjazdu, wiec jest potrzebny przybornik tylko z 8 znakami
                        StatusBar "StatusBarReset" '                                                                                                       'czysci pasek statusu
                        FOR j = 1 TO 3 '                                                                                                                   'dla kazdego wiersza okienka
                           COLOR , 0: LOCATE PosY + j, PosX + 1: PRINT SPC(3); '                                                                           'koloruj tlo dla schematu rozjazdu
                           COLOR , 3: LOCATE PosY + j, PosX + 4: PRINT SPC(34); '                                                                          'koloruj tlo dla przyciskow
                        NEXT j '
                        FOR j = 4 TO 5
                           LOCATE PosY + j, PosX + 1: PRINT SPC(37);
                        NEXT j
                        COLOR 4, 7: LOCATE PosY + 2, PosX + 2: PRINT CHR$(MapTable(i).CharCode) '                                                          'NARYSUJ ROZJAZD
                        'Char$ = CHR$(MapTable(i).CharCode) '                                                                                               'pobiera znak do wyswietlenia w okienku schematu rozjazdu
                        FOR SwitchRecNr = 1 TO UBOUND(SwitchTable) '                                                                                       'przeszukaj tabele rozjazdow
                           IF SwitchTable(SwitchRecNr).SwitchY = SwitchY AND SwitchTable(SwitchRecNr).SwitchX = SwitchX THEN '                             'jesli dla wspolrzednych klikniecia istnieje w tabeli rozjazd
                              'ODCZYTAC Z TABELI ROZJAZDOW WARTOSCI I WPROWADZIC JE DO ZMIENNYCH                                                           'edytowac go w okienku rozjazdu
                              SwitchNr$ = SwitchTable(SwitchRecNr).SwitchNr$ '                                                                             'numer rozjazdu
                              SwitchDirCount = SwitchTable(SwitchRecNr).SwitchDirCount '                                                                   'liczba polozen rozjazdu
                              SwitchChar1 = SwitchTable(SwitchRecNr).SwitchChar1 '                                                                         'kod ASCII znaku rozjazdu w 1. polozeniu
                              SwitchDir1$ = SwitchTable(SwitchRecNr).SwitchDir1$ '                                                                         'ciag dwoch cyfr okreslajacy 1. polozenie rozjazdu
                              SwitchDirA$ = SwitchTable(SwitchRecNr).SwitchDirA$ '                                                                         'oznaczenie polozenia rozjazdu z uzyciem znakow abcd-+
                              SwitchChar2 = SwitchTable(SwitchRecNr).SwitchChar2
                              SwitchDir2$ = SwitchTable(SwitchRecNr).SwitchDir2$
                              SwitchDirB$ = SwitchTable(SwitchRecNr).SwitchDirB$
                              SwitchChar3 = SwitchTable(SwitchRecNr).SwitchChar3
                              SwitchDir3$ = SwitchTable(SwitchRecNr).SwitchDir3$
                              SwitchDirC$ = SwitchTable(SwitchRecNr).SwitchDirC$
                              SwitchChar4 = SwitchTable(SwitchRecNr).SwitchChar4
                              SwitchDir4$ = SwitchTable(SwitchRecNr).SwitchDir4$
                              SwitchDirD$ = SwitchTable(SwitchRecNr).SwitchDirD$
                              DO: _LIMIT 500
                                 FOR k = 1 TO UBOUND(MapTable) '                                                           'przeszukuje tabele mapy
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = 1 THEN '          'do elementu o zadanej roznicy wspolrzednych
                                       DiffY = 1: DiffX = 1: SwitchDirNr$ = "1" '                                          'przypisuje roznice i odpowiednia cyfre
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$ 'zwraca wartosci zmiennych SwitchDir[1ö4]$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = 0 THEN
                                       DiffY = 1: DiffX = 0: SwitchDirNr$ = "2"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = 1: DiffX = -1: SwitchDirNr$ = "3"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 0 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = 0: DiffX = -1: SwitchDirNr$ = "4"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = -1: DiffX = -1: SwitchDirNr$ = "5"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = 0 THEN
                                       DiffY = -1: DiffX = 0: SwitchDirNr$ = "6"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = 1 THEN
                                       DiffY = -1: DiffX = 1: SwitchDirNr$ = "7"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 0 AND SwitchX - MapTable(k).CharX = 1 THEN
                                       DiffY = 0: DiffX = 1: SwitchDirNr$ = "8"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                 NEXT k
                                 SwitchCharBuild PosY, PosX '                                                        'przypisanie znaku ASCII do kazdego polozenia
                                 SwitchNrField PosY, PosX, SwitchNr$ '                                                        'pole tekstowe do wpisania numeru rozjazdu
                                 SwitchTypeChoose PosY, PosX '                                                  'przycisk wyboru typu rozjazdu
                                 SwitchDirNrChoose PosY, PosX, SwitchDirCount '                                 'przycisk wyboru numeru 1ö4 polozenia rozjazdu do opisu
                                 SwitchDirDesc PosY, PosX '                                                      'pole tekstowe do opisu polozenia rozjaxdu abcd-+
                                 'ZAPISYWANIE PARAMETROW ROZJAZDU DO TABELI
                                 SwitchRecNr = UBOUND(SwitchTable)
                                 SwitchTableFill SwitchRecNr, SwitchY, SwitchX, SwitchNr$, SwitchDirCount, SwitchChar1, SwitchDir1$, SwitchDirA$, SwitchChar2, SwitchDir2$, SwitchDirB$, SwitchChar3, SwitchDir3$, SwitchDirC$, SwitchChar4, SwitchDir4$, SwitchDirD$
                                 'AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
                                 OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa_rozjazdy.txt" FOR OUTPUT AS #1
                                 FOR SwitchRecNr = 1 TO UBOUND(SwitchTable)
                                    WRITE #1, SwitchTable(SwitchRecNr).SwitchY, SwitchTable(SwitchRecNr).SwitchX, SwitchTable(SwitchRecNr).SwitchNr$, SwitchTable(SwitchRecNr).SwitchDirCount, SwitchTable(SwitchRecNr).SwitchChar1, SwitchTable(SwitchRecNr).SwitchDir1$, SwitchTable(SwitchRecNr).SwitchDirA$, SwitchTable(SwitchRecNr).SwitchChar2, SwitchTable(SwitchRecNr).SwitchDir2$, SwitchTable(SwitchRecNr).SwitchDirB$, SwitchTable(SwitchRecNr).SwitchChar3, SwitchTable(SwitchRecNr).SwitchDir3$, SwitchTable(SwitchRecNr).SwitchDirC$, SwitchTable(SwitchRecNr).SwitchChar4, SwitchTable(SwitchRecNr).SwitchDir4$, SwitchTable(SwitchRecNr).SwitchDirD$
                                 NEXT SwitchRecNr
                                 CLOSE #1
                                 'PRZYCISKI "ZAPISZ", "ODRZUC" I "USUN"
                                 Button PosY + 5, PosX + 4, 1, 8, 8, 7, 0, 7, 7, 0, 4, 7, " Zapisz", "Zapisuje podane informacje o rozjezdzie i zamyka okno.", 0 'zapisuje do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN
                                    IF SwitchTableRecCount > 0 THEN '                                                                     'wykluczenie mozliwosci zapisu pustej tabeli
                                       SaveSwitchMain '                                                                                   'zapis danych rozjazdu do glownego pliku
                                       EXIT DO
                                    ELSE
                                       StatusBar "Brak danych do zapisu."
                                    END IF
                                 END IF
                                 Button PosY + 5, PosX + 16, 1, 8, 8, 7, 0, 7, 7, 0, 4, 7, " Odrzuc", "Nie zapisuje podanych informacji o rozjezdzie i zamyka okno.", 0 'nie zapisuje do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN EXIT DO
                                 Button PosY + 5, PosX + 30, 1, 6, 8, 7, 0, 7, 7, 0, 4, 7, " Usun", "Usuwa rozjazd z mapy i pliku zapisu.", 0 'usuniecie rekordu z tabeli i zapisanie jej do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN
                                    FOR RecNr = 1 TO UBOUND(SwitchTable) '                                                                'przeszukuje tabele
                                       IF SwitchTable(RecNr).SwitchY = SwitchY AND SwitchTable(RecNr).SwitchX = SwitchX THEN '            'wspolrzedne rozjazdu pokrywaja sie
                                          EditFullSwitchTableDel RecNr '                                                                  'usuwa rekord
                                          EXIT FOR '                                                                                      'przerywa wyszukiwanie
                                       END IF
                                    NEXT RecNr
                                    SaveSwitchMain '                                                                                      'zapis danych rozjazdu do glownego pliku
                                    EXIT DO
                                 END IF
                                 _DISPLAY
                              LOOP WHILE _MOUSEINPUT
                           ELSE '             TWORZENIE NOWEGO ROZJAZDU                                                                   'nie istnieje element o tych wspolrzednych
                              'REDIM _PRESERVE SwitchTable(1 TO UBOUND(SwitchTable) + 1) AS TypeSwitchTable '                              'powieksz tabele tworzac nowy, pusty rekord
                              SwitchRecNr = UBOUND(SwitchTable) '                                                                         'nowy rekord
                              DO: _LIMIT 500
                                 'ELEMENTY DO EDYCJI: USTAWIANIE ZMIENNYCH
                                 FOR k = 1 TO UBOUND(MapTable) '                                                                          'przeszukuje tabele mapy
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = 1 THEN '                     'do elementu o zadanej roznicy wspolrzednych
                                       DiffY = 1: DiffX = 1: SwitchDirNr$ = "1" '                                                    'przypisuje roznice i odpowiednia cyfre
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$ ' 'zwraca wartosci zmiennych SwitchDir[1ö4]$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = 0 THEN
                                       DiffY = 1: DiffX = 0: SwitchDirNr$ = "2"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 1 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = 1: DiffX = -1: SwitchDirNr$ = "3"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 0 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = 0: DiffX = -1: SwitchDirNr$ = "4"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = -1 THEN
                                       DiffY = -1: DiffX = -1: SwitchDirNr$ = "5"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = 0 THEN
                                       DiffY = -1: DiffX = 0: SwitchDirNr$ = "6"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = -1 AND SwitchX - MapTable(k).CharX = 1 THEN
                                       DiffY = -1: DiffX = 1: SwitchDirNr$ = "7"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                    IF SwitchY - MapTable(k).CharY = 0 AND SwitchX - MapTable(k).CharX = 1 THEN
                                       DiffY = 0: DiffX = 1: SwitchDirNr$ = "8"
                                       SwitchDirNumSet PosY, PosX, k, DiffY, DiffX, SwitchDirNr$
                                    END IF
                                 NEXT k
                                 SwitchCharBuild PosY, PosX '                  przypisanie znaku ASCII do kazdego polozenia
                                 SwitchNrField PosY, PosX, SwitchNr$ '         pole tekstowe do wpisania numeru rozjazdu
                                 SwitchTypeChoose PosY, PosX '                 przycisk wyboru typu rozjazdu
                                 SwitchDirNrChoose PosY, PosX, SwitchDirCount 'przycisk wyboru numeru 1ö4 polozenia rozjazdu do opisu
                                 SwitchDirDesc PosY, PosX '                    pole tekstowe do opisu polozenia rozjazdu abcd-+
                                 'AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
                                 SwitchRecNr = UBOUND(SwitchTable)
                                 SwitchTableFill SwitchRecNr, SwitchY, SwitchX, SwitchNr$, SwitchDirCount, SwitchChar1, SwitchDir1$, SwitchDirA$, SwitchChar2, SwitchDir2$, SwitchDirB$, SwitchChar3, SwitchDir3$, SwitchDirC$, SwitchChar4, SwitchDir4$, SwitchDirD$
                                 OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa_rozjazdy.txt" FOR OUTPUT AS #1
                                 FOR SwitchRecNr = 1 TO UBOUND(SwitchTable)
                                    WRITE #1, SwitchTable(SwitchRecNr).SwitchY, SwitchTable(SwitchRecNr).SwitchX, SwitchTable(SwitchRecNr).SwitchNr$, SwitchTable(SwitchRecNr).SwitchDirCount, SwitchTable(SwitchRecNr).SwitchChar1, SwitchTable(SwitchRecNr).SwitchDir1$, SwitchTable(SwitchRecNr).SwitchDirA$, SwitchTable(SwitchRecNr).SwitchChar2, SwitchTable(SwitchRecNr).SwitchDir2$, SwitchTable(SwitchRecNr).SwitchDirB$, SwitchTable(SwitchRecNr).SwitchChar3, SwitchTable(SwitchRecNr).SwitchDir3$, SwitchTable(SwitchRecNr).SwitchDirC$, SwitchTable(SwitchRecNr).SwitchChar4, SwitchTable(SwitchRecNr).SwitchDir4$, SwitchTable(SwitchRecNr).SwitchDirD$
                                 NEXT SwitchRecNr
                                 CLOSE #1
                                 'PRZYCISKI "ZAPISZ", "ODRZUC" I "USUN"
                                 Button PosY + 5, PosX + 4, 1, 8, 8, 7, 0, 7, 7, 0, 4, 7, " Zapisz", "Zapisuje podane informacje o rozjezdzie i zamyka okno.", 0 'zapisuje do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN
                                    IF SwitchTableRecCount > 0 THEN '                                                                     'wykluczenie mozliwosci zapisu pustej tabeli
                                       SaveSwitchMain '                                                                                   'zapis danych rozjazdu do glownego pliku
                                       EXIT DO
                                    ELSE
                                       StatusBar "Brak danych do zapisu."
                                    END IF
                                 END IF
                                 Button PosY + 5, PosX + 16, 1, 8, 8, 7, 0, 7, 7, 0, 4, 7, " Odrzuc", "Nie zapisuje podanych informacji o rozjezdzie i zamyka okno.", 0 'nie zapisuje do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN EXIT DO
                                 Button PosY + 5, PosX + 30, 1, 6, 8, 7, 0, 7, 7, 0, 4, 7, " Usun", "Usuwa rozjazd z mapy i pliku zapisu.", 0 'usuniecie rekordu z tabeli i zapisanie jej do pliku glownego
                                 IF BtnStat$ = "BtnAct" THEN
                                    FOR RecNr = 1 TO UBOUND(SwitchTable) '                                                                'przeszukuje tabele
                                       IF SwitchTable(RecNr).SwitchY = SwitchY AND SwitchTable(RecNr).SwitchX = SwitchX THEN '            'wspolrzedne rozjazdu pokrywaja sie
                                          EditFullSwitchTableDel RecNr '                                                                  'usuwa rekord
                                          EXIT FOR '                                                                                      'przerywa wyszukiwanie
                                       END IF
                                    NEXT RecNr
                                    SaveSwitchMain '                                                                                      'zapis danych rozjazdu do glownego pliku
                                    EXIT DO
                                 END IF
                                 _DISPLAY
                              LOOP WHILE _MOUSEINPUT
                           END IF
                        NEXT SwitchRecNr
                     END IF
                  NEXT i
               LOOP WHILE _MOUSEINPUT '                                                                                    'koniec zdarzen myszy
               _DISPLAY
            LOOP '                                                                                                         'KONIEC PETLI OKNA DIALOGOWEGO ROZJAZDU
         END IF
         SwitchDialogOpen = 0 '                                                                                            'zmienna przyjmuje informacje, ze zamknieto okno dialogowe rozjazdu
         EditFullMapMove MapPosX, MapPosY, MapHeight, MapWidth 'przesuwanie mapy
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "P" THEN EditMenuFile TempVar 'procedura menu zwraca zmienna TempVar
      IF TempVar = 1 THEN CLS , 1: EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna TempVar, ktora wychodzi z TEJ petli
      IF Key$ = "W" THEN EditFullMenuLayer LayerNr
      _DISPLAY
   LOOP
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
   FrameLineCount = 5: TxtLength = 22 'liczba pozycji menu, dlugosc pozycji menu ze spacjami
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, FrameLineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 8, 0: LOCATE PosY - 1, PosX + 1: PRINT " Warstwy " 'odwroc kolory w nazwie otwartego menu
   DO 'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord
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
            IF _MOUSEBUTTON(1) THEN Unclick 'procedura oznaczania parametrow torow
         ELSE
            COLOR 0, 7: LOCATE PosY + 2, PosX + 1: PRINT " Oznaczanie torow     " 'napis zwykly
            COLOR 4: LOCATE PosY + 2, PosX + 2: PRINT "O" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 5 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 3, PosX + 1: PRINT " Urzadzenia i sygnaly " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick 'procedura oznaczania urzadzen i sygnalow
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
         IF (CurX < PosX OR CurX > PosX + TxtLength + 1 OR CurY < PosY OR CurY > PosY + FrameLineCount + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klik poza menu
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
'====================================================================================================='
'                              EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY                             '
'====================================================================================================='
SUB EditFullMapMove (MapPosX, MapPosY, MapHeight, MapWidth)
   COLOR 7, 1: LOCATE 14, 70: PRINT "przesuwanie";
   COLOR 7, 1: LOCATE 15, 71: PRINT "mapy";
   IF CurX = 71 AND CurY = 16 THEN ' . . . . . . . . . . . . LEFT. . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 71: PRINT CHR$(17); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveLeft MapPosX, MapPosY, MapHeight, MapWidth '                         'wywolaj procedure przesuwania mapy
         ELSE COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                               'pasek powiadomien
         END IF
      END IF
   ELSE COLOR 7, 1: LOCATE 16, 71: PRINT CHR$(17); '                                                     'kursor poza przyciskiem - strzalka zwykla
   END IF
   IF CurX = 73 AND CurY = 16 THEN ' . . . . . . . . . . . . RIGHT . . . . . . . . . . . . . . . . . . . 'kursor na strzalce
      COLOR 0, 3: LOCATE 16, 73: PRINT CHR$(16); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveRight MapPosX, MapPosY, MapHeight, MapWidth '                        'wywolaj procedure przesuwania mapy
         ELSE COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                               'pasek powiadomien
         END IF
      END IF
   ELSE COLOR 7, 1: LOCATE 16, 73: PRINT CHR$(16); '                                                     'kursor poza przyciskiem - strzalka zwykla
   END IF
   IF CurX = 75 AND CurY = 16 THEN ' . . . . . . . . . . . . UP. . . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 75: PRINT CHR$(30); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveUp MapPosX, MapPosY, MapHeight, MapWidth '                           'wywolaj procedure przesuwania mapy
         ELSE COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                               'pasek powiadomien
         END IF
      END IF
   ELSE COLOR 7, 1: LOCATE 16, 75: PRINT CHR$(30); '                                                     'kursor poza przyciskiem - strzalka zwykla
   END IF
   IF CurX = 77 AND CurY = 16 THEN ' . . . . . . . . . . . . DOWN. . . . . . . . . . . . . . . . . . . . 'kursor nad przyciskiem
      COLOR 0, 3: LOCATE 16, 77: PRINT CHR$(31); '                                                       'strzalka w negatywie
      IF _MOUSEBUTTON(1) THEN
         IF UBOUND(MapTable) > 0 THEN '                                                                  'jesli tabela nie jest pusta
            Unclick: EditFullMapMoveDown MapPosX, MapPosY, MapHeight, MapWidth '                         'wywolaj procedure przesuwania mapy
         ELSE COLOR 7, 14: LOCATE 25, 30: PRINT "nie ma czego przesuwac" '                               'pasek powiadomien
         END IF
      END IF
   ELSE COLOR 7, 1: LOCATE 16, 77: PRINT CHR$(31); '                                                     'kursor poza przyciskiem - strzalka zwykla
   END IF
END SUB
'====================================================================================================='
'                         EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W LEWO                           '
'====================================================================================================='
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
'====================================================================================================='
'                        EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W PRAWO                           '
'====================================================================================================='
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
'====================================================================================================='
'                         EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W GORE                           '
'====================================================================================================='
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
'====================================================================================================='
'                            EDYTOR MAP - TRYB PELNY - PRZESUWANIE MAPY W DOL                         '
'====================================================================================================='
SUB EditFullMapMoveDown (MapPosX, MapPosY, MapHeight, MapWidth)
   FOR i = 1 TO UBOUND(MapTable) '                                                                            'bierze po jednym rekordzie
      IF MapTable(i).CharX > MapPosX AND MapTable(i).CharX < MapPosX + MapWidth AND MapTable(i).CharY > MapPosY AND MapTable(i).CharY < MapPosY + MapHeight THEN 'uniemozliwia nadpisanie znaku poza ramka mapy
         COLOR , 1: LOCATE MapTable(i).CharY + MapPosY, MapTable(i).CharX + MapPosX: PRINT " " '                      'nadpisuje stary znak na mapie, +2 i +1 to offset mapy wzgledem okna
      END IF
      MapTable(i).CharY = MapTable(i).CharY + 1 '                                                         'zmienia wspolrzedna w tym rekordzie
   NEXT i
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1 '                               'zapisz tabele do pliku tymczasowego
   FOR i = 1 TO UBOUND(MapTable)
      WRITE #1, MapTable(i).CharY, MapTable(i).CharX, MapTable(i).CharColor, MapTable(i).CharCode 'wypisuje znak na nowej pozycji
   NEXT i
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
SUB EditFullMapTableDisplay (MapTableRecCount, MapPosY, MapPosX, MapWidth, MapHeight)
   IF MapTableRecCount > 0 THEN 'tylko jesli cokolwiek wpisano do tabeli
      FOR i = 1 TO UBOUND(MapTable) 'wyswietl kazdy znak ktory miesci sie w ramce mapy
         IF MapTable(i).CharX > MapPosX - 1 AND MapTable(i).CharX < MapPosX + MapWidth AND MapTable(i).CharY > MapPosY - 6 AND MapTable(i).CharY < MapPosY + MapHeight - 1 THEN
            Prt MapTable(i).CharY + MapPosY, MapTable(i).CharX + MapPosX, MapTable(i).CharColor, 0, CHR$(MapTable(i).CharCode), 0
         END IF
      NEXT i
   END IF
END SUB
'====================================================================================================='
'                   EDYTOR MAP - TRYB PELNY - OKNO DIALOGOWE ROZJAZDU - WYBOR POLOZEN                 '
' Wyswietla schemat rozjazdu w oknie dialogowym na potrzeby oznaczania polozen za pomoca              '
' dwucyfrowego ciagu.                                                                                 '
'====================================================================================================='
SUB SwitchDirNumSet (PosY, PosX, k, DiffY, DiffX, SwitchDirNr$)
   SELECT CASE SwitchDirNum '                                                                    zaleznie od wybranego numeru polozenia 1ö4
      CASE 1: SwitchDirX$ = SwitchDir1$ '                                                        laduje zmienna z tabeli do zmiennej roboczej
      CASE 2: SwitchDirX$ = SwitchDir2$
      CASE 3: SwitchDirX$ = SwitchDir3$
      CASE 4: SwitchDirX$ = SwitchDir4$
   END SELECT
   IF CurY = PosY + 2 - DiffY AND CurX = PosX + 2 - DiffX THEN '. . . . . . . . . . . . . . . . . . wskazano element
      Prt PosY + 2 - DiffY, PosX + 2 - DiffX, 0, 7, CHR$(MapTable(k).CharCode), 0 '                 wyswietla go w negatywie
      IF LEN(SwitchDirX$) < 2 AND INSTR(1, SwitchDirX$, SwitchDirNr$) = 0 AND _MOUSEBUTTON(1) THEN 'jesli jest miejsce na dopisanie, brak w ciagu tej cyfry i kliknieto
         Unclick '                                                                                  czysci bufor myszy
         SwitchDirX$ = SwitchDirX$ + SwitchDirNr$ '                                                 to ja dopisuje
         Prt PosY + 2 - DiffY, PosX + 2 - DiffX, 4, 7, CHR$(MapTable(k).CharCode), 0 '              oraz zmienia kolor elementu
      END IF
      IF INSTR(1, SwitchDirX$, SwitchDirNrX$) <> 0 AND _MOUSEBUTTON(1) THEN ' . . . . . . . . . . . jesli kliknieto i ta cyfra juz byla
         Unclick '                                                                                  czysci bufor myszy
         IF LEN(SwitchDirX$) = 1 THEN '                                                             a ciag zawiera tylko te jedna cyfre
            SwitchDirX$ = "" '                                                                      czysci ciag
         END IF
         IF LEN(SwitchDirX$) = 2 THEN '                                                             jesli ciag zawiera dwie cyfry
            SwitchDirKeep = 3 - INSTR(1, SwitchDirX$, SwitchDirNr$) '                               wyszukaj SwitchDirNr$ i okresl pozycje do zachowania
            SwitchDirX$ = MID$(SwitchDirX$, SwitchDirKeep, SwitchDirKeep) '                         skroc ciag zachowujac wyznaczona pozycje
         END IF
      END IF
      SELECT CASE SwitchDirNum '                                                                    zaleznie od wybranego numeru polozenia 1ö4
         CASE 1: SwitchDir1$ = SwitchDirX$ '                                                        wstawia ciag do zmiennej potrzebnej do zapisu tabeli
         CASE 2: SwitchDir2$ = SwitchDirX$
         CASE 3: SwitchDir3$ = SwitchDirX$
         CASE 4: SwitchDir4$ = SwitchDirX$
      END SELECT
      Prt PosY + 2 - DiffY, PosX + 2 - DiffX, 0, 7, CHR$(MapTable(k).CharCode), 0 '                 dezaktywuje znak, wyswietla go w negatywie
   ELSE ' . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . kursor poza elementem
      IF INSTR(1, SwitchDirX$, SwitchDirNr$) <> 0 THEN '                                            element znajduje sie w ciagu
         Prt PosY + 2 - DiffY, PosX + 2 - DiffX, 4, 0, CHR$(MapTable(k).CharCode), 0 '              zmienia jego kolor
      ELSE '                                                                                        elementu nie ma w ciagu
         Prt PosY + 2 - DiffY, PosX + 2 - DiffX, 7, 0, CHR$(MapTable(k).CharCode), 0 '              zwykle wyswietlanie
      END IF
   END IF
END SUB
'====================================================================================================='
'                       EDYTOR MAP - TRYB PELNY - WYSWIETLANIE ROZJAZDU Z TABELI                      '
'====================================================================================================='
'SUB EditFullSwitchTableDisplay (SwitchTableRecCount)
'     IF SwitchTableRecCount > 0 THEN 'tylko jesli cokolwiek wpisano do tabeli
'         FOR i = 1 TO UBOUND(SwitchTable)
'         next i
'     end if
'END SUB
'====================================================================================================='
'                          EDYTOR MAP - TRYB PELNY - USUWANIE Z TABELI MAPY                           '
'====================================================================================================='
SUB EditFullMapTableDel (DelRecNr) 'aby usunac rekord, nalezy przepisac ostatni wpis w tabeli na miejsce danego
   MapTable(DelRecNr).CharY = MapTable(UBOUND(MapTable)).CharY
   MapTable(DelRecNr).CharX = MapTable(UBOUND(MapTable)).CharX
   MapTable(DelRecNr).CharColor = MapTable(UBOUND(MapTable)).CharColor
   MapTable(DelRecNr).CharCode = MapTable(UBOUND(MapTable)).CharCode
   REDIM _PRESERVE MapTable(UBOUND(MapTable) - 1) AS TypeMapTable 'ostatni wpis jest teraz dublem wiec obcina sie tabele o ten rekord; _PRESERVE zeby REDIM nie czyscil rekordow przy zmianie wielkosci tabeli
   MapTableRecCount = MapTableRecCount - 1 'aktualizuj licznik rekordow
END SUB
'====================================================================================================='
'                    EDYTOR MAP - TRYB PELNY - ZAPIS PARAMETROW ROZJAZDU DO TABELI                    '
' Automatycznie zapisuje parametry rozjazdu podane w oknie dialogowym do tabeli w pamieci programu.   '
'====================================================================================================='
SUB SwitchTableFill (SwitchRecNr, SwitchY, SwitchX, SwitchNr$, SwitchDirCount, SwitchChar1, SwitchDir1$, SwitchDirA$, SwitchChar2, SwitchDir2$, SwitchDirB$, SwitchChar3, SwitchDir3$, SwitchDirC$, SwitchChar4, SwitchDir4$, SwitchDirD$)
   SwitchTable(SwitchRecNr).SwitchY = SwitchY '                                                             'wspolrzedne rozjazdu
   SwitchTable(SwitchRecNr).SwitchX = SwitchX
   SwitchTable(SwitchRecNr).SwitchNr$ = SwitchNr$ '                                                         'numer rozjazdu
   SwitchTable(SwitchRecNr).SwitchDirCount = SwitchDirCount '                                               'liczba polozen rozjazdu
   SwitchTable(SwitchRecNr).SwitchChar1 = SwitchChar1 '                                                     'kod ASCII znaku rozjazdu w 1. polozeniu
   SwitchTable(SwitchRecNr).SwitchDir1$ = SwitchDir1$ '                                                     'ciag dwoch cyfr okreslajacy 1. polozenie rozjazdu
   SwitchTable(SwitchRecNr).SwitchDirA$ = SwitchDirA$ '                                                     'oznaczenie 1. polozenia rozjazdu z uzyciem znakow abcd-+
   SwitchTable(SwitchRecNr).SwitchChar2 = SwitchChar2
   SwitchTable(SwitchRecNr).SwitchDir2$ = SwitchDir2$
   SwitchTable(SwitchRecNr).SwitchDirB$ = SwitchDirB$
   SwitchTable(SwitchRecNr).SwitchChar3 = SwitchChar3
   SwitchTable(SwitchRecNr).SwitchDir3$ = SwitchDir3$
   SwitchTable(SwitchRecNr).SwitchDirC$ = SwitchDirC$
   SwitchTable(SwitchRecNr).SwitchChar4 = SwitchChar4
   SwitchTable(SwitchRecNr).SwitchDir4$ = SwitchDir4$
   SwitchTable(SwitchRecNr).SwitchDirD$ = SwitchDirD$
   SwitchTableRecCount = SwitchTableRecCount + 1 '
END SUB
'====================================================================================================='
'                       EDYTOR MAP - TRYB PELNY - USUWANIE Z TABELI ROZJAZDOW                         '
'====================================================================================================='
SUB EditFullSwitchTableDel (RecNr)
   SwitchTable(RecNr).SwitchY = SwitchTable(UBOUND(SwitchTable)).SwitchY
   SwitchTable(RecNr).SwitchX = SwitchTable(UBOUND(SwitchTable)).SwitchX
   SwitchTable(RecNr).SwitchNr$ = SwitchTable(UBOUND(SwitchTable)).SwitchNr$
   SwitchTable(RecNr).SwitchDirCount = SwitchTable(UBOUND(SwitchTable)).SwitchDirCount
   SwitchTable(RecNr).SwitchChar1 = SwitchTable(UBOUND(SwitchTable)).SwitchChar1
   SwitchTable(RecNr).SwitchDir1$ = SwitchTable(UBOUND(SwitchTable)).SwitchDir1$
   SwitchTable(RecNr).SwitchDirA$ = SwitchTable(UBOUND(SwitchTable)).SwitchDirA$
   SwitchTable(RecNr).SwitchChar2 = SwitchTable(UBOUND(SwitchTable)).SwitchChar2
   SwitchTable(RecNr).SwitchDir2$ = SwitchTable(UBOUND(SwitchTable)).SwitchDir2$
   SwitchTable(RecNr).SwitchDirB$ = SwitchTable(UBOUND(SwitchTable)).SwitchDirB$
   SwitchTable(RecNr).SwitchChar3 = SwitchTable(UBOUND(SwitchTable)).SwitchChar3
   SwitchTable(RecNr).SwitchDir3$ = SwitchTable(UBOUND(SwitchTable)).SwitchDir3$
   SwitchTable(RecNr).SwitchDirC$ = SwitchTable(UBOUND(SwitchTable)).SwitchDirC$
   SwitchTable(RecNr).SwitchChar4 = SwitchTable(UBOUND(SwitchTable)).SwitchChar4
   SwitchTable(RecNr).SwitchDir4$ = SwitchTable(UBOUND(SwitchTable)).SwitchDir4$
   SwitchTable(RecNr).SwitchDirD$ = SwitchTable(UBOUND(SwitchTable)).SwitchDirD$
   REDIM _PRESERVE SwitchTable(UBOUND(SwitchTable) - 1) AS TypeSwitchTable
   SwitchTableRecCount = SwitchTableRecCount - 1
END SUB
'=============================================================================='
'                     EDYTOR MAP - OBA TRYBY - MENU PLIK                       '
'=============================================================================='
SUB EditMenuFile (TempVar)
   TempVar = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
   PosX = 1: PosY = 2
   FrameLineCount = 4: TxtLength = 11
   FrameCharColor = 0: FrameBackColor = 7
   FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
   FrameDraw PosY, PosX, FrameLineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
   COLOR 8, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
   DO 'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         CurCoord
         'opcje menu i podswietlanie wskazanej
         IF CurY = 3 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 3, 2: PRINT " Nowa mapa " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: edytor_dialog_nowa_mapa: EXIT SUB 'okienko dialogowe do rozpoczynania nowej, czystej mapy
         ELSE
            COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa mapa " 'napis zwykly
            COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
         END IF
         IF CurY = 4 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 4, 2: PRINT " Wczytaj   " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN
               Unclick
               edytor_dialog_wczytaj
               EXIT SUB 'okienko wczytywania mapy z pliku
            END IF
         ELSE
            COLOR 0, 7: LOCATE 4, 2: PRINT " Wczytaj   " 'napis zwykly
            COLOR 4: LOCATE 4, 3: PRINT "W" 'czerwona litera
         END IF
         IF CurY = 5 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 5, 2: PRINT " Zapisz    " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN Unclick: edytor_dialog_zapisz: EXIT SUB 'okienko zapisu mapy do pliku mapa.txt
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
         IF (CurX > PosX + TxtLength + 3 OR CurY = 1 OR CurY > PosY + FrameLineCount + 1) AND _MOUSEBUTTON(1) THEN Unclick: CLS , 0: EXIT SUB 'klikniecie poza menu
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "N" THEN edytor_dialog_nowa_mapa: EXIT SUB 'okienko rozpoczynania nowej, czystej mapy
      IF Key$ = "W" THEN edytor_dialog_wczytaj: EXIT SUB
      IF Key$ = "Z" THEN edytor_dialog_zapisz: EXIT SUB
      IF Key$ = "K" THEN TempVar = 1: EXIT SUB 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
      IF Key$ = CHR$(27) THEN CLS , 0: EXIT SUB 'Esc
      _DISPLAY
   LOOP
END SUB

SUB edytor_dialog_nowa_mapa 'okienko dialogowe do rozpoczynania nowej, czystej mapy
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: FrameLineCount = 4: TxtLength = 22
         FrameDraw PosY, PosX, FrameLineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Nowa mapa "
         LOCATE PosY + 1, PosX + 1: PRINT " Dotychczasowy postep ";
         LOCATE PosY + 2, PosX + 1: PRINT " zostanie utracony.   ";
         LOCATE PosY + 3, PosX + 1: PRINT "      Na pewno?       ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak            Nie  ";
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T";
         LOCATE PosY + 4, PosX + 18: PRINT "N";
         CurCoord
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
SUB edytor_dialog_wczytaj
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: FrameLineCount = 4: TxtLength = 22
         FrameDraw PosY, PosX, FrameLineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Wczytaj "
         LOCATE PosY + 1, PosX + 1: PRINT " Dotychczasowy postep ";
         LOCATE PosY + 2, PosX + 1: PRINT " zostanie utracony.   ";
         LOCATE PosY + 3, PosX + 1: PRINT "      Na pewno?       ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak            Nie  ";
         _DISPLAY
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T";
         _DISPLAY
         LOCATE PosY + 4, PosX + 18: PRINT "N";
         _DISPLAY
         CurCoord
         'zdarzenia myszy
         IF CurY = PosY + 4 AND CurX > PosX + 1 AND CurX < PosX + 7 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 2: PRINT " Tak "; 'napis w negatywie
            _DISPLAY
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
            _DISPLAY
            IF _MOUSEBUTTON(1) THEN Unclick: EXIT SUB
         END IF
         IF (CurY < PosY OR CurY > PosY + FrameLineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klikniecie poza ramka
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
SUB edytor_dialog_zapisz
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         PosY = 10: PosX = 25: FrameLineCount = 4: TxtLength = 20
         FrameDraw PosY, PosX, FrameLineCount, TxtLength, 0, 3, CHR$(205), CHR$(196), CHR$(179)
         COLOR 0, 3
         LOCATE PosY, PosX + 2: PRINT " Zapisz "
         LOCATE PosY + 1, PosX + 1: PRINT " Zostanie nadpisany ";
         LOCATE PosY + 2, PosX + 1: PRINT " plik mapa.txt.     ";
         LOCATE PosY + 3, PosX + 1: PRINT "     Na pewno?      ";
         LOCATE PosY + 4, PosX + 1: PRINT "  Tak          Nie  ";
         COLOR 4, 3: 'czerwone litery
         LOCATE PosY + 4, PosX + 3: PRINT "T": LOCATE PosY + 4, PosX + 16: PRINT "N";
         CurCoord
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
         IF (CurY < PosY OR CurY > PosY + FrameLineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) THEN Unclick: EXIT SUB 'klikniecie poza ramka
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
'====================================================================================================='
'                 EDYTOR - TRYB PELNY - ZAPIS TABELI ROZJAZDOW DO PLIKU GLOWNEGO                      '
'====================================================================================================='
SUB SaveSwitchMain
   OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\rozjazdy.txt" FOR OUTPUT AS #1
   FOR i = 1 TO UBOUND(SwitchTable)
      WRITE #1, SwitchTable(i).SwitchY, SwitchTable(i).SwitchX, SwitchTable(i).SwitchNr$, SwitchTable(i).SwitchDirCount, SwitchTable(i).SwitchChar1, SwitchTable(i).SwitchDir1$, SwitchTable(i).SwitchDirA$, SwitchTable(i).SwitchChar2, SwitchTable(i).SwitchDir2$, SwitchTable(i).SwitchDirB$, SwitchTable(i).SwitchChar3, SwitchTable(i).SwitchDir3$, SwitchTable(i).SwitchDirC$, SwitchTable(i).SwitchChar4, SwitchTable(i).SwitchDir4$, SwitchTable(i).SwitchDirD$
   NEXT i
   CLOSE #1
END SUB
'$include: 'procedury.bi'
