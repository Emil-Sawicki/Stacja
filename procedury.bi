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

SUB tytul_menu (Y, X)
    IF Y = 17 AND X > 30 AND X < 49 THEN 'kursor na napisie
        COLOR 7, 0: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis w negatywie
    ELSE
        COLOR 0, 7: LOCATE 17, 31: PRINT "     Nowa gra     " 'napis zwykly
        COLOR 4: LOCATE 17, 36: PRINT "N" 'czerwona litera
    END IF
    IF Y = 19 AND X > 30 AND X < 49 THEN 'kursor na napisie
        COLOR 7, 0: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis w negatywie
    ELSE
        COLOR 0, 7: LOCATE 19, 31: PRINT "     Wczytaj      " 'napis zwykly
        COLOR 4: LOCATE 19, 36: PRINT "W" 'czerwona litera
    END IF
    IF Y = 21 AND X > 30 AND X < 49 THEN 'kursor na napisie
        COLOR 7, 0: LOCATE 21, 31: PRINT "      Edytor      " 'napis w negatywie
    ELSE
        COLOR 0, 7: LOCATE 21, 31: PRINT "      Edytor      " 'napis zwykly
        COLOR 4: LOCATE 21, 37: PRINT "E" 'czerwona litera
    END IF
    IF Y = 23 AND X > 30 AND X < 49 THEN 'kursor na napisie
        COLOR 7, 0: LOCATE 23, 31: PRINT "      Koniec      " 'napis w negatywie
    ELSE
        COLOR 0, 7: LOCATE 23, 31: PRINT "      Koniec      " 'napis zwykly
        COLOR 4: LOCATE 23, 37: PRINT "K" 'czerwona litera
    END IF
END SUB
'------------------------------------------------------------------------------'
'                      PROCEDURY - EDYTOR MAP - TRYB PELNY                     '
'------------------------------------------------------------------------------'
SUB edytor_pelny_menu_wybor_warstwy (TempY, TempX, FullEditLayer) 'menu otwierane w edytorze w celu zmiany warstwy
    DO
        FramePosY = 2: FramePosX = 7
        FrameLinesCount = 2: FrameTxtLength = 16
        FrameCharColor = 0: FrameBackColor = 7
        FrameTop$ = CHR$(196): FrameBottom$ = CHR$(196): FrameSide$ = CHR$(179)
        rysuj_ramke FramePosY, FramePosX, FrameLinesCount, FrameTxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$
        COLOR 8, 0: LOCATE 1, 8: PRINT " Warstwy " 'odwroc kolory w nazwie otwartego menu
        Key$ = UCASE$(INKEY$)
        DO: _LIMIT 500
            koordynaty_kursora Y, X
            IF X > 7 AND X < 17 THEN 'kursor w ramce
                IF Y = 3 THEN
                    COLOR 7, 0: LOCATE 3, 8: PRINT " Schemat torow    "; 'napis w negatywie
                    IF _MOUSEBUTTON(1) THEN warstwa = 1 'rysowanie schematu
                ELSE
                    COLOR 0, 7: LOCATE 3, 8: PRINT " Schemat torow    "; 'napis zwykly
                    COLOR 4: LOCATE 3, 9: PRINT "S"; 'czerwona litera
                END IF
                IF Y = 4 THEN
                    COLOR 7, 0: LOCATE 4, 8: PRINT " Oznaczanie torow "; 'napis w negatywie
                    IF _MOUSEBUTTON(1) THEN warstwa = 2 'oznaczanie torow
                ELSE
                    COLOR 0, 7: LOCATE 4, 8: PRINT " Oznaczanie torow "; 'napis zwykly
                    COLOR 4: LOCATE 4, 9: PRINT "O"; 'czerwona litera
                END IF
            END IF
            IF (X > FramePosX + FrameTxtLength + 3 OR X < FramePosX OR Y = 1 OR Y > FramePosY + FrameLinesCount + 1) AND (Y <> TempY OR X <> TempX) AND _MOUSEBUTTON(1) THEN 'klikniecie poza menu
                CLS , 0
                EXIT SUB
            END IF
        LOOP UNTIL _MOUSEINPUT
        'zdarzenia klawiatury
        IF Key$ = "S" THEN
            ' edytor_pelny_uruchamianie_warstwy
            EXIT SUB 'zamknie menu po wybraniu warstwy
        END IF
        IF Key$ = "O" THEN
            ' edytor_pelny_uruchamianie_warstwy
            EXIT SUB 'zamknie menu po wybraniu warstwy
        END IF
        IF Key$ = CHR$(27) THEN 'Esc
            CLS , 0
            EXIT SUB 'zamkniecie menu
        END IF
    LOOP
