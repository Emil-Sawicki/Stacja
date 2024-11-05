_CONTROLCHR OFF 'umozliwia wypisywanie na ekranie znakow kontrolnych
_TITLE "Stacja"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
'$DYNAMIC 'umozliwia zmiane dlugosci tabeli poleceniem REDIM
OPTION BASE 1 'pierwszy rekord tabeli domyslnie bedzie mial numer 1 zamiast 0
'''''''''''''''''''''''''''''' deklaracje zmiennych ''''''''''''''''''''''''''''
'deklaruje zmienne, ktore musialyby byc przekazane do procedury razem z tabela
DIM SHARED MapTableRecCount AS INTEGER
DIM SHARED RecNr AS INTEGER
DIM SHARED FramePosX AS _UNSIGNED _BYTE
DIM SHARED FramePosY AS _UNSIGNED _BYTE
''''''''''''''''''''''''''''''' deklaracje stalych '''''''''''''''''''''''''''''
GameDir$ = ".\"
LineCount = 80: ColumnCount = 30 'wymiary okna gry
'''''''''''''''''''''''''''''''' deklaracje typow ''''''''''''''''''''''''''''''
TYPE TypeMapTable 'rodzaj danych w tabeli
   CharY AS _UNSIGNED _BYTE 'wspolrzedne znaku
   CharX AS _UNSIGNED _BYTE
   CharColor AS _BYTE
   CharCode AS _UNSIGNED _BYTE
END TYPE
'''''''''''''''''''''''''''''''' deklaracje tabel ''''''''''''''''''''''''''''''
DIM SHARED MapTable(1) AS TypeMapTable 'tabela do przechowywania w pamieci mapy
'------------------------------------------------------------------------------'
'                                 EKRAN TYTULOWY                               '
'------------------------------------------------------------------------------'
WIDTH LineCount, ColumnCount 'wymiary okna gry
DO
   tytul_logo 'logo gry    'Logo
   COLOR 4, 1: LOCATE 30, 1: PRINT "v0.1 (c) 2023ö2024 Emil Sawicki";
   Key$ = UCASE$(INKEY$)
   DO: _LIMIT 500
      CurCoord CurX, CurY
      TitleMenu CurX, CurY 'rysowanie menu z podswietlaniem wskazanej opcji
      'zdarzenia myszy
      IF CurY = 17 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_nowagra TempY, TempX 'submenu "Nowa gra"
      'IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_wczytaj
      IF CurY = 21 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_edytor TempX
      IF CurY = 23 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) AND (CurY <> TempY OR CurX <> TempX) THEN SYSTEM
   LOOP WHILE _MOUSEINPUT
   'zdarzenia klawiatury
   IF Key$ = "N" THEN tytul_menu_nowagra TempY, TempX 'TitleMenuNewGame
   'IF klawisz$ = "W" THEN tytul_menu_wczytaj
   IF Key$ = "E" THEN tytul_menu_edytor TempX 'Key$, TempY
   IF Key$ = "K" OR Key$ = CHR$(27) THEN SYSTEM 'Key$
LOOP

SUB tytul_menu_nowagra (TempY, TempX) 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON 'ekran tytulowy - submenu "Nowa gra"  , TempY, TempX
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
            TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
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

