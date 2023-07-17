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
    PRINT "  S::::::::S      T::T     A::A   A::A  C::::::::C J::::::::J  A::A   A::A      "
    PRINT "   SSSSSSSS       TTTT     AAAA   AAAA   CCCCCCCC   JJJJJJJJ   AAAA   AAAA      "
    PRINT "                                                                                "
    PRINT "                    symulator prowadzenia ruchu pociagow                        "
    PRINT "                                                                                "
END SUB

SUB tytul_menu (wiersz, kolumna)
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
END SUB
'''''''''''''''''''''''''' edytor map - tryb pelny '''''''''''''''''''''''''''''
SUB edytor_pelny_torowisko (wiersz, kolumna, tymczasowy_wiersz, tymczasowa_kolumna, znak$, kolor_znaku)
    COLOR 7, 1
    LOCATE 2, 70: PRINT " elementy  ";
    LOCATE 3, 70: PRINT " torowiska ";
    LOCATE 4, 70: PRINT "           "; 'proste tory
    LOCATE 5, 70: PRINT "           "; 'rozjazdy
    LOCATE 6, 70: PRINT "           "; 'uporki
    LOCATE 7, 70: PRINT "           "; 'wykolejnica i tarcze manewrowe
    LOCATE 8, 70: PRINT "           "; 'semafory
    LOCATE 9, 70: PRINT "           ";
    'DOKLEPAC WYBOR ELEMENTU KLAWISZEM + OPIS SKROTU W RAMCE
    DIM tabela_elementow_wiersz(18), tabela_elementow_kolumna(18), tabela_elementow_znak(18) 'tabela znakow do uzytku w edytorze
    'umieszczenie znakow w tabeli
    tabela_elementow_wiersz(1) = 4: tabela_elementow_kolumna(1) = 72: tabela_elementow_znak(1) = 45 '-
    tabela_elementow_wiersz(2) = 4: tabela_elementow_kolumna(2) = 74: tabela_elementow_znak(2) = 47 '/
    tabela_elementow_wiersz(3) = 4: tabela_elementow_kolumna(3) = 76: tabela_elementow_znak(3) = 124 '|
    tabela_elementow_wiersz(4) = 4: tabela_elementow_kolumna(4) = 78: tabela_elementow_znak(4) = 92 '\
    tabela_elementow_wiersz(5) = 5: tabela_elementow_kolumna(5) = 72: tabela_elementow_znak(5) = 192 'Ŕ
    tabela_elementow_wiersz(6) = 5: tabela_elementow_kolumna(6) = 74: tabela_elementow_znak(6) = 191 'ż
    tabela_elementow_wiersz(7) = 5: tabela_elementow_kolumna(7) = 76: tabela_elementow_znak(7) = 218 'Ú
    tabela_elementow_wiersz(8) = 5: tabela_elementow_kolumna(8) = 78: tabela_elementow_znak(8) = 217 'Ů
    tabela_elementow_wiersz(9) = 6: tabela_elementow_kolumna(9) = 72: tabela_elementow_znak(9) = 93 ']
    tabela_elementow_wiersz(10) = 6: tabela_elementow_kolumna(10) = 74: tabela_elementow_znak(10) = 91 '[
    tabela_elementow_wiersz(11) = 6: tabela_elementow_kolumna(11) = 78: tabela_elementow_znak(11) = 88 'X
    tabela_elementow_wiersz(12) = 7: tabela_elementow_kolumna(12) = 72: tabela_elementow_znak(12) = 94 '^
    tabela_elementow_wiersz(13) = 7: tabela_elementow_kolumna(13) = 74: tabela_elementow_znak(13) = 60 '<
    tabela_elementow_wiersz(14) = 7: tabela_elementow_kolumna(14) = 76: tabela_elementow_znak(14) = 62 '>
    tabela_elementow_wiersz(15) = 8: tabela_elementow_kolumna(15) = 72: tabela_elementow_znak(15) = 16 '
    tabela_elementow_wiersz(16) = 8: tabela_elementow_kolumna(16) = 74: tabela_elementow_znak(16) = 17 '
    tabela_elementow_wiersz(17) = 8: tabela_elementow_kolumna(17) = 76: tabela_elementow_znak(17) = 30 '
    tabela_elementow_wiersz(18) = 8: tabela_elementow_kolumna(18) = 78: tabela_elementow_znak(18) = 31 '
    FOR i = 1 TO 18
        IF wiersz = tabela_elementow_wiersz(i) AND kolumna = tabela_elementow_kolumna(i) THEN 'kursor na znaku
            COLOR 0, 3: LOCATE tabela_elementow_wiersz(i), tabela_elementow_kolumna(i): PRINT CHR$(tabela_elementow_znak(i)); 'znak w negatywie
            IF _MOUSEBUTTON(1) THEN
                znak$ = CHR$(tabela_elementow_znak(i)) 'klikniecie na znaku i zaladowanie go do zmiennej
                tymczasowy_wiersz = tabela_elementow_wiersz(i)
                tymczasowa_kolumna = tabela_elementow_kolumna(i)
            END IF
        ELSE
            COLOR 7, 1: LOCATE tabela_elementow_wiersz(i), tabela_elementow_kolumna(i): PRINT CHR$(tabela_elementow_znak(i)); 'znak zwykly
        END IF
    NEXT i
    COLOR 7, 1
    LOCATE 10, 70: PRINT "  kolor    ";
    LOCATE 11, 70: PRINT " elementu  ";
    COLOR 15: LOCATE 12, 70: PRINT " "; CHR$(219); CHR$(219); CHR$(219); CHR$(219); "      ";
    COLOR 14: LOCATE 12, 76: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
    IF wiersz = 12 AND kolumna > 70 AND kolumna < 75 AND _MOUSEBUTTON(1) THEN
        kolor_znaku = 15 'bialy - tor niezelektryfikowany
        tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
    END IF
    IF wiersz = 12 AND kolumna > 75 AND kolumna < 80 AND _MOUSEBUTTON(1) THEN
        kolor_znaku = 14 'zolty - tor zelektryfikowany
        tymczasowy_wiersz = wiersz: tymczasowa_kolumna = kolumna 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
    END IF
    IF wiersz = 12 AND kolumna > 70 AND kolumna < 75 THEN COLOR 7: LOCATE 12, 71: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219); 'podswietlenie wskazanego
    IF wiersz = 12 AND kolumna > 75 AND kolumna < 80 THEN COLOR 6: LOCATE 12, 76: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
    IF kolor_znaku = 15 THEN COLOR 0, 7: LOCATE 12, 71: PRINT "[": LOCATE 12, 74: PRINT "]"; 'zaznaczenie aktywnego
    IF kolor_znaku = 14 THEN COLOR 0, 6: LOCATE 12, 76: PRINT "[": LOCATE 12, 79: PRINT "]";
END SUB
''''''''''''''''''''''''''' procedury uniwersalne ''''''''''''''''''''''''''''''
SUB koordynaty_kursora (wiersz, kolumna)
    wiersz = _MOUSEY: kolumna = _MOUSEX
    'COLOR 4, 1: LOCATE 30, 56: PRINT "wiersz="; wiersz; 'OPCJA DEBUG
    'LOCATE 30, 67: PRINT ", kolumna="; kolumna; 'OPCJA DEBUG
