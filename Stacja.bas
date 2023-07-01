_TITLE "Stacja"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
_CONTROLCHR OFF 'umozliwia wypisywanie na ekranie znakow kontrolnych
folder_gry$ = "D:\Gry\transportowe\Stacja\" 'doklepac setup
''''''''''''''''''''''''''''''''' ekran tytulowy '''''''''''''''''''''''''''''''
liczba_wierszy = 80: liczba_kolumn = 30
WIDTH liczba_wierszy, liczba_kolumn
DO
    tytul_logo 'logo gry
    COLOR 4, 1: LOCATE 30, 1: PRINT "v1.0 (c) 2023 Emil Sawicki";
    klawisz$ = UCASE$(INKEY$)
    DO: _LIMIT 500
        koordynaty_kursora wiersz, kolumna
        tytul_menu wiersz, kolumna 'rysowanie menu z podswietlaniem wskazanej opcji
        'zdarzenia myszy
        IF wiersz = 17 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_nowagra tymczasowa_kolumna 'submenu "Nowa gra"
        'IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_wczytaj
        IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_edytor tymczasowa_kolumna
        IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) AND kolumna <> tymczasowa_kolumna THEN SYSTEM
    LOOP WHILE _MOUSEINPUT
    'zdarzenia klawiatury
    IF klawisz$ = "N" THEN tytul_menu_nowagra tymczasowa_kolumna
    'IF klawisz$ = "W" THEN tytul_menu_wczytaj
    IF klawisz$ = "E" THEN tytul_menu_edytor tymczasowa_kolumna
    IF klawisz$ = "K" OR klawisz$ = CHR$(27) THEN SYSTEM
LOOP

SUB tytul_menu_nowagra (tymczasowa_kolumna) 'ekran tytulowy - submenu "Nowa gra"
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
                gra_tryb_pelny
                EXIT SUB 'po zakonczeniu gry powrot do glownego menu
            END IF
            'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN
            '    gra_tryb_uproszczony
            'EXIT SUB
            'END IF
            IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN 'wstecz
                tymczasowa_kolumna = kolumna
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'klawiatura
        IF klawisz$ = "P" THEN
            gra_tryb_pelny
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
                edytor_tryb_pelny
                EXIT SUB 'po zakonczeniu gry powrot do glownego menu
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
            edytor_tryb_pelny
            EXIT SUB 'po zakonczeniu gry powrot do glownego menu
        END IF
        'IF klawisz$ = "U" THEN
        '    edytor_tryb_uproszczony
        'EXIT SUB
        'END IF
        IF klawisz$ = "W" OR klawisz$ = CHR$(27) THEN EXIT SUB
    LOOP
END SUB
'''''''''''''''''''''''''''''' gra - tryb pelny ''''''''''''''''''''''''''''''''
SUB gra_tryb_pelny
    gra_tryb_pelny_sprawdzanie_plikow
    'WIDTH 80, 25 'zmiana wymiarow okna gry zaleznie od wielkosci zaladowanej mapy
    DO
        COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Pociagi  Sklady  Rozklad  Przebiegi                                     "; 'gra_pasek_menu
        COLOR 4: LOCATE 1, 6: PRINT "k": LOCATE 1, 9: PRINT "P": LOCATE 1, 18: PRINT "S": LOCATE 1, 26: PRINT "R" 'czerwone litery
        gra_tryb_pelny_mapa
        'gra_pelny_pociag
        'gra_pelny_semafor
        'gra_pelny_komunikaty
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            'mysz
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
    ramka_wiersz_poczatku% = 2
    ramka_kolumna_poczatku% = 1
    ramka_liczba_wierszy% = 4
    ramka_dlugosc_tekstu% = 8
    ramka_kolor_znakow% = 0: ramka_kolor_tla% = 7
    ramka_gora$ = CHR$(196): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
    rysuj_ramke ramka_wiersz_poczatku%, ramka_kolumna_poczatku%, ramka_liczba_wierszy%, ramka_dlugosc_tekstu%, ramka_kolor_znakow%, ramka_kolor_tla%, ramka_gora$, ramka_dol$, ramka_boki$
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
            IF (kolumna > ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 3 OR wiersz > ramka_wiersz_poczatku% + ramka_liczba_wierszy% + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
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
    ramka_wiersz_poczatku% = 3
    ramka_kolumna_poczatku% = 7
    ramka_liczba_wierszy% = 1
    ramka_dlugosc_tekstu% = 7
    ramka_kolor_znakow% = 0: ramka_kolor_tla% = 7
    ramka_gora$ = CHR$(205): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
    rysuj_ramke ramka_wiersz_poczatku%, ramka_kolumna_poczatku%, ramka_liczba_wierszy%, ramka_dlugosc_tekstu%, ramka_kolor_znakow%, ramka_kolor_tla%, ramka_gora$, ramka_dol$, ramka_boki$
    COLOR 7, 0: LOCATE 1, 8: PRINT " Pociagi " 'odwroc kolory w nazwie otwartego okna
    'zawartosc okna
    COLOR 0, 7: LOCATE ramka_wiersz_poczatku% + 1, ramka_kolumna_poczatku% + 2: PRINT "Pociagi "
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie okna
    DO
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            IF wiersz = ramka_wiersz_poczatku% AND kolumna = ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 2 THEN 'kursor na przycisku
                COLOR 7, 0: LOCATE ramka_wiersz_poczatku%, ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 2: PRINT "X" 'przycisk w negatywie
            ELSE
                COLOR 4, 7: LOCATE ramka_wiersz_poczatku%, ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 2: PRINT "X" 'czerwona litera
            END IF
            'klikniecie przycisku zamkniecia
            IF wiersz = ramka_wiersz_poczatku% AND kolumna = ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 2 AND _MOUSEBUTTON(1) THEN
                EXIT SUB
            END IF
            'klikniecie poza oknem
            IF (wiersz < ramka_wiersz_poczatku% OR wiersz > ramka_wiersz_poczatku% + ramka_liczba_wierszy% + 1 OR kolumna < ramka_kolumna_poczatku% OR kolumna > ramka_kolumna_poczatku% + ramka_dlugosc_tekstu% + 3) AND _MOUSEBUTTON(1) THEN
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
'''''''''''''''''''''''''''' gra - tryb uproszczony ''''''''''''''''''''''''''''
'''''''''''''''''''''''''''' edytor map - tryb pelny '''''''''''''''''''''''''''
'wybor edytora - nowa mapa lub istniejaca
SUB edytor_tryb_pelny
    CLS , 0
    'edytor_tryb_pelny_sprawdzanie_plikow
    wysokosc_mapy% = 25: szerokosc_mapy% = 50 'domyslne wymiary nowej mapy
    pojemnosc_tabeli_mapy% = wysokosc_mapy% * szerokosc_mapy%
    kolor_znaku% = 15: kolor_tla% = 0 'domyslne kolory: bialy i czarny
    'deklaracja tabeli
    DIM tabela_wiersz_znaku(1 TO pojemnosc_tabeli_mapy%), tabela_kolumna_znaku(1 TO pojemnosc_tabeli_mapy%), tabela_kolor_znaku(1 TO pojemnosc_tabeli_mapy%), tabela_znak(1 TO pojemnosc_tabeli_mapy%)
    liczba_rekordow_tabeli_mapy% = 0 'domyslnie tabela jest pusta, zmienna potrzebna do wyswietlenia pustej mapy na poczatku edycji
    DO
        COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik                                                                          ";
        COLOR 4: LOCATE 1, 6: PRINT "k"; 'czerwone litery
        wiersz_poczatku_mapy% = 2: kolumna_poczatku_mapy% = 2 'koordynaty poczatku mapy
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            ramka_gora$ = CHR$(205): ramka_dol$ = CHR$(205): ramka_boki$ = CHR$(186)
            rysuj_ramke 2, 1, 23, 65, 0, 3, ramka_gora$, ramka_dol$, ramka_boki$ 'ramka mapy
            'obliczanie pozycji kursora na mapie
            wiersz_mapy% = wiersz - wiersz_poczatku_mapy% - 1
            kolumna_mapy% = kolumna + kolumna_poczatku_mapy% - 3
            'wyswietlanie pozycji kursora na mapie
            IF wiersz_mapy% < 1 THEN wiersz_mapy% = 1
            IF wiersz_mapy% > 40 THEN wiersz_mapy% = 40
            IF kolumna_mapy% < 1 THEN kolumna_mapy% = 1
            IF kolumna_mapy% > 60 THEN kolumna_mapy% = 60
            COLOR 0, 7: LOCATE 2, 3: PRINT " wiersz:   ": LOCATE 2, 11: PRINT wiersz_mapy%;
            LOCATE 2, 14: PRINT ", kolumna:    ": LOCATE 2, 24: PRINT kolumna_mapy%;
            IF wiersz = 2 AND kolumna > 3 AND kolumna < 27 THEN
                ramka_gora$ = CHR$(196): ramka_dol$ = CHR$(196): ramka_boki$ = CHR$(179)
                rysuj_ramke 3, 3, 1, 18, 0, 3, ramka_gora$, ramka_dol$, ramka_boki$ 'etykieta
                COLOR 0, 7: LOCATE 4, 4: PRINT " koordynaty kursora ";
            END IF
            'IF kolumna > 1 AND kolumna < 6 AND wiersz = 1 AND _MOUSEBUTTON(1) THEN edytor_menu_plik x
            COLOR 7, 0 'interfejs zmiany wielkosci mapy: strzalki i pola tekstowe
            LOCATE 2, 36: PRINT CHR$(17): LOCATE 2, 41: PRINT CHR$(16); 'szerokosc mapy
            LOCATE 2, 43: PRINT CHR$(31): LOCATE 2, 48: PRINT CHR$(30); 'wysokosc mapy
            'wprowadzenie przez gracza wielkosci mapy
            IF wiersz = 2 AND kolumna = 36 AND _MOUSEBUTTON(1) THEN szerokosc_mapy% = szerokosc_mapy% - 1 'strzalka w lewo
            IF wiersz = 2 AND kolumna = 41 AND _MOUSEBUTTON(1) THEN szerokosc_mapy% = szerokosc_mapy% + 1 'strzalka w prawo
            IF wiersz = 2 AND kolumna = 43 AND _MOUSEBUTTON(1) THEN wysokosc_mapy% = wysokosc_mapy% - 1 'strzalka w dol
            IF wiersz = 2 AND kolumna = 48 AND _MOUSEBUTTON(1) THEN wysokosc_mapy% = wysokosc_mapy% + 1 'strzalka w gore
            COLOR 7, 0 'wyswietlanie wymiarow
            LOCATE 2, 37: PRINT szerokosc_mapy%: LOCATE 2, 44: PRINT wysokosc_mapy%;
            'zdarzenia myszy
            edytor_pelny_torowisko wiersz, kolumna, znak$, kolor_znaku% 'wyswietlanie tablicy znakow i ladowanie znaku do zmiennej 'znak$'
            'edytor_pelny_torowisko_kolor_znaku wiersz, kolumna, kolor_znaku%
            'edytor_tryb_pelny_kolor_tla kolor_tla% 'ustaw kolor tla z palety
            IF wiersz > 2 AND wiersz < 25 AND kolumna > 1 AND kolumna < 69 AND _MOUSEBUTTON(1) AND znak$ <> "" AND (wiersz <> tymczasowy_wiersz OR kolumna <> tymczasowa_kolumna) THEN 'klikniecie w ramce mapy
                nr_rekordu% = liczba_rekordow_tabeli_mapy% + 1 'numer nowego rekordu
                tabela_wiersz_znaku(nr_rekordu%) = wiersz_mapy%
                tabela_kolumna_znaku(nr_rekordu%) = kolumna_mapy%
                tabela_kolor_znaku(nr_rekordu%) = kolor_znaku%
                tabela_znak(nr_rekordu%) = ASC(znak$)
                liczba_rekordow_tabeli_mapy% = nr_rekordu% 'aktualizuje liczbe rekordow
                tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'zmienne do zablokowania IFa dopoki gracz nie poruszy mysza
                OPEN folder_gry$ + "tryb pelny\Przykladowa Stacja\mapa.txt" FOR OUTPUT AS #1 'zapisanie tabeli do pliku
                FOR nr_rekordu% = 1 TO liczba_rekordow_tabeli_mapy%
                    WRITE #1, tabela_wiersz_znaku(nr_rekordu%), tabela_kolumna_znaku(nr_rekordu%), tabela_kolor_znaku(nr_rekordu%), tabela_znak(nr_rekordu%)
                NEXT nr_rekordu%
                CLOSE #1
            END IF
            'wyswietlanie mapy z tabeli
            IF liczba_rekordow_tabeli_mapy% > 0 THEN 'tylko jesli cokolwiek do niej wpisano
                FOR i = 1 TO liczba_rekordow_tabeli_mapy%
                    COLOR tabela_kolor_znaku(i), 0: LOCATE tabela_wiersz_znaku(i) + 3, tabela_kolumna_znaku(i) + 1: PRINT CHR$(tabela_znak(i));
                NEXT i
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        'IF klawisz$ = "K" THEN edytor_menu_plik x
        IF x = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
    LOOP
END SUB
'''''''''''''''''''''''' edytor map - tryb uproszczony '''''''''''''''''''''''''
'wybor edytora - nowa mapa lub istniejaca
''''''''''''''''''''''''''''''''' edytor taboru ''''''''''''''''''''''''''''''''
'$include: 'procedury.bi'