SUB tytul_menu_edytor (TempX) 'ekran tytulowy - submenu "Edytor"
   LayerNr = 1 'domyslna warstwa edytora
   DO
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         COLOR 7, 8: LOCATE 17, 31: PRINT "      Edytor      " 'tytul tego menu jako nieaktywny "przycisk"
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
         'zdarzenia myszy
         IF CurY = 19 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN
            edytor_pelny_uruchamianie_warstwy LayerNr
            EXIT SUB 'po zakonczeniu edytora powrot do glownego menu ekranu tytulowego
         END IF
         'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
         '    edytor_tryb_uproszczony
         'EXIT SUB
         'END IF
         IF CurY = 23 AND CurX > 30 AND CurX < 49 AND _MOUSEBUTTON(1) THEN 'wstecz
            TempX = CurX
            EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "P" THEN
         edytor_pelny_uruchamianie_warstwy X
         EXIT SUB 'po zakonczeniu edytora powrot do ekranu tytulowego
      END IF
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
   'WIDTH 80, 25 'zmiana wymiarow okna gry zaleznie od wielkosci zaladowanej mapy
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
   MapPosX = 1: MapPosY = 10 'koordynaty lewego gornego rogu mapy
   'zmiana wymiarow okna
   'wczytanie mapy z pliku
   OPEN "mapa.txt" FOR INPUT AS #1
   COLOR 7, 0
   DO WHILE NOT EOF(1)
      '(przeniesc do taboru i elementow mapy) INPUT #1, nr_rek, klr_txt, klr_tlo, elem_map$, typ_elem$ 'nr_rekordu, kolor_tekstu, kolor_tla, element_mapy, typ_elementu (tor, semafor, rozjazd itd.)
      INPUT #1, RecNr, MapY, MapX, tresc_mapy$
      LOCATE MapY + MapPosY - 1, MapX + MapPosX - 1: PRINT tresc_mapy$ 'rysowanie torow
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
'                         EDYTOR MAP - TRYB PELNY - WYBOR WARSTWY                     '
'====================================================================================='
SUB edytor_pelny_uruchamianie_warstwy (LayerNr)
   CLS , 0
   'AUTOMATYCZNY WYBOR WARSTWY NA PODSTAWIE ZMIENNEJ
   IF LayerNr = 1 THEN 'mapa
      EditFullMap (TempVar)
   END IF
   IF LayerNr = 2 THEN 'oznaczanie torow
      EditFullTracks
   END IF
   IF LayerNr = 3 THEN 'oznaczanie rozjazdow
      'edytor_pelny_rozjazdy
   END IF
   IF LayerNr = 4 THEN 'oznaczanie sygnalizatorow
      'edytor_pelny_sygnalizatory
   END IF

   'KONIEC -  AUTOMATYCZNY WYBOR WARSTWY NA PODSTAWIE ZMIENNEJ
   IF TempVar = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