END SUB

SUB mapa_koordynaty '(wiersz, kolumna)
    DO
        DO: _LIMIT 500
            koordynaty_kursora wiersz, kolumna
            rysuj_ramke 3, 3, 1, 18, 0, 3, CHR$(196), CHR$(196), CHR$(179)
            COLOR 0, 3: LOCATE 4, 4: PRINT " koordynaty kursora ";
        LOOP WHILE _MOUSEINPUT
    LOOP UNTIL wiersz <> 2 OR kolumna < 4 OR kolumna > 26
END SUB

SUB rysuj_ramke (ramka_wiersz_poczatku, ramka_kolumna_poczatku, ramka_liczba_wierszy, ramka_dlugosc_tekstu, ramka_kolor_znakow, ramka_kolor_tla, ramka_gora$, ramka_dol$, ramka_boki$)
    COLOR ramka_kolor_znakow, ramka_kolor_tla
    'narozniki ustalane automatycznie na podstawie ksztaltu bokow
    LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku 'lewy gorny naroznik
    IF ramka_gora$ = CHR$(196) AND ramka_boki$ = CHR$(179) THEN PRINT CHR$(218);
    IF ramka_gora$ = CHR$(205) AND ramka_boki$ = CHR$(179) THEN PRINT CHR$(213);
    IF ramka_gora$ = CHR$(205) AND ramka_boki$ = CHR$(186) THEN PRINT CHR$(201);
    LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3 'prawy gorny naroznik
    IF ramka_gora$ = CHR$(196) AND ramka_boki$ = CHR$(179) THEN PRINT CHR$(191);
    IF ramka_gora$ = CHR$(205) AND ramka_boki$ = CHR$(179) THEN PRINT CHR$(184);
    IF ramka_gora$ = CHR$(205) AND ramka_boki$ = CHR$(186) THEN PRINT CHR$(187);
    LOCATE ramka_wiersz_poczatku + ramka_liczba_wierszy + 1, ramka_kolumna_poczatku 'lewy dolny naroznik
    IF ramka_boki$ = CHR$(179) THEN PRINT CHR$(192);
    IF ramka_boki$ = CHR$(186) THEN PRINT CHR$(200);
    LOCATE ramka_wiersz_poczatku + ramka_liczba_wierszy + 1, ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3 'prawy dolny naroznik
    IF ramka_boki$ = CHR$(179) THEN PRINT CHR$(217);
    IF ramka_boki$ = CHR$(186) THEN PRINT CHR$(188);
    FOR i = 1 TO ramka_dlugosc_tekstu + 2 'rysuj poziome scianki ramki
        LOCATE ramka_wiersz_poczatku, ramka_kolumna_poczatku + i: PRINT ramka_gora$;
        LOCATE ramka_wiersz_poczatku + ramka_liczba_wierszy + 1, ramka_kolumna_poczatku + i: PRINT ramka_dol$;
    NEXT
    FOR i = 1 TO ramka_liczba_wierszy 'rysuj pionowe scianki ramki
        LOCATE ramka_wiersz_poczatku + i, ramka_kolumna_poczatku: PRINT ramka_boki$;
        LOCATE ramka_wiersz_poczatku + i, ramka_kolumna_poczatku + ramka_dlugosc_tekstu + 3: PRINT ramka_boki$;
    NEXT
END SUB

SUB spluczka 'czysci bufor myszy
    z = 0
    DO
        z = z + 1
    LOOP WHILE _MOUSEINPUT
END SUB
