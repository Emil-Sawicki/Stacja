_CONTROLCHR OFF 'umozliwia wypisywanie na ekranie znakow kontrolnych
_TITLE "Stacja"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
'$DYNAMIC 'umozliwia zmiane dlugosci tabeli poleceniem REDIM
OPTION BASE 1 'pierwszy rekord tabeli domyslnie bedzie mial numer 1 zamiast 0
'''''''''''''''''''''''''''''' deklaracje zmiennych ''''''''''''''''''''''''''''
'deklaruje zmienne, ktore musialyby byc przekazane do procedury razem z tabela
DIM SHARED liczba_rekordow_tabeli_mapy AS INTEGER
DIM SHARED nr_rekordu AS INTEGER
DIM SHARED ramka_kolumna_poczatku AS _UNSIGNED _BYTE
DIM SHARED ramka_wiersz_poczatku AS _UNSIGNED _BYTE
''''''''''''''''''''''''''''''' deklaracje stalych '''''''''''''''''''''''''''''
folder_gry$ = ".\"
'''''''''''''''''''''''''''''''' deklaracje typow ''''''''''''''''''''''''''''''
TYPE typ_tabela_mapa 'rodzaj danych w tabeli
    wiersz_znaku AS _UNSIGNED _BYTE
    kolumna_znaku AS _UNSIGNED _BYTE
    kolor_znaku AS _BYTE
    znak_kod AS _UNSIGNED _BYTE
END TYPE
'''''''''''''''''''''''''''''''' deklaracje tabel ''''''''''''''''''''''''''''''
DIM SHARED tabela_mapa(1) AS typ_tabela_mapa
'------------------------------------------------------------------------------'
'                                 EKRAN TYTULOWY                               '
'------------------------------------------------------------------------------'
liczba_wierszy = 80: liczba_kolumn = 30
WIDTH liczba_wierszy, liczba_kolumn
DO
    tytul_logo 'logo gry
    COLOR 4, 1: LOCATE 30, 1: PRINT "v0.1 (c) 2023 Emil Sawicki";
    klawisz$ = UCASE$(INKEY$)
    DO: _LIMIT 500
        koordynaty_kursora wiersz, kolumna
        tytul_menu wiersz, kolumna 'rysowanie menu z podswietlaniem wskazanej opcji
        'zdarzenia myszy
        IF wiersz = 17 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_nowagra tymczasowy_wiersz, tymczasowa_kolumna 'submenu "Nowa gra"
        'IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_wczytaj
        IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_edytor tymczasowa_kolumna
        IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) AND (wiersz <> tymczasowy_wiersz OR kolumna <> tymczasowa_kolumna) THEN SYSTEM
    LOOP WHILE _MOUSEINPUT
    'zdarzenia klawiatury
    IF klawisz$ = "N" THEN tytul_menu_nowagra tymczasowy_wiersz, tymczasowa_kolumna
    'IF klawisz$ = "W" THEN tytul_menu_wczytaj
    IF klawisz$ = "E" THEN tytul_menu_edytor tymczasowa_kolumna
    IF klawisz$ = "K" OR klawisz$ = CHR$(27) THEN SYSTEM
LOOP

SUB tytul_menu_nowagra (tymczasowy_wiersz, tymczasowa_kolumna) 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON'ekran tytulowy - submenu "Nowa gra"
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            COLOR 7, 8: LOCATE 17, 31: PRINT "     Nowa gra     " 'tytul tego menu jako nieaktywny "przycisk"
            koordynaty_kursora wiersz, kolumna
            'opcje menu i podswietlanie wskazanej
            IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis zwykly
                COLOR 4: LOCATE 19, 40: PRINT "p" 'czerwona litera
            END IF
            IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis zwykly
                COLOR 4: LOCATE 21, 37: PRINT "u" 'czerwona litera
            END IF
            IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 23, 31: PRINT "      Wstecz      " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 23, 31: PRINT "      Wstecz      " 'napis zwykly
                COLOR 4: LOCATE 23, 37: PRINT "W" 'czerwona litera
            END IF
            'mysz
            IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
                'gra_tryb_pelny 'TYMCZASOWO WYLACZONE
                EXIT SUB 'po zakonczeniu gry powrot do glownego menu
            END IF
            'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
            '    gra_tryb_uproszczony
            'EXIT SUB
            'END IF
            IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN 'wstecz
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'klawiatura
        IF klawisz$ = "P" THEN
            'gra_tryb_pelny 'TYMCZASOWO WYLACZONE
            EXIT SUB 'po zakonczeniu gry powrot do glownego menu
        END IF
        'IF klawisz$ = "U" THEN
        '    gra_tryb_uproszczony
        'EXIT SUB
        'END IF
        IF klawisz$ = "W" OR klawisz$ = CHR$(27) THEN EXIT SUB
    LOOP
END SUB