END SUB
'====================================================================================='
'                      EDYTOR MAP - TRYB PELNY - WARSTWA MAPY                         '
'====================================================================================='
'wybor edytora - nowa mapa lub istniejaca
SUB EditFullMap (TempVar) '1. warstwa - rysowanie schematu torow
   CLS , 1
   'edytor_tryb_pelny_sprawdzanie_plikow
   MapHeight = 25: MapWidth = 50 'domyslne wymiary nowej mapy
   CharColor = 15: BackColor = 0 'domyslne kolory: bialy i czarny
   DO
      MapPosY = 2: MapPosX = 2 'koordynaty poczatku mapy
      Key$ = UCASE$(INKEY$)
      DO: _LIMIT 500
         FrameDraw 2, 1, 23, 65, 0, 3, CHR$(205), CHR$(205), CHR$(186) 'ramka mapy
         CurCoord CurX, CurY
         'obliczanie pozycji kursora na mapie
         MapY = CurY - MapPosY
         MapX = CurX + MapPosX - 3
         'wyswietlanie pozycji kursora na mapie
         MapYCapped = MapY 'pokazuj rzeczywista pozycje
         MapXCapped = MapX
         IF MapY < 1 THEN MapYCapped = 1 'ograniczenie w sytuacji wyjechania kursorem poza mape
         IF MapY > 25 THEN MapYCapped = 25
         IF MapX < 1 THEN MapXCapped = 1
         IF MapX > 68 THEN MapXCapped = 60
         COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT MapYCapped;
         LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT MapXCapped;
         'zdarzenia myszy
         COLOR 7, 0 'przyciski do zmiany wielkosci mapy
         LOCATE 2, 36: PRINT CHR$(17): LOCATE 2, 41: PRINT CHR$(16); 'szerokosc mapy
         LOCATE 2, 43: PRINT CHR$(31): LOCATE 2, 48: PRINT CHR$(30); 'wysokosc mapy
         'wprowadzenie wartosci liczbowych do zmiany wielkosci mapy
         IF Y = 2 AND X = 36 AND _MOUSEBUTTON(1) THEN MapWidth = MapWidth - 1 'strzalka w lewo
         IF Y = 2 AND X = 41 AND _MOUSEBUTTON(1) THEN MapWidth = MapWidth + 1 'strzalka w prawo
         IF Y = 2 AND X = 43 AND _MOUSEBUTTON(1) THEN MapHeight = MapHeight - 1 'strzalka w dol
         IF Y = 2 AND X = 48 AND _MOUSEBUTTON(1) THEN MapHeight = MapHeight + 1 'strzalka w gore
         COLOR 7, 0: LOCATE 2, 37: PRINT MapWidth: LOCATE 2, 44: PRINT MapHeight; 'wyswietlanie wymiarow
         'pasek menu
         COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Warstwy  Instrukcja  Slownik                                            ";
         IF CurY = 1 AND CurX > 1 AND CurX < 8 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN
               TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
               EditMenuFile TempY, TempX, TempVar
               CLS , 1
            END IF
         ELSE
            COLOR 0, 7: LOCATE 1, 2: PRINT " Plik " 'napis zwykly
            COLOR 4: LOCATE 1, 3: PRINT "P" 'czerwona litera
         END IF
         IF CurY = 1 AND CurX > 7 AND CurX < 17 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 1, 8: PRINT " Warstwy " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN
               TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
               EditFullMenuLayer TempX, TempY, LayerNr 'menu otwierane w edytorze w celu zmiany warstwy
               CLS , 1
            END IF
         ELSE
            COLOR 0, 7: LOCATE 1, 8: PRINT " Warstwy " 'napis zwykly
            COLOR 4: LOCATE 1, 9: PRINT "W" 'czerwona litera
         END IF
         'edytor_pelny_menu_warstwa
         'okno mapy - etykieta koordynat kursora
         IF CurY = 2 AND CurX > 3 AND CurX < 27 THEN
            etykieta_mapa_koordynaty 'PRZEROBIC NA WSPOLNA PROCEDURE DLA WSZYSTKICH ETYKIET    'PopUp "koordynaty kursora"
            'ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, etykieta_wiersz_1$
            CLS , 1
         END IF
         spluczka
         edytor_pelny_MapTable_wyswietlanie 'rysuje ponownie mape
         PosX = 70: PosY = 2 'pozycja tablicy znakow do edycji torowiska
         EditFullElems PosX, PosY, X, Y, TempX, TempY, Char$, CharColor 'wyswietlanie tablicy znakow i ladowanie znaku do zmiennej 'Char$'
         IF CurX > 1 AND CurX < 69 AND CurY > 2 AND CurY < 26 AND _MOUSEBUTTON(1) AND Char$ <> "" AND (CurX <> TempX OR CurY <> TempY) THEN 'klikniecie w ramce mapy
            TempX = CurX: TempY = CurY 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
            '1. WPISYWANIE DO TABELI
            IF Char$ <> CHR$(42) THEN 'znak nie jest *
               IF MapTableRecCount = UBOUND(MapTable) THEN 'jezeli do tabeli juz cos wpisano:
                  FOR i = 1 TO UBOUND(MapTable) 'przeszukaj tabele
                     IF MapY = MapTable(i).CharY AND MapX = MapTable(i).CharX THEN 'jesli istnieje juz wpis o tych wspolrzednych
                        RecNr = i
                        EditFullMapTableDel
                        EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                     END IF
                  NEXT i 'koniec przeszukiwania tabeli pod katem wpisu o tych samych koordynatach
                  IF UBOUND(MapTable) = 0 THEN REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable
                  IF MapTable(1).CharY <> 0 THEN 'pierwszy wiersz tabeli nie zawiera wpisu 0,0,0,0
                     REDIM _PRESERVE MapTable(1 TO UBOUND(MapTable) + 1) AS TypeMapTable 'powieksz tabele tworzac nowy, pusty rekord
                  ELSE
                     RecNr = UBOUND(MapTable) 'pierwszy rekord zawiera zera wiec nadpisac go
                  END IF
               END IF
               RecNr = UBOUND(MapTable) 'przenosi miejsce wpisania nowego rekordu na koniec tabeli
               IF ASC(Char$) <> 0 THEN
                  MapTable(RecNr).CharY = MapY
                  MapTable(RecNr).CharX = MapX
                  MapTable(RecNr).CharColor = CharColor
                  MapTable(RecNr).CharCode = ASC(Char$)
                  MapTableRecCount = MapTableRecCount + 1 'aktualizuj liczbe rekordow
               END IF
               '2. USUWANIE Z TABELI
            ELSE 'znak jest * o wspolrzednych MapY, MapX AND liczba_rekordow_tabeli_mapy > 0   AND liczba_rekordow_tabeli_mapy = UBOUND(tabela_mapa)
               'pobranie do zmiennej RecNr numeru wpisu o wspolrzednych wiersz_mapy i kolumna_mapy
               FOR i = 1 TO UBOUND(MapTable) 'wyszkuje w tabeli rekord o podanych wspolrzednych
                  IF MapY = MapTable(i).CharY AND MapX = MapTable(i).CharX THEN
                     RecNr = i
                     EditFullMapTableDel
                     COLOR , 1: LOCATE CurY, CurX: PRINT " "; 'czysci znak z podgladu mapy
                     EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                  END IF
               NEXT i
            END IF
            '3. WYSWIETLANIE ZAWARTOSCI TABELI W RAMCE MAPY
            edytor_pelny_MapTable_wyswietlanie
            '4. AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
            OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1
            FOR RecNr = 1 TO UBOUND(MapTable)
               WRITE #1, MapTable(RecNr).CharY, MapTable(RecNr).CharX, MapTable(RecNr).CharColor, MapTable(RecNr).CharCode
            NEXT RecNr
            CLOSE #1
         END IF
         'pasek_informacyjny pasek_informacyjny_tresc
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "P" THEN EditMenuFile TempY, TempX, TempVar 'procedura menu zwraca zmienna TempVar
      IF TempVar = 1 THEN 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna TempVar, ktora wychodzi z TEJ petli
         CLS , 1
         EXIT SUB
      END IF
      IF Key$ = "W" THEN EditFullMenuLayer TempX, TempY, LayerNr
   LOOP
