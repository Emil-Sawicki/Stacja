_TITLE "Stacja"
'$EXEICON: 'iconfile.ico' 'adres i nazwa pliku otoczone pojedynczymi apostrofami
''''''''''''''''''''''''''''''''' ekran tytulowy '''''''''''''''''''''''''''''''
liczba_wierszy = 80: liczba_kolumn = 30
WIDTH liczba_wierszy, liczba_kolumn
DO: _LIMIT 500 'tytul_obsluga
    tytul_logo 'logo gry
    COLOR 4, 1: LOCATE 30, 1: PRINT "v1.0 (c) 2023 Emil Sawicki";
    klawisz$ = UCASE$(INKEY$)
    DO
        koordynaty_kursora wiersz, kolumna
        'tytul_menu 'rysowanie menu z podswietlaniem wskazanej opcji
        IF wiersz = 17 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis w negatywie
        ELSE
            COLOR 0, 7: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis zwykly
            COLOR 4: LOCATE 17, 36: PRINT "N" 'czerwona litera
        END IF
        IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis w negatywie
        ELSE
            COLOR 0, 7: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis zwykly
            COLOR 4: LOCATE 19, 36: PRINT "W" 'czerwona litera
        END IF
        IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 21, 31: PRINT "      Edytor      " 'napis w negatywie
        ELSE
            COLOR 0, 7: LOCATE 21, 31: PRINT "      Edytor      " 'napis zwykly
            COLOR 4: LOCATE 21, 37: PRINT "E" 'czerwona litera
        END IF
        IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 THEN 'kursor na napisie
            COLOR 7, 0: LOCATE 23, 31: PRINT "      Koniec      " 'napis w negatywie
        ELSE
            COLOR 0, 7: LOCATE 23, 31: PRINT "      Koniec      " 'napis zwykly
            COLOR 4: LOCATE 23, 37: PRINT "K" 'czerwona litera
        END IF
        'zdarzenia myszy
        IF wiersz = 17 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_nowagra 'submenu "Nowa gra"
        'IF wiersz = 19 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_wczytaj
        'IF wiersz = 21 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN tytul_menu_edytor
        IF wiersz = 23 AND kolumna > 30 AND kolumna < 49 AND _MOUSEBUTTON(1) THEN SYSTEM
    LOOP WHILE _MOUSEINPUT
    'zdarzenia klawiatury
    IF klawisz$ = "N" THEN tytul_menu_nowagra
    'IF klawisz$ = "W" THEN tytul_menu_wczytaj
    'IF klawisz$ = "W" THEN tytul_menu_edytor
    IF klawisz$ = "K" OR klawisz$ = CHR$(27) THEN SYSTEM
LOOP
'''''''''''''''''''''''''''''' gra - tryb pelny ''''''''''''''''''''''''''''''''
'WIDTH 80, 25 'zmiana wymiarow okna gry zaleznie od wielkosci zaladowanej mapy
SUB gra_tryb_pelny
    gra_pelny_sprawdzanie_plikow
    DO: _LIMIT 500 'gra_obsluga_pelny
        COLOR 0, 7: LOCATE 1, 1: PRINT "  Plik  Pociagi  Sklady  Rozklad  Przebiegi                                     "; 'gra_pasek_menu
        COLOR 4: LOCATE 1, 6: PRINT "k": LOCATE 1, 9: PRINT "P": LOCATE 1, 18: PRINT "S": LOCATE 1, 26: PRINT "R" 'czerwone litery
        gra_pelny_mapa
        'gra_pelny_pociag
        'gra_pelny_semafor
        'gra_pelny_komunikaty
        klawisz$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            'mysz
            IF kolumna > 1 AND kolumna < 6 AND wiersz = 1 AND _MOUSEBUTTON(1) THEN gra_menu_plik x
            IF kolumna > 6 AND kolumna < 14 AND wiersz = 1 AND _MOUSEBUTTON(1) THEN gra_pelny_okno_pociagi
        LOOP WHILE _MOUSEINPUT
        'klawiatura
        IF klawisz$ = "K" THEN gra_menu_plik x
        IF x = 1 THEN EXIT SUB 'przy kliknieciu w menu opcji "Koniec" ustawiana jest zmienna x, ktora wychodzi z TEJ petli
        IF klawisz$ = "P" THEN gra_pelny_okno_pociagi
    LOOP
END SUB
'''''''''''''''''''''''''''' gra - tryb uproszczony ''''''''''''''''''''''''''''
'''''''''''''''''''''''''''' edytor map - tryb pelny '''''''''''''''''''''''''''
'wybor edytora - nowa mapa lub istniejaca
'WIDTH 80, 25 'zmiana wymiarow okna
'''''''''''''''''''''''' edytor map - tryb uproszczony '''''''''''''''''''''''''
'wybor edytora - nowa mapa lub istniejaca
'WIDTH 80, 25 'zmiana wymiarow okna
''''''''''''''''''''''''''''''''' edytor taboru ''''''''''''''''''''''''''''''''

''''''''''''''''''''''''''''''''''' procedury ''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''' ekrany tytulowy ''''''''''''''''''''''''''''''''
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
    PRINT "  S::::::::S      T::T     A::A   A::A  C::::::::C J:::::::::J A::A   A::A      "
    PRINT "   SSSSSSSS       TTTT     AAAA   AAAA   CCCCCCCC   JJJJJJJJJ  AAAA   AAAA      "
    PRINT "                                                                                "
    PRINT "                    symulator prowadzenia ruchu pociagow                        "
    PRINT "                                                                                "
END SUB

'SUB tytul_menu 'ekran tytulowy - glowne menu
'END SUB

SUB tytul_menu_nowagra 'ekran tytulowy - submenu "Nowa gra"
    DO: _LIMIT 500
        klawisz$ = UCASE$(INKEY$)
        DO
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
                DO 'czyszczenie bufora myszy
                    DO WHILE _MOUSEINPUT
                        koordynaty_kursora wiersz, kolumna
                        SLEEP 1
                        EXIT SUB
                    LOOP
                LOOP UNTIL _MOUSEBUTTON(1) = 0
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
'''''''''''''''''''''''''''''' gra - oba tryby '''''''''''''''''''''''''''''''''
SUB gra_menu_plik (x)
    x = 0 ' zmienna potrzebna do zakonczenia gry po wybraniu opcji "Koniec"
    wiersz_poczatku_ramki = 2
    kolumna_poczatku_ramki = 1
    liczba_wierszy_menu = 4
    dlugosc_tekstu_ramki = 8
    rysuj_ramke wiersz_poczatku_ramki, kolumna_poczatku_ramki, liczba_wierszy_menu, dlugosc_tekstu_ramki
    COLOR 7, 0: LOCATE 1, 2: PRINT " Plik " 'odwroc kolory w nazwie otwartego menu
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie menu
    DO: _LIMIT 500
        klawisz$ = UCASE$(INKEY$)
        DO
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
            IF (kolumna > kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3 OR wiersz > wiersz_poczatku_ramki + liczba_wierszy_menu + 1) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
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
'''''''''''''''''''''''''''''' gra - tryb pelny ''''''''''''''''''''''''''''''''
SUB gra_pelny_sprawdzanie_plikow
    CLS , 0
    CHDIR "D:\Gry\transportowe\Stacja\tryb pelny\Przykladowa Stacja" 'wejdz do folderu danej stacji
    IF _FILEEXISTS("mapa.txt") THEN
        COLOR 10, 0: LOCATE 1, 1: PRINT "Plik mapy istnieje."
    ELSE
        COLOR 12, 0: LOCATE 1, 1: PRINT "Plik mapy nie istnieje."
    END IF
    SLEEP 1