SUB tytul_menu_edytor (tymczasowa_kolumna) 'ekran tytulowy - submenu "Edytor"
    edytor_pelny_warstwa = 1 'domyslna warstwa edytora
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            COLOR 7, 8: LOCATE 17, 31: PRINT "      Edytor      " 'tytul tego menu jako nieaktywny "przycisk"
            koordynaty_kursora wiersz, kolumna
            'opcje menu i podswietlanie wskazanej
            IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 19, 31: PRINT "    Tryb pelny    " 'napis zwykly
                COLOR 4: LOCATE 19, 40: PRINT "p" 'czerwona litera
            END IF
            IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 21, 31: PRINT " Tryb uproszczony " 'napis zwykly
                COLOR 4: LOCATE 21, 37: PRINT "u" 'czerwona litera
            END IF
            IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 23, 31: PRINT "      Wstecz      " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 23, 31: PRINT "      Wstecz      " 'napis zwykly
                COLOR 4: LOCATE 23, 37: PRINT "W" 'czerwona litera
            END IF
            'zdarzenia myszy
            IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
                edytor_pelny_uruchamianie_warstwy edytor_pelny_warstwa
                EXIT SUB 'po zakonczeniu edytora powrot do glownego menu ekranu tytulowego
            END IF
            'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
            '    edytor_tryb_uproszczony
            'EXIT SUB
            'END IF
            IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN 'wstecz
                tymczasowa_kolumna = kolumna
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "P" THEN
            edytor_pelny_uruchamianie_warstwy x
            EXIT SUB 'po zakonczeniu edytora powrot do ekranu tytulowego
        END IF
        'IF klawisz$ = "U" THEN
        '    edytor_tryb_uproszczony
        'EXIT SUB
        'END IF
        IF klawisz$ = "W" OR klawisz$ = CHR$(27) THEN EXIT SUB
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
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            'zdarzenia myszy
            'gorny pasek menu
            IF wiersz = 1 AND kolumna > 1 AND kolumna < 7 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 1, 2: PRINT " Plik " 'napis zwykly
                COLOR 4: LOCATE 1, 6: PRINT "N" 'czerwona litera
            END IF
            IF kolumna > 1 AND kolumna < 6 AND wiersz = 1 AND _MOUSEBUTTON(1) THEN gra_menu_plik x
            IF kolumna > 6 AND kolumna < 14 AND wiersz = 1 AND _MOUSEBUTTON(1) THEN gra_tryb_pelny_okno_pociagi
        LOOP WHILE _MOUSEINPUT
        'klawiatura
        IF klawisz$ = "K" THEN gra_menu_plik x
        IF x = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
        IF klawisz$ = "P" THEN gra_tryb_pelny_okno_pociagi
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