END SUB
'========================================================================================='
'                 EDYTOR MAP - TRYB PELNY - WARSTWA PARAMETROW TOROW                      '
'========================================================================================='
SUB EditFullTracks '2. warstwa - oznaczanie parametrow torow na schemacie
   DO
      DO: _LIMIT 500
         PosX = 1: PosY = 2 'polozenie poczatku ramki
         LineCount = 23: TxtLength = 65 'wymiary wnetrza ramki
         FrameCharColor = 0: FrameBackColor = 3 'kolory ramki
         FrameTop$ = CHR$(205): FrameBottom$ = CHR$(205): FrameSide$ = CHR$(186)
         FrameDraw PosY, PosX, LineCount, TxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$ 'ramka mapy
         CurCoord CurX, CurY
         'obliczanie pozycji kursora na mapie
         MapY = CurY - MapPosY
         MapX = CurX + MapPosX - 3 'GDZIE JEST OBLICZANE WIERSZ/KOLUMNA_POCZATKU_MAPY?
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
            IF CurX > 1 AND CurX < 6 THEN EditMenuFile TempY, TempX, TempVar
            IF CurX > 7 AND CurX < 17 THEN EditFullMenuLayer TempX, TempY, LayerNr
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
SUB EditFullMenuLayer (TempX, TempY, TempVar) 'menu Warstwy w edytorze trybu pelnego
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
            IF _MOUSEBUTTON(1) THEN EditFullMap TempVar 'procedura rysowania schematu torow
         ELSE
            COLOR 0, 7: LOCATE PosY + 1, PosX + 1: PRINT " Schemat torow        " 'napis zwykly
            COLOR 4: LOCATE PosY + 1, PosX + 2: PRINT "S" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 4 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 2, PosX + 1: PRINT " Oznaczanie torow     " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN EditFullTracks 'procedura oznaczania parametrow torow
         ELSE
            COLOR 0, 7: LOCATE PosY + 2, PosX + 1: PRINT " Oznaczanie torow     " 'napis zwykly
            COLOR 4: LOCATE PosY + 2, PosX + 2: PRINT "O" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 5 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 3, PosX + 1: PRINT " Urzadzenia i sygnaly " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN EditFullDevices 'procedura oznaczania urzadzen i sygnalow
         ELSE
            COLOR 0, 7: LOCATE PosY + 3, PosX + 1: PRINT " Urzadzenia i sygnaly " 'napis zwykly
            COLOR 4: LOCATE PosY + 3, PosX + 2: PRINT "U" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 6 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 4, PosX + 1: PRINT " Przebiegi            " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN EditFullWays 'procedura oznaczania przebiegow
         ELSE
            COLOR 0, 7: LOCATE PosY + 4, PosX + 1: PRINT " Przebiegi            " 'napis zwykly
            COLOR 4: LOCATE PosY + 4, PosX + 2: PRINT "P" 'czerwona litera
         END IF
         IF CurX >= PosX + 1 AND CurX <= PosX + TxtLength AND CurY = 7 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE PosY + 5, PosX + 1: PRINT " Rozklad jazdy        " 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN EditFullSched 'procedura ukladania rozkladu jazdy
         ELSE
            COLOR 0, 7: LOCATE PosY + 5, PosX + 1: PRINT " Rozklad jazdy        " 'napis zwykly
            COLOR 4: LOCATE PosY + 5, PosX + 2: PRINT "R" 'czerwona litera
         END IF
         IF (CurX < PosX OR CurX > PosX + TxtLength + 1 OR CurY < PosY OR CurY > PosY + LineCount + 1) AND (TempX <> CurX OR TempY <> CurY) AND _MOUSEBUTTON(1) THEN EXIT SUB 'klik poza menu
      LOOP WHILE _MOUSEINPUT
      SELECT CASE Key$ 'obsluga menu klawiszami
         CASE "S"
            EditFullMap TempVar
            EXIT SUB
         CASE "O"
            EditFullTracks
            EXIT SUB
         CASE "U"
            EditFullDevices
            EXIT SUB
         CASE "P"
            EditFullWays
            EXIT SUB
         CASE "R"
            EditFullSched
            EXIT SUB
         CASE CHR$(27) '[Esc]
            CLS , 0
            EXIT SUB
      END SELECT
   LOOP