END SUB

SUB edytor_pelny_torowisko (Y, X, TempY, TempX, Char$, CharColor)
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
    DIM TableElemsY(18), TableElemsX(18), TableElemsChar(18) 'tabela znakow do uzytku w edytorze
    'umieszczenie znakow w tabeli
    TableElemsY(1) = 4: TableElemsX(1) = 72: TableElemsChar(1) = 45 '-
    TableElemsY(2) = 4: TableElemsX(2) = 74: TableElemsChar(2) = 47 '/
    TableElemsY(3) = 4: TableElemsX(3) = 76: TableElemsChar(3) = 124 '|
    TableElemsY(4) = 4: TableElemsX(4) = 78: TableElemsChar(4) = 92 '\
    TableElemsY(5) = 5: TableElemsX(5) = 72: TableElemsChar(5) = 192 'À
    TableElemsY(6) = 5: TableElemsX(6) = 74: TableElemsChar(6) = 191 '¿
    TableElemsY(7) = 5: TableElemsX(7) = 76: TableElemsChar(7) = 218 'Ú
    TableElemsY(8) = 5: TableElemsX(8) = 78: TableElemsChar(8) = 217 'Ù
    TableElemsY(9) = 6: TableElemsX(9) = 72: TableElemsChar(9) = 93 ']
    TableElemsY(10) = 6: TableElemsX(10) = 74: TableElemsChar(10) = 91 '[
    TableElemsY(11) = 6: TableElemsX(11) = 78: TableElemsChar(11) = 88 'X
    TableElemsY(12) = 7: TableElemsX(12) = 72: TableElemsChar(12) = 94 '^
    TableElemsY(13) = 7: TableElemsX(13) = 74: TableElemsChar(13) = 60 '<
    TableElemsY(14) = 7: TableElemsX(14) = 76: TableElemsChar(14) = 62 '>
    TableElemsY(15) = 8: TableElemsX(15) = 72: TableElemsChar(15) = 16 '
    TableElemsY(16) = 8: TableElemsX(16) = 74: TableElemsChar(16) = 17 '
    TableElemsY(17) = 8: TableElemsX(17) = 76: TableElemsChar(17) = 30 '
    TableElemsY(18) = 8: TableElemsX(18) = 78: TableElemsChar(18) = 31 '
    FOR i = 1 TO 18
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
    LOCATE 10, 70: PRINT "  kolor    ";
    LOCATE 11, 70: PRINT " elementu  ";
    COLOR 15: LOCATE 12, 70: PRINT " "; CHR$(219); CHR$(219); CHR$(219); CHR$(219); "      ";
    COLOR 14: LOCATE 12, 76: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
    IF Y = 12 AND X > 70 AND X < 75 AND _MOUSEBUTTON(1) THEN
        CharColor = 15 'bialy - tor niezelektryfikowany
        TempY = Y: TempX = X 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
    END IF
    IF Y = 12 AND X > 75 AND X < 80 AND _MOUSEBUTTON(1) THEN
        CharColor = 14 'zolty - tor zelektryfikowany
        TempY = Y: TempX = X 'potrzebne do zablokowania wielokrotnego odczytu _MOUSEBUTTON
    END IF
    IF Y = 12 AND X > 70 AND X < 75 THEN COLOR 7: LOCATE 12, 71: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219); 'podswietlenie wskazanego
    IF Y = 12 AND X > 75 AND X < 80 THEN COLOR 6: LOCATE 12, 76: PRINT CHR$(219); CHR$(219); CHR$(219); CHR$(219);
    IF CharColor = 15 THEN COLOR 0, 7: LOCATE 12, 71: PRINT "[": LOCATE 12, 74: PRINT "]"; 'zaznaczenie aktywnego
    IF CharColor = 14 THEN COLOR 0, 6: LOCATE 12, 76: PRINT "[": LOCATE 12, 79: PRINT "]";