END SUB

SUB gra_pelny_okno_pociagi
    wiersz_poczatku_ramki = 3
    kolumna_poczatku_ramki = 7
    liczba_wierszy_menu = 1
    dlugosc_tekstu_ramki = 7
    rysuj_ramke_okna wiersz_poczatku_ramki, kolumna_poczatku_ramki, liczba_wierszy_menu, dlugosc_tekstu_ramki
    'odwroc kolory w nazwie otwartego okna
    COLOR 7, 0: LOCATE 1, 8: PRINT " Pociagi "
    'zawartosc okna
    COLOR 0, 7: LOCATE wiersz_poczatku_ramki + 1, kolumna_poczatku_ramki + 2: PRINT "Pociagi "
    'petla obslugi klawiatury i myszy - wybor opcji lub zamkniecie okna
    DO: _LIMIT 500
        klawisz$ = UCASE$(INKEY$)
        DO
            koordynaty_kursora wiersz, kolumna
            IF wiersz = wiersz_poczatku_ramki AND kolumna = kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 2 THEN 'kursor na przycisku
                COLOR 7, 0: LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 2: PRINT "X" 'przycisk w negatywie
            ELSE
                COLOR 4, 7: LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 2: PRINT "X" 'czerwona litera
            END IF
            'klikniecie przycisku zamkniecia
            IF wiersz = wiersz_poczatku_ramki AND kolumna = kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 2 AND _MOUSEBUTTON(1) THEN
                EXIT SUB
            END IF
            'klikniecie poza oknem
            IF (kolumna < kolumna_poczatku_ramki OR kolumna > kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3 OR wiersz < wiersz_poczatku_ramki OR wiersz > wiersz_poczatku_ramki + liczba_wierszy_menu + 1) AND _MOUSEBUTTON(1) THEN
                EXIT SUB
            END IF
        LOOP WHILE _MOUSEINPUT
        'zdarzenia klawiatury
        IF klawisz$ = "X" OR klawisz$ = CHR$(27) THEN
            EXIT SUB
        END IF
    LOOP