END SUB
'------------------------------------------------------------------------------'
'                        EDYTOR MAP - TRYB UPROSZCZONY                         '
'------------------------------------------------------------------------------'
'wybor edytora - nowa mapa lub istniejaca
'------------------------------------------------------------------------------'
'                                 EDYTOR TABORU                                '
'------------------------------------------------------------------------------'
'nic
'------------------------------------------------------------------------------'
'                      PROCEDURY - EDYTOR MAP - TRYB PELNY                     '
'------------------------------------------------------------------------------'
SUB edytor_pelny_MapTable_wyswietlanie
   IF MapTableRecCount > 0 THEN 'tylko jesli cokolwiek do niej wpisano
      FOR RecNr = 1 TO UBOUND(MapTable)
         COLOR MapTable(RecNr).CharColor, 1: LOCATE MapTable(RecNr).CharY + 2, MapTable(RecNr).CharX + 1: PRINT CHR$(MapTable(RecNr).CharCode); 'wiersz +2 i kolumna +1 to offset
      NEXT RecNr
   END IF
END SUB

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
SUB EditMenuFile (TempY, TempX, TempVar)
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
         ELSE
            COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa mapa " 'napis zwykly
            COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
         END IF
         IF CurY = 4 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 4, 2: PRINT " Wczytaj   " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 4, 2: PRINT " Wczytaj   " 'napis zwykly
            COLOR 4: LOCATE 4, 3: PRINT "W" 'czerwona litera
         END IF
         IF CurY = 5 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 5, 2: PRINT " Zapisz    " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 5, 2: PRINT " Zapisz    " 'napis zwykly
            COLOR 4: LOCATE 5, 3: PRINT "Z" 'czerwona litera
         END IF
         IF CurY = 6 AND CurX > 1 AND CurX < 13 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 6, 2: PRINT " Koniec    " 'napis w negatywie
         ELSE
            COLOR 0, 7: LOCATE 6, 2: PRINT " Koniec    " 'napis zwykly
            COLOR 4: LOCATE 6, 3: PRINT "K" 'czerwona litera
         END IF
         'zdarzenia myszy
         IF CurY = 3 AND CurX > 1 AND CurX < 13 AND _MOUSEBUTTON(1) THEN
            TempY = CurY: TempX = CurX
            edytor_dialog_nowa_mapa CurY, CurX, TempY, TempX 'okienko dialogowe do rozpoczynania nowej, czystej mapy
            EXIT SUB 'zamknie menu po zamknieciu okienka nowej mapy
         END IF
         IF CurY = 4 AND CurX > 1 AND CurX < 13 AND _MOUSEBUTTON(1) THEN
            TempY = CurY: TempX = CurX
            edytor_dialog_wczytaj CurY, CurX, TempY, TempX 'okienko zapisu mapy do pliku mapa.txt
            EXIT SUB 'zamknie menu po zakmnieciu okienka wczytywania
         END IF
         IF CurY = 5 AND CurX > 1 AND CurX < 13 AND _MOUSEBUTTON(1) THEN
            TempY = CurY: TempX = CurX
            edytor_dialog_zapisz CurY, CurX, TempY, TempX 'okienko zapisu mapy do pliku mapa.txt
            EXIT SUB 'zamknie menu po zamknieciu okienka zapisu
         END IF
         IF (CurX > PosX + TxtLength + 3 OR CurY = 1 OR CurY > PosY + LineCount + 1) AND (CurY <> TempY OR CurX <> TempX) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
            TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
            CLS , 0
            EXIT SUB
         END IF
         IF CurY = 6 AND CurX > 1 AND CurX < 13 AND _MOUSEBUTTON(1) THEN 'koniec
            TempVar = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
            EXIT SUB
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "N" THEN
         edytor_dialog_nowa_mapa CurX, CurY, TempY, TempX 'okienko rozpoczynania nowej, czystej mapy
         EXIT SUB 'zamknie menu po zakmnieciu okienka nowej mapy
      END IF
      IF Key$ = "W" THEN
         edytor_dialog_wczytaj CurX, CurY, TempY, TempX
         EXIT SUB
      END IF
      IF Key$ = "Z" THEN
         edytor_dialog_zapisz CurX, CurY, TempY, TempX
         EXIT SUB
      END IF
      IF Key$ = "K" THEN
         TempVar = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
         EXIT SUB
      END IF
      IF Key$ = CHR$(27) THEN 'Esc
         CLS , 0
         EXIT SUB 'zamkniecie menu
      END IF
   LOOP