SUB gra_menu_plik (x)
    x = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
    ramka_wiersz_poczatku = 2
    ramka_kolumna_poczatku = 1
    ramka_liczba_wierszy = 4
    ramka_dlugosc_tekstu = 8
    ramka_kolor_znakow = 0: ramka_kolor_tla = 7
    ramka_gora$ = CHR$(196): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
    rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, ramka_kolor_znakow, ramka_kolor_tla, ramka_gora$, ramka_dol$, ramka_boki$
    COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            'opcje menu i podswietlanie wskazanej
            IF wiersz = 3 AND kolumna > 1 AND kolumna < 12 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 3, 2: PRINT " Nowa gra " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa gra " 'napis zwykly
                COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
            END IF
            IF wiersz = 4 AND kolumna > 1 AND kolumna < 12 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 4, 2: PRINT " Zapisz   " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 4, 2: PRINT " Zapisz   " 'napis zwykly
                COLOR 4: LOCATE 4, 3: PRINT "Z" 'czerwona litera
            END IF
            IF wiersz = 5 AND kolumna > 1 AND kolumna < 12 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 5, 2: PRINT " Wczytaj  " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 5, 2: PRINT " Wczytaj  " 'napis zwykly
                COLOR 4: LOCATE 5, 3: PRINT "W" 'czerwona litera
            END IF
            IF wiersz = 6 AND kolumna > 1 AND kolumna < 12 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 6, 2: PRINT " Koniec   " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 6, 2: PRINT " Koniec   " 'napis zwykly
                COLOR 4: LOCATE 6, 3: PRINT "K" 'czerwona litera
            END IF
            'zdarzenia myszy
            IF (kolumna > ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3 OR wiersz > ramka_wiersz_poczatku + ramka_liczba_wierszy + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
                CLS , 0
                EXIT SUB
            END IF
            IF wiersz = 6 AND kolumna > 1 AND kolumna < 12 AND _MOUSEBUTTON(1) THEN 'koniec
                x = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "K" THEN
            x = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
            EXIT SUB
        END IF
        IF klawisz$ = CHR$(27) THEN
            CLS , 0
            EXIT SUB 'zamkniecie menu
        END IF
    LOOP
END SUB

SUB gra_tryb_pelny_okno_pociagi
    ramka_wiersz_poczatku = 3
    ramka_kolumna_poczatku = 7
    ramka_liczba_wierszy = 1
    ramka_dlugosc_tekstu = 7
    ramka_kolor_znakow = 0: ramka_kolor_tla = 7
    ramka_gora$ = CHR$(205): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
    rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, ramka_kolor_znakow, ramka_kolor_tla, ramka_gora$, ramka_dol$, ramka_boki$
    COLOR 7, 0: LOCATE 1, 8: PRINT " Pociagi " 'odwroc kolory w nazwie otwartego okna
    'zawartosc okna
    COLOR 0, 7: LOCATE ramka_wiersz_poczatku + 1, ramka_kolumna_poczatku + 2: PRINT "Pociagi "
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie okna
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            IF wiersz = ramka_wiersz_poczatku AND kolumna = ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 2 THEN 'kursor na przycisku
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 2: PRINT "X" 'przycisk w negatywie
            ELSE
                COLOR 4, 7: LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 2: PRINT "X" 'czerwona litera
            END IF
            'klikniecie przycisku zamkniecia
            IF wiersz = ramka_wiersz_poczatku AND kolumna = ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 2 AND _MOUSEBUTTON(1) THEN
                EXIT SUB
            END IF
            'klikniecie poza oknem
            IF (wiersz < ramka_wiersz_poczatku OR wiersz > ramka_wiersz_poczatku + ramka_liczba_wierszy + 1 OR kolumna < ramka_kolumna_poczatku OR kolumna > ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3) AND _MOUSEBUTTON(1) THEN
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "X" OR klawisz$ = CHR$(27) THEN
            EXIT SUB
        END IF
    LOOP
END SUB

SUB gra_tryb_pelny_mapa
    wiersz_poczatku_mapy = 10 'koordynaty lewego gornego rogu mapy
    kolumna_poczatku_mapy = 1
    'zmiana wymiarow okna
    'wczytanie mapy z pliku
    OPEN "mapa.txt" FOR INPUT AS #1
    COLOR 7, 0
    DO WHILE NOT EOF(1)
        '(przeniesc do taboru i elementow mapy) INPUT #1, nr_rek, klr_txt, klr_tlo, elem_map$, typ_elem$ 'nr_rekordu, kolor_tekstu, kolor_tla, element_mapy, typ_elementu (tor, semafor, rozjazd itd.)
        INPUT #1, nr_rekordu, wiersz_mapy, kolumna_mapy, tresc_mapy$
        LOCATE wiersz_mapy + wiersz_poczatku_mapy - 1, kolumna_mapy + kolumna_poczatku_mapy - 1: PRINT tresc_mapy$
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
'''''''''''''''''''''''''' edytor map - wybor warstwy ''''''''''''''''''''''''''
SUB edytor_pelny_uruchamianie_warstwy (edytor_pelny_warstwa)
    CLS , 0
    'AUTOMATYCZNY WYBOR WARSTWY NA PODSTAWIE ZMIENNEJ
    IF edytor_pelny_warstwa = 1 THEN 'mapa
        edytor_pelny_mapa x
    END IF
    IF edytor_pelny_warstwa = 2 THEN 'oznaczanie torow
        edytor_pelny_tory
    END IF
    IF edytor_pelny_warstwa = 3 THEN 'oznaczanie rozjazdow
        'edytor_pelny_rozjazdy
    END IF
    IF edytor_pelny_warstwa = 4 THEN 'oznaczanie sygnalizatorow
        'edytor_pelny_sygnalizatory
    END IF

    'KONIEC -  AUTOMATYCZNY WYBOR WARSTWY NA PODSTAWIE ZMIENNEJ
    IF x = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
END SUB
'------------------------------------------------------------------------------'
'                 EDYTOR MAP - TRYB PELNY - WARSTWA MAPY                       '
'------------------------------------------------------------------------------'
'wybor edytora - nowa mapa lub istniejaca
SUB edytor_pelny_mapa (x) '1. warstwa - rysowanie schematu torow
    CLS , 1
    'edytor_tryb_pelny_sprawdzanie_plikow
    wysokosc_mapy = 25: szerokosc_mapy = 50 'domyslne wymiary nowej mapy
    kolor_znaku = 15: kolor_tla = 0 'domyslne kolory: bialy i czarny
    DO
        wiersz_poczatku_mapy = 2: kolumna_poczatku_mapy = 2 'koordynaty poczatku mapy
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            rysuj_ramke 2, 1, 23, 65, 0, 3, CHR$(205), CHR$(205), CHR$(186) 'ramka mapy
            koordynaty_kursora wiersz, kolumna
            'obliczanie pozycji kursora na mapie
            wiersz_mapy = wiersz - wiersz_poczatku_mapy
            kolumna_mapy = kolumna + kolumna_poczatku_mapy - 3
            'wyswietlanie pozycji kursora na mapie
            wiersz_mapy_wyswietlany = wiersz_mapy
            kolumna_mapy_wyswietlana = kolumna_mapy
            IF wiersz_mapy < 1 THEN wiersz_mapy_wyswietlany = 1
            IF wiersz_mapy > 25 THEN wiersz_mapy_wyswietlany = 25
            IF kolumna_mapy < 1 THEN kolumna_mapy_wyswietlana = 1
            IF kolumna_mapy > 68 THEN kolumna_mapy_wyswietlana = 60
            COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT wiersz_mapy_wyswietlany;
            LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT kolumna_mapy_wyswietlana;
            'zdarzenia myszy
            COLOR 7, 0 'przyciski do zmiany wielkosci mapy
            LOCATE 2, 36: PRINT CHR$(17): LOCATE 2, 41: PRINT CHR$(16); 'szerokosc mapy
            LOCATE 2, 43: PRINT CHR$(31): LOCATE 2, 48: PRINT CHR$(30); 'wysokosc mapy
            'wprowadzenie wartosci liczbowych
            IF wiersz = 2 AND kolumna = 36 AND _MOUSEBUTTON(1) THEN szerokosc_mapy = szerokosc_mapy - 1 'strzalka w lewo
            IF wiersz = 2 AND kolumna = 41 AND _MOUSEBUTTON(1) THEN szerokosc_mapy = szerokosc_mapy + 1 'strzalka w prawo
            IF wiersz = 2 AND kolumna = 43 AND _MOUSEBUTTON(1) THEN wysokosc_mapy = wysokosc_mapy - 1 'strzalka w dol
            IF wiersz = 2 AND kolumna = 48 AND _MOUSEBUTTON(1) THEN wysokosc_mapy = wysokosc_mapy + 1 'strzalka w gore
            COLOR 7, 0: LOCATE 2, 37: PRINT szerokosc_mapy: LOCATE 2, 44: PRINT wysokosc_mapy; 'wyswietlanie wymiarow
            'pasek menu
            COLOR 0, 7: LOCATE 1, 1: PRINT "        Warstwy  Instrukcja  Slownik                                            ";
            COLOR 4: LOCATE 1, 6: PRINT "k"; 'czerwone litery
            LOCATE 1, 9: PRINT "W";
            'pasek menu z hooverem
            IF wiersz = 1 AND kolumna > 1 AND kolumna < 7 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 1, 2: PRINT " Plik " 'napis zwykly
                COLOR 4: LOCATE 1, 3: PRINT "P" 'czerwona litera
            END IF
            'nacisniecia przyciskow paska menu
            IF wiersz = 1 AND _MOUSEBUTTON(1) THEN
                IF kolumna > 1 AND kolumna < 6 THEN edytor_menu_plik tymczasowy_wiersz, tymczasowa_kolumna, x
                IF kolumna > 7 AND kolumna < 17 THEN edytor_pelny_menu_wybor_warstwy tymczasowy_wiersz, tymczasowa_kolumna, edytor_pelny_warstwa
                CLS , 1
            END IF
            'edytor_pelny_menu_warstwa
            'okno mapy - etykieta koordynat kursora
            IF wiersz = 2 AND kolumna > 3 AND kolumna < 27 THEN
                etykieta_mapa_koordynaty 'PRZEROBIC NA WSPOLNA PROCEDURE DLA WSZYSTKICH ETYKIET
                'ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, etykieta_wiersz_1$
                CLS , 1
            END IF
            spluczka
            edytor_pelny_tabela_mapa_wyswietlanie 'rysuje ponownie mape
            edytor_pelny_torowisko wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna, znak$, kolor_znaku 'wyswietlanie tablicy znakow i ladowanie znaku do zmiennej 'znak$'
            IF wiersz > 2 AND wiersz < 26 AND kolumna > 1 AND kolumna < 69 AND _MOUSEBUTTON(1) AND znak$ <> "" AND (wiersz <> tymczasowy_wiersz OR kolumna <> tymczasowa_kolumna) THEN 'klikniecie w ramce mapy
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                '1. WPISYWANIE DO TABELI
                IF znak$ <> "X" THEN 'znak nie jest X
                    IF liczba_rekordow_tabeli_mapy = UBOUND(tabela_mapa) THEN 'jezeli do tabeli juz cos wpisano:
                        FOR i = 1 TO UBOUND(tabela_mapa) 'przeszukaj tabele
                            IF wiersz_mapy = tabela_mapa(i).wiersz_znaku AND kolumna_mapy = tabela_mapa(i).kolumna_znaku THEN 'jesli istnieje juz wpis o tych wspolrzednych
                                nr_rekordu = i
                                edytor_pelny_tabela_mapa_usuwanie
                                EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                            END IF
                        NEXT i 'koniec przeszukiwania tabeli pod katem wpisu o tych samych koordynatach
                        IF tabela_mapa(1).wiersz_znaku <> 0 THEN 'jesli pierwszy wiersz tabeli nie zawiera wpisu 0,0,0,0
                            REDIM _PRESERVE tabela_mapa(1 TO UBOUND(tabela_mapa) + 1) AS typ_tabela_mapa 'powieksz tabele tworzac nowy, pusty rekord
                        ELSE
                            nr_rekordu = UBOUND(tabela_mapa) 'pierwszy rekord zawiera zera wiec nadpisac go
                        END IF
                    END IF
                    nr_rekordu = UBOUND(tabela_mapa) 'przenosi miejsce wpisania nowego rekordu na koniec tabeli
                    IF ASC(znak$) <> 0 THEN
                        tabela_mapa(nr_rekordu).wiersz_znaku = wiersz_mapy
                        tabela_mapa(nr_rekordu).kolumna_znaku = kolumna_mapy
                        tabela_mapa(nr_rekordu).kolor_znaku = kolor_znaku
                        tabela_mapa(nr_rekordu).znak_kod = ASC(znak$)
                        liczba_rekordow_tabeli_mapy = liczba_rekordow_tabeli_mapy + 1 'aktualizuj liczbe rekordow
                    END IF
                    '2. USUWANIE Z TABELI
                ELSE 'znak jest X o wspolrzednych wiersz_mapy, kolumna_mapy AND liczba_rekordow_tabeli_mapy > 0   AND liczba_rekordow_tabeli_mapy = UBOUND(tabela_mapa)
                    'pobranie do zmiennej nr_rekordu numeru wpisu o wspolrzednych wiersz_mapy i kolumna_mapy
                    FOR i = 1 TO UBOUND(tabela_mapa) 'wyszkuje w tabeli rekord o podanych wspolrzednych
                        IF wiersz_mapy = tabela_mapa(i).wiersz_znaku AND kolumna_mapy = tabela_mapa(i).kolumna_znaku THEN
                            nr_rekordu = i
                            edytor_pelny_tabela_mapa_usuwanie
                            COLOR , 1: LOCATE wiersz, kolumna: PRINT " "; 'czysci znak z podgladu mapy
                            EXIT FOR 'po jednym wykonaniu procedury usuwania opuszcza petle wyszukiwania
                        END IF
                    NEXT i
                END IF
                IF UBOUND(tabela_mapa) = 0 THEN REDIM _PRESERVE tabela_mapa(1 TO UBOUND(tabela_mapa) + 1) AS typ_tabela_mapa 'jesli tabela zostala wyczyszczona to utworz nowy, pusty rekord
                edytor_pelny_tabela_mapa_wyswietlanie '3. WYSWIETLANIE ZAWARTOSCI TABELI W RAMCE MAPY
                '4. AUTOZAPIS TABELI DO PLIKU TYMCZASOWEGO
                OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\nowa_mapa.txt" FOR OUTPUT AS #1
                FOR nr_rekordu = 1 TO UBOUND(tabela_mapa)
                    WRITE #1, tabela_mapa(nr_rekordu).wiersz_znaku, tabela_mapa(nr_rekordu).kolumna_znaku, tabela_mapa(nr_rekordu).kolor_znaku, tabela_mapa(nr_rekordu).znak_kod
                NEXT nr_rekordu
                CLOSE #1
            END IF
            pasek_informacyjny pasek_informacyjny_tresc
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "K" THEN edytor_menu_plik tymczasowy_wiersz, tymczasowa_kolumna, x 'procedura menu zwraca zmienna x
        IF x = 1 THEN
            CLS , 1
            EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
        END IF
    LOOP
END SUB
'------------------------------------------------------------------------------'
'                 EDYTOR MAP - TRYB PELNY - WARSTWA TOROW                      '
'------------------------------------------------------------------------------'
SUB edytor_pelny_tory '2. warstwa - oznaczanie parametrow torow na schemacie
    DO
        DO: _LIMIT 500
            rysuj_ramke 2, 1, 23, 65, 0, 3, CHR$(205), CHR$(205), CHR$(186) 'ramka mapy
            koordynaty_kursora wiersz, kolumna
            'obliczanie pozycji kursora na mapie
            wiersz_mapy = wiersz - wiersz_poczatku_mapy
            kolumna_mapy = kolumna + kolumna_poczatku_mapy - 3
            'wyswietlanie pozycji kursora na mapie
            wiersz_mapy_wyswietlany = wiersz_mapy
            kolumna_mapy_wyswietlana = kolumna_mapy
            IF wiersz_mapy < 1 THEN wiersz_mapy_wyswietlany = 1
            IF wiersz_mapy > 25 THEN wiersz_mapy_wyswietlany = 25
            IF kolumna_mapy < 1 THEN kolumna_mapy_wyswietlana = 1
            IF kolumna_mapy > 68 THEN kolumna_mapy_wyswietlana = 60
            COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT wiersz_mapy_wyswietlany;
            LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT kolumna_mapy_wyswietlana;
            'pasek menu
            COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Warstwy  Instrukcja  Slownik                                            ";
            COLOR 4: LOCATE 1, 6: PRINT "k"; 'czerwone litery
            LOCATE 1, 9: PRINT "W";
            'zdarzenia myszy
            IF wiersz = 1 AND _MOUSEBUTTON(1) THEN
                IF kolumna > 1 AND kolumna < 6 THEN edytor_menu_plik tymczasowy_wiersz, tymczasowa_kolumna, x
                IF kolumna > 7 AND kolumna < 17 THEN edytor_pelny_menu_wybor_warstwy tymczasowy_wiersz, tymczasowa_kolumna, edytor_pelny_warstwa
                CLS , 1
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
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
SUB edytor_pelny_tabela_mapa_wyswietlanie
    IF liczba_rekordow_tabeli_mapy > 0 THEN 'tylko jesli cokolwiek do niej wpisano
        FOR nr_rekordu = 1 TO UBOUND(tabela_mapa)
            COLOR tabela_mapa(nr_rekordu).kolor_znaku, 1: LOCATE tabela_mapa(nr_rekordu).wiersz_znaku + 2, tabela_mapa(nr_rekordu).kolumna_znaku + 1: PRINT CHR$(tabela_mapa(nr_rekordu).znak_kod); 'wiersz +2 i kolumna +1 to offset
        NEXT nr_rekordu
    END IF
END SUB

SUB edytor_pelny_tabela_mapa_usuwanie
    'usuwanie konkretnego wpisu: za dany wpis podstawia sie ostatni
    tabela_mapa(nr_rekordu).wiersz_znaku = tabela_mapa(UBOUND(tabela_mapa)).wiersz_znaku
    tabela_mapa(nr_rekordu).kolumna_znaku = tabela_mapa(UBOUND(tabela_mapa)).kolumna_znaku
    tabela_mapa(nr_rekordu).kolor_znaku = tabela_mapa(UBOUND(tabela_mapa)).kolor_znaku
    tabela_mapa(nr_rekordu).znak_kod = tabela_mapa(UBOUND(tabela_mapa)).znak_kod
    'ostatni wpis teraz jest dublem wiec trzeba upierdolic tabele o ten rekord
    REDIM _PRESERVE tabela_mapa(UBOUND(tabela_mapa) - 1) AS typ_tabela_mapa '_PRESERVE zeby REDIM nie czyscil rekordow przy zmianie wielkosci tabeli
    liczba_rekordow_tabeli_mapy = liczba_rekordow_tabeli_mapy - 1 'aktualizuj licznik rekordow
END SUB
'------------------------------------------------------------------------------'
'                      PROCEDURY - EDYTOR MAP - OBA TRYBY                      '
'------------------------------------------------------------------------------'
SUB edytor_menu_plik (tymczasowy_wiersz, tymczasowa_kolumna, x)
    x = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
    ramka_wiersz_poczatku = 2
    ramka_kolumna_poczatku = 1
    ramka_liczba_wierszy = 4
    ramka_dlugosc_tekstu = 9
    ramka_kolor_znakow = 0: ramka_kolor_tla = 7
    ramka_gora$ = CHR$(196): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
    rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, ramka_kolor_znakow, ramka_kolor_tla, ramka_gora$, ramka_dol$, ramka_boki$
    COLOR 8, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            'opcje menu i podswietlanie wskazanej
            IF wiersz = 3 AND kolumna > 1 AND kolumna < 13 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 3, 2: PRINT " Nowa mapa " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 3, 2: PRINT " Nowa mapa " 'napis zwykly
                COLOR 4: LOCATE 3, 3: PRINT "N" 'czerwona litera
            END IF
            IF wiersz = 4 AND kolumna > 1 AND kolumna < 13 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 4, 2: PRINT " Wczytaj   " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 4, 2: PRINT " Wczytaj   " 'napis zwykly
                COLOR 4: LOCATE 4, 3: PRINT "W" 'czerwona litera
            END IF
            IF wiersz = 5 AND kolumna > 1 AND kolumna < 13 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 5, 2: PRINT " Zapisz    " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 5, 2: PRINT " Zapisz    " 'napis zwykly
                COLOR 4: LOCATE 5, 3: PRINT "Z" 'czerwona litera
            END IF
            IF wiersz = 6 AND kolumna > 1 AND kolumna < 13 THEN 'kursor na napisie
                COLOR 7, 0: LOCATE 6, 2: PRINT " Koniec    " 'napis w negatywie
            ELSE
                COLOR 0, 7: LOCATE 6, 2: PRINT " Koniec    " 'napis zwykly
                COLOR 4: LOCATE 6, 3: PRINT "K" 'czerwona litera
            END IF
            'zdarzenia myszy
            IF wiersz = 3 AND kolumna > 1 AND kolumna < 13 AND _MOUSEBUTTON(1) THEN
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna
                edytor_dialog_nowa_mapa wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna 'okienko dialogowe do rozpoczynania nowej, czystej mapy
                EXIT SUB 'zamknie menu po zamknieciu okienka nowej mapy
            END IF
            IF wiersz = 4 AND kolumna > 1 AND kolumna < 13 AND _MOUSEBUTTON(1) THEN
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna
                edytor_dialog_wczytaj wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna 'okienko zapisu mapy do pliku mapa.txt
                EXIT SUB 'zamknie menu po zakmnieciu okienka wczytywania
            END IF
            IF wiersz = 5 AND kolumna > 1 AND kolumna < 13 AND _MOUSEBUTTON(1) THEN
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna
                edytor_dialog_zapisz wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna 'okienko zapisu mapy do pliku mapa.txt
                EXIT SUB 'zamknie menu po zamknieciu okienka zapisu
            END IF
            IF (kolumna > ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3 OR wiersz > ramka_wiersz_poczatku + ramka_liczba_wierszy + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
                CLS , 0
                EXIT SUB
            END IF
            IF wiersz = 6 AND kolumna > 1 AND kolumna < 13 AND _MOUSEBUTTON(1) THEN 'koniec
                x = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "N" THEN
            edytor_dialog_nowa_mapa wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna 'okienko rozpoczynania nowej, czystej mapy
            EXIT SUB 'zamknie menu po zakmnieciu okienka nowej mapy
        END IF
        IF klawisz$ = "W" THEN
            edytor_dialog_wczytaj wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna
            EXIT SUB
        END IF
        IF klawisz$ = "Z" THEN
            edytor_dialog_zapisz wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna
            EXIT SUB
        END IF
        IF klawisz$ = "K" THEN
            x = 1 'po zakonczeniu tej procedury wyjdzie z gry do ekranu tytulowego
            EXIT SUB
        END IF
        IF klawisz$ = CHR$(27) THEN 'Esc
            CLS , 0
            EXIT SUB 'zamkniecie menu
        END IF
    LOOP
END SUB

SUB edytor_dialog_nowa_mapa (wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna) 'okienko dialogowe do rozpoczynania nowej, czystej mapy
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            ramka_wiersz_poczatku = 10: ramka_kolumna_poczatku = 25: ramka_liczba_wierszy = 4: ramka_dlugosc_tekstu = 20
            rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, 0, 3, CHR$(205), CHR$(196), CHR$(179)
            COLOR 0, 3
            LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + 2: PRINT " Nowa mapa "
            LOCATE ramka_wiersz_poczatku + 1, ramka_kolumna_poczatku + 1: PRINT " Dotychczasowy postep ";
            LOCATE ramka_wiersz_poczatku + 2, ramka_kolumna_poczatku + 1: PRINT " zostanie utracony.   ";
            LOCATE ramka_wiersz_poczatku + 3, ramka_kolumna_poczatku + 1: PRINT "      Na pewno?       ";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 1: PRINT "  Tak            Nie  ";
            COLOR 4, 3: 'czerwone litery
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 3: PRINT "T";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 18: PRINT "N";
            koordynaty_kursora wiersz, kolumna
            'zdarzenia myszy
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 1 AND kolumna < ramka_kolumna_poczatku + 7 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 2: PRINT " Tak "; 'napis w negatywie
                IF _MOUSEBUTTON(1) THEN
                    tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                    REDIM tabela_mapa(1) AS typ_tabela_mapa
                    liczba_rekordow_tabeli_mapy = 0
                    EXIT SUB 'przewymiaruj tabele i zamknij okienko
                END IF
            END IF
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 16 AND kolumna < ramka_kolumna_poczatku + 22 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 17: PRINT " Nie "; 'napis w negatywie
                IF _MOUSEBUTTON(1) THEN
                    tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                    EXIT SUB
                END IF
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "T" OR klawisz$ = CHR$(13) THEN
            REDIM tabela_mapa(1) AS typ_tabela_mapa: EXIT SUB 'przewymiaruj tabele bez zachowania tresci i zamknij okienko
        END IF
        IF klawisz$ = "N" OR klawisz$ = CHR$(27) THEN EXIT SUB
    LOOP
END SUB

SUB edytor_dialog_wczytaj (wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna)
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            ramka_wiersz_poczatku = 10: ramka_kolumna_poczatku = 25: ramka_liczba_wierszy = 4: ramka_dlugosc_tekstu = 20
            rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, 0, 3, CHR$(205), CHR$(196), CHR$(179)
            COLOR 0, 3
            LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + 2: PRINT " Wczytaj "
            LOCATE ramka_wiersz_poczatku + 1, ramka_kolumna_poczatku + 1: PRINT " Dotychczasowy postep ";
            LOCATE ramka_wiersz_poczatku + 2, ramka_kolumna_poczatku + 1: PRINT " zostanie utracony.   ";
            LOCATE ramka_wiersz_poczatku + 3, ramka_kolumna_poczatku + 1: PRINT "      Na pewno?       ";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 1: PRINT "  Tak            Nie  ";
            COLOR 4, 3: 'czerwone litery
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 3: PRINT "T";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 18: PRINT "N";
            koordynaty_kursora wiersz, kolumna
            'zdarzenia myszy
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 1 AND kolumna < ramka_kolumna_poczatku + 7 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 2: PRINT " Tak "; 'napis w negatywie
                IF _MOUSEBUTTON(1) THEN
                    tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                    REDIM tabela_mapa(1) AS typ_tabela_mapa 'przygotuj tabele na nowe dane
                    liczba_rekordow_tabeli_mapy = 0
                    OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR INPUT AS #1 'otworz plik mapa.txt i wczytaj go do tabeli
                    DO WHILE NOT EOF(1)
                        IF UBOUND(tabela_mapa) = liczba_rekordow_tabeli_mapy THEN REDIM _PRESERVE tabela_mapa(UBOUND(tabela_mapa) + 1) AS typ_tabela_mapa 'jesli brak pustego rekordu to dodaj go
                        INPUT #1, tabela_mapa(UBOUND(tabela_mapa)).wiersz_znaku, tabela_mapa(UBOUND(tabela_mapa)).kolumna_znaku, tabela_mapa(UBOUND(tabela_mapa)).kolor_znaku, tabela_mapa(UBOUND(tabela_mapa)).znak_kod
                        liczba_rekordow_tabeli_mapy = liczba_rekordow_tabeli_mapy + 1
                    LOOP
                    CLOSE #1
                    EXIT SUB
                END IF
            END IF
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 16 AND kolumna < ramka_kolumna_poczatku + 20 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 17: PRINT " Nie "; 'napis w negatywie
                IF _MOUSEBUTTON(1) THEN
                    EXIT SUB
                END IF
            END IF
            IF (wiersz < ramka_wiersz_poczatku OR wiersz > ramka_wiersz_poczatku + ramka_liczba_wierszy + 1 OR kolumna < ramka_kolumna_poczatku OR kolumna > ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 1) AND _MOUSEBUTTON(1) AND (wiersz <> tymczasowy_wiersz OR kolumna <> tymczasowa_kolumna) THEN 'klikniecie poza ramka
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "T" OR klawisz$ = CHR$(13) THEN
            REDIM tabela_mapa(1) AS typ_tabela_mapa 'przygotuj tabele na nowe dane
            liczba_rekordow_tabeli_mapy = 0
            OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR INPUT AS #1 'otworz plik mapa.txt i wczytaj go do tabeli
            DO WHILE NOT EOF(1)
                IF UBOUND(tabela_mapa) = liczba_rekordow_tabeli_mapy THEN REDIM tabela_mapa(UBOUND(tabela_mapa) + 1) AS typ_tabela_mapa 'jesli brak pustego rekordu to dodaj go
                INPUT #1, tabela_mapa(UBOUND(tabela_mapa)).wiersz_znaku, tabela_mapa(UBOUND(tabela_mapa)).kolumna_znaku, tabela_mapa(UBOUND(tabela_mapa)).kolor_znaku, tabela_mapa(UBOUND(tabela_mapa)).znak_kod
                liczba_rekordow_tabeli_mapy = liczba_rekordow_tabeli_mapy + 1
            LOOP
            CLOSE #1
            EXIT SUB
        END IF
        IF klawisz$ = "N" OR klawisz$ = CHR$(27) THEN EXIT SUB
    LOOP
END SUB

SUB edytor_dialog_zapisz (wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna)
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            ramka_wiersz_poczatku = 10: ramka_kolumna_poczatku = 25: ramka_liczba_wierszy = 4: ramka_dlugosc_tekstu = 18
            rysuj_ramke ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, 0, 3, CHR$(205), CHR$(196), CHR$(179)
            COLOR 0, 3
            LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + 2: PRINT " Zapisz "
            LOCATE ramka_wiersz_poczatku + 1, ramka_kolumna_poczatku + 1: PRINT " Zostanie nadpisany ";
            LOCATE ramka_wiersz_poczatku + 2, ramka_kolumna_poczatku + 1: PRINT " plik mapa.txt.     ";
            LOCATE ramka_wiersz_poczatku + 3, ramka_kolumna_poczatku + 1: PRINT "     Na pewno?      ";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 1: PRINT "  Tak          Nie  ";
            COLOR 4, 3: 'czerwone litery
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 3: PRINT "T";
            LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 16: PRINT "N";
            koordynaty_kursora wiersz, kolumna
            'zdarzenia myszy
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 1 AND kolumna < ramka_kolumna_poczatku + 7 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 2: PRINT " Tak "; 'napis w negatywie
                IF liczba_rekordow_tabeli_mapy > 0 THEN 'wykluczenie mozliwosci zapisu pustej mapy
                    IF _MOUSEBUTTON(1) THEN
                        tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                        OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1
                        FOR nr_rekordu = 1 TO UBOUND(tabela_mapa)
                            WRITE #1, tabela_mapa(nr_rekordu).wiersz_znaku, tabela_mapa(nr_rekordu).kolumna_znaku, tabela_mapa(nr_rekordu).kolor_znaku, tabela_mapa(nr_rekordu).znak_kod
                        NEXT nr_rekordu
                        CLOSE #1
                        EXIT SUB
                    END IF
                ELSE
                    COLOR 4, 0: LOCATE 25, 1: PRINT "Nie mozna zapisac pustej mapy."; 'PRZENIESC TO NA PASEK KOMUNIKATOW
                END IF
            END IF
            IF wiersz = ramka_wiersz_poczatku + 4 AND kolumna > ramka_kolumna_poczatku + 14 AND kolumna < ramka_kolumna_poczatku + 20 THEN
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku + 4, ramka_kolumna_poczatku + 15: PRINT " Nie "; 'napis w negatywie
                IF _MOUSEBUTTON(1) THEN
                    tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
                    EXIT SUB
                END IF
            END IF
            IF (wiersz < ramka_wiersz_poczatku OR wiersz > ramka_wiersz_poczatku + ramka_liczba_wierszy + 1 OR kolumna < ramka_kolumna_poczatku OR kolumna > ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 1) AND _MOUSEBUTTON(1) AND (wiersz <> tymczasowy_wiersz OR kolumna <> tymczasowa_kolumna) THEN 'klikniecie poza ramka
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "T" OR klawisz$ = CHR$(13) THEN
            IF liczba_rekordow_tabeli_mapy > 0 THEN 'wykluczenie mozliwosci zapisu pustej mapy
                OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1
                FOR nr_rekordu = 1 TO UBOUND(tabela_mapa)
                    WRITE #1, tabela_mapa(nr_rekordu).wiersz_znaku, tabela_mapa(nr_rekordu).kolumna_znaku, tabela_mapa(nr_rekordu).kolor_znaku, tabela_mapa(nr_rekordu).znak_kod
                NEXT nr_rekordu
                CLOSE #1
                EXIT SUB
            ELSE
                COLOR 4, 0: LOCATE 25, 1: PRINT "Nie mozna zapisac pustej mapy."; 'PRZENIESC TO NA PASEK KOMUNIKATOW
            END IF
        END IF
        IF klawisz$ = "N" OR klawisz$ = CHR$(27) THEN EXIT SUB
    LOOP
END SUB

'$include: 'procedury.bi'