END SUB

SUB gra_pelny_mapa
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

'SUB semafor
'
'END SUB
''''''''''''''''''''''''''' procedury uniwersalne ''''''''''''''''''''''''''''''
SUB koordynaty_kursora (wiersz, kolumna)
    wiersz = _MOUSEY: kolumna = _MOUSEX
    LOCATE 30, 50: PRINT _MOUSEBUTTON(1);
    COLOR 4, 1: LOCATE 30, 56: PRINT "wiersz="; wiersz;
    LOCATE 30, 67: PRINT ", kolumna="; kolumna;
END SUB

SUB rysuj_ramke (wiersz_poczatku_ramki, kolumna_poczatku_ramki, liczba_wierszy_menu, dlugosc_tekstu_ramki)
    COLOR 0, 7 'kolory ramki i jej tla
    'rysuj narozniki ramki
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki: PRINT "Ú"
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "¿"
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki: PRINT "À"
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "Ù"
    'rysuj poziome scianki ramki
    FOR i = 1 TO dlugosc_tekstu_ramki + 2
        LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + i: PRINT "Ä"
        LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + i: PRINT "Ä"
    NEXT
    'rysuj pionowe scianki ramki
    FOR i = 1 TO liczba_wierszy_menu
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki: PRINT "³"
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "³"
    NEXT
END SUB

SUB rysuj_ramke_okna (wiersz_poczatku_ramki, kolumna_poczatku_ramki, liczba_wierszy_menu, dlugosc_tekstu_ramki)
    COLOR 0, 7 'kolory ramki i jej tla
    'rysuj narozniki ramki
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki: PRINT "Õ"
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "¸"
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki: PRINT "À"
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "Ù"
    'rysuj gorna krawedz okna
    FOR i = 1 TO dlugosc_tekstu_ramki + 2
        LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + i: PRINT "Í"
    NEXT
    'rysuj dolna krawedz okna
    FOR i = 1 TO dlugosc_tekstu_ramki + 2
        LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + i: PRINT "Ä"
    NEXT
    'rysuj pionowe scianki okna
    FOR i = 1 TO liczba_wierszy_menu
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki: PRINT "³"
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "³"
    NEXT
END SUB
