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
SUB edytor_tryb_pelny_tablica_znakow (wiersz, kolumna, znak$)
    COLOR 7, 1
    LOCATE 2, 70: PRINT " elementy  "
    LOCATE 3, 70: PRINT " torowiska "
    LOCATE 4, 70: PRINT "           "; 'proste tory
    LOCATE 5, 70: PRINT "           "; 'rozjazdy
    LOCATE 6, 70: PRINT "           "; 'uporki
    LOCATE 7, 70: PRINT "           "; 'wykolejnica i tarcze manewrowe
    LOCATE 8, 70: PRINT "           "; 'semafory
    'DOKLEPAC WYBOR ELEMENTU KLAWISZEM + OPIS SKROTU W RAMCE
    IF wiersz = 4 AND kolumna = 72 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 4, 72: PRINT "-" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "-"
    ELSE
        COLOR 7, 1: LOCATE 4, 72: PRINT "-" 'znak zwykly
    END IF
    IF wiersz = 4 AND kolumna = 74 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 4, 74: PRINT "/" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "/"
    ELSE
        COLOR 7, 1: LOCATE 4, 74: PRINT "/" 'znak zwykly
    END IF
    IF wiersz = 4 AND kolumna = 76 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 4, 76: PRINT "|" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "|"
    ELSE
        COLOR 7, 1: LOCATE 4, 76: PRINT "|" 'znak zwykly
    END IF
    IF wiersz = 4 AND kolumna = 78 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 4, 78: PRINT "\" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "\"
    ELSE
        COLOR 7, 1: LOCATE 4, 78: PRINT "\" 'znak zwykly
    END IF
    IF wiersz = 5 AND kolumna = 72 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 5, 72: PRINT "À" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "À"
    ELSE
        COLOR 7, 1: LOCATE 5, 72: PRINT "À" 'znak zwykly
    END IF
    IF wiersz = 5 AND kolumna = 74 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 5, 74: PRINT "¿" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "¿"
    ELSE
        COLOR 7, 1: LOCATE 5, 74: PRINT "¿" 'znak zwykly
    END IF
    IF wiersz = 5 AND kolumna = 76 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 5, 76: PRINT "Ú" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "Ú"
    ELSE
        COLOR 7, 1: LOCATE 5, 76: PRINT "Ú" 'znak zwykly
    END IF
    IF wiersz = 5 AND kolumna = 78 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 5, 78: PRINT "Ù" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "Ù"
    ELSE
        COLOR 7, 1: LOCATE 5, 78: PRINT "Ù" 'znak zwykly
    END IF
    IF wiersz = 6 AND kolumna = 72 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 6, 72: PRINT "]" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "]"
    ELSE
        COLOR 7, 1: LOCATE 6, 72: PRINT "]" 'znak zwykly
    END IF
    IF wiersz = 6 AND kolumna = 74 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 6, 74: PRINT "[" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "["
    ELSE
        COLOR 7, 1: LOCATE 6, 74: PRINT "[" 'znak zwykly
    END IF
    IF wiersz = 7 AND kolumna = 72 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 7, 72: PRINT "^" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "^"
    ELSE
        COLOR 7, 1: LOCATE 7, 72: PRINT "^" 'znak zwykly
    END IF
    IF wiersz = 7 AND kolumna = 74 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 7, 74: PRINT "<" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = "<"
    ELSE
        COLOR 7, 1: LOCATE 7, 74: PRINT "<" 'znak zwykly
    END IF
    IF wiersz = 7 AND kolumna = 76 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 7, 76: PRINT ">" 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = ">"
    ELSE
        COLOR 7, 1: LOCATE 7, 76: PRINT ">" 'znak zwykly
    END IF
    IF wiersz = 8 AND kolumna = 72 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 8, 72: PRINT CHR$(16) 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = CHR$(16)
    ELSE
        COLOR 7, 1: LOCATE 8, 72: PRINT CHR$(16) 'znak zwykly
    END IF
    IF wiersz = 8 AND kolumna = 74 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 8, 74: PRINT CHR$(17) 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = CHR$(17)
    ELSE
        COLOR 7, 1: LOCATE 8, 74: PRINT CHR$(17) 'znak zwykly
    END IF
    IF wiersz = 8 AND kolumna = 76 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 8, 76: PRINT CHR$(30) 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = CHR$(30)
    ELSE
        COLOR 7, 1: LOCATE 8, 76: PRINT CHR$(30) 'znak zwykly
    END IF
    IF wiersz = 8 AND kolumna = 78 THEN 'kursor na znaku
        COLOR 0, 3: LOCATE 8, 78: PRINT CHR$(31) 'znak w negatywie
        IF _MOUSEBUTTON(1) THEN znak$ = CHR$(31)
    ELSE
        COLOR 7, 1: LOCATE 8, 78: PRINT CHR$(31) 'znak zwykly
    END IF
END SUB
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

SUB rysuj_ramke_podwojna (wiersz_poczatku_ramki, kolumna_poczatku_ramki, liczba_wierszy_menu, dlugosc_tekstu_ramki, kolor_znakow, kolor_tla)
    COLOR kolor_znakow, kolor_tla
    'rysuj narozniki ramki
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki: PRINT "É";
    LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "»";
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki: PRINT "È";
    LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "¼";
    'rysuj poziome scianki ramki
    FOR i = 1 TO dlugosc_tekstu_ramki + 2
        LOCATE wiersz_poczatku_ramki, kolumna_poczatku_ramki + i: PRINT "Í";
        LOCATE wiersz_poczatku_ramki + liczba_wierszy_menu + 1, kolumna_poczatku_ramki + i: PRINT "Í";
    NEXT
    'rysuj pionowe scianki ramki
    FOR i = 1 TO liczba_wierszy_menu
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki: PRINT "º";
        LOCATE wiersz_poczatku_ramki + i, kolumna_poczatku_ramki + dlugosc_tekstu_ramki + 3: PRINT "º";
    NEXT
END SUB