END SUB

SUB edytor_dialog_nowa_mapa (CurX, CurY, TempY, TempX) 'okienko dialogowe do rozpoczynania nowej, czystej mapy
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
            IF _MOUSEBUTTON(1) THEN
               TempY = Y: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
               REDIM MapTable(1) AS TypeMapTable
               MapTableRecCount = 0
               EXIT SUB 'przewymiaruj tabele i zamknij okienko
            END IF
         END IF
         IF CurY = PosY + 4 AND CurX > PosX + 16 AND CurX < PosX + 22 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 17: PRINT " Nie "; 'napis w negatywie
            IF _MOUSEBUTTON(1) THEN
               TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
               EXIT SUB
            END IF
         END IF
      LOOP WHILE _MOUSEINPUT
      'zdarzenia klawiatury
      IF Key$ = "T" OR Key$ = CHR$(13) THEN
         REDIM MapTable(1) AS TypeMapTable: EXIT SUB 'przewymiaruj tabele bez zachowania tresci i zamknij okienko
      END IF
      IF Key$ = "N" OR Key$ = CHR$(27) THEN EXIT SUB
   LOOP
END SUB
'==============================================================='
'             EDYTOR - OBA TRYBY - DIALOG WCZYTAJ               '
'==============================================================='
SUB edytor_dialog_wczytaj (CurX, CurY, TempY, TempX)
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
               TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
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
            IF _MOUSEBUTTON(1) THEN
               EXIT SUB
            END IF
         END IF
         IF (CurY < PosY OR CurY > PosY + LineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) AND (CurY <> TempY OR CurX <> TempX) THEN 'klikniecie poza ramka
            EXIT SUB
         END IF
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
'==============================================================='
'             EDYTOR - OBA TRYBY - DIALOG ZAPISZ                '
'==============================================================='
SUB edytor_dialog_zapisz (CurX, CurY, TempY, TempX)
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
         LOCATE PosY + 4, PosX + 3: PRINT "T";
         LOCATE PosY + 4, PosX + 16: PRINT "N";
         CurCoord CurX, CurY
         'zdarzenia myszy
         IF CurY = PosY + 4 AND CurX > PosX + 1 AND CurX < PosX + 7 THEN
            COLOR 7, 0: LOCATE PosY + 4, PosX + 2: PRINT " Tak "; 'napis w negatywie
            IF MapTableRecCount > 0 THEN 'wykluczenie mozliwosci zapisu pustej mapy
               IF _MOUSEBUTTON(1) THEN
                  TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                  OPEN GameDir$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1
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
            IF _MOUSEBUTTON(1) THEN
               TempY = CurY: TempX = CurX 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
               EXIT SUB
            END IF
         END IF
         IF (CurY < PosY OR CurY > PosY + LineCount + 1 OR CurX < PosX OR CurX > PosX + TxtLength + 1) AND _MOUSEBUTTON(1) AND (CurY <> TempY OR CurX <> TempX) THEN 'klikniecie poza ramka
            EXIT SUB
         END IF
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