END SUB
'------------------------------------------------------------------------------'
'                             PROCEDURY UNIWERSALNE                            '
'------------------------------------------------------------------------------'
SUB koordynaty_kursora (Y, X)
    Y = _MOUSEY: X = _MOUSEX
    COLOR 4, 1: LOCATE 30, 56: PRINT "wiersz="; wiersz; 'OPCJA DEBUG
    LOCATE 30, 67: PRINT ", kolumna="; kolumna; 'OPCJA DEBUG
END SUB

SUB etykieta_mapa_koordynaty 'PRZEROBIC NA WSPOLNA PROCEDURE DLA WSZYSTKICH ETYKIET
    DO
        DO: _LIMIT 500
            koordynaty_kursora Y, X
            rysuj_ramke 3, 3, 1, 18, 0, 3, CHR$(196), CHR$(196), CHR$(179)
            COLOR 0, 3: LOCATE 4, 4: PRINT " koordynaty kursora ";
        LOOP WHILE _MOUSEINPUT
    LOOP UNTIL Y <> 2 OR X < 4 OR X > 26
END SUB

SUB rysuj_ramke (FramePosY, FramePosX, FrameLinesCount, FrameTxtLength, FrameCharColor, FrameBackColor, FrameTop$, FrameBottom$, FrameSide$)
    COLOR FrameCharColor, FrameBackColor
    'narozniki ustalane automatycznie na podstawie ksztaltu bokow
    LOCATE FramePosY, FramePosX 'lewy gorny naroznik
    IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(218);
    IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(213);
    IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN PRINT CHR$(201);
    LOCATE FramePosY, FramePosX + FrameTxtLength + 3 'prawy gorny naroznik
    IF FrameTop$ = CHR$(196) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(191);
    IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(179) THEN PRINT CHR$(184);
    IF FrameTop$ = CHR$(205) AND FrameSide$ = CHR$(186) THEN PRINT CHR$(187);
    LOCATE FramePosY + FrameLinesCount + 1, FramePosX 'lewy dolny naroznik
    IF FrameSide$ = CHR$(179) THEN PRINT CHR$(192);
    IF FrameSide$ = CHR$(186) THEN PRINT CHR$(200);
    LOCATE FramePosY + FrameLinesCount + 1, FramePosX + FrameTxtLength + 3 'prawy dolny naroznik
    IF FrameSide$ = CHR$(179) THEN PRINT CHR$(217);
    IF FrameSide$ = CHR$(186) THEN PRINT CHR$(188);
    FOR i = 1 TO FrameTxtLength + 2 'rysuj poziome scianki ramki
        LOCATE FramePosY, FramePosX + i: PRINT FrameTop$;
        LOCATE FramePosY + FrameLinesCount + 1, FramePosX + i: PRINT FrameBottom$;
    NEXT
    FOR i = 1 TO FrameLinesCount 'rysuj pionowe scianki ramki
        LOCATE FramePosY + i, FramePosX: PRINT FrameSide$;
        LOCATE FramePosY + i, FramePosX + FrameTxtLength + 3: PRINT FrameSide$;
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
