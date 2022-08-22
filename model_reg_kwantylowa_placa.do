/* W S T Ę P */

/* Płeć jest jedną z najczęściej wskazywanych charakterystyk w analizie rynku pracy, która wpływa 
negatywnie na oferowane zarobki ze względu na preferencje zawodowe i indywidualne możliwości, 
które różnią się między kobietami i mężczyznami. W niniejszej analizie grupy te zostaną oddzielone aby zbadać czy różne charakterystyki mają podobny wpływ w obydwu z nich. Szczególnie 
zwrócono uwagę na kolor skóry, gdyż autor podejrzewa, że pomimo zniesienia niewolnictwa wpływ 
rasy na oferowane zarobki może być znaczący (dane ze Stanów Zjednoczonych). W celu uzyskania oszacowań dla wpływu zmiennych 
objaśniających na oferowaną stawkę godzinową, która w badaniu jest zmienną objaśnianą przeprowadzono analizę regresją liniową oraz regresją kwantylową */

/* zainstaluj jezeli jeszcze nie masz */
ssc install grqreg

/* bierzemy 15% z proby (40k~ proba to za duzo zeby liczyc te wszystkie wykresy w STATA, sprawdzone. Poza tym proba 6000 jest bardzo ok) */
sample 15
/*regresje + zapisanie wynikow - zaczynamy od regresji liniowej, konczymy na 95 centylu*/
regress ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2
estimates store MNK

regress ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1)
estimates store MNK_w
regress ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0)
estimates store MNK_m
bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.05) reps(99)
estimates store Q05_w
bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.05) reps(99)
estimates store Q05_m

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.25) reps(99)
estimates store Q25_w

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.25) reps(99)
estimates store Q25_m

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum  licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.5) reps(99)
estimates store Q50_m

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum  licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.5) reps(99)
estimates store Q50_w

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.75) reps(99)
estimates store Q75_w
bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.75) reps(99)
estimates store Q75_m

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.95) reps(99)
estimates store Q95_m

bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.95) reps(99)
estimates store Q95_w


iqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==1), quantile(0.25 0.75) reps(200)
iqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2 if (kobieta ==0), quantile(0.25 0.75) reps(200)

test [Q25_m]czarny=[Q25_w]czarny
test ([q25]plec=[q75]plec) ([q25]kawaler_panna=[q75]kawaler_panna)

estimates table MNK Q05 Q25 Q50 Q75 Q95, p

/* test rownosci oszacowan dla wspolczynnika kobiet w kwartylu 1 i 3 */
test [q25]=[q75]

/* wykresiki, bootstrap 20-krotny to standard */
bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2, reps(99)
grqreg, ols ci olsci reps(20)

/*wykresiki dla wyksztalcenia */
bsqreg ln_placa_h  malzenstwo czarny latynos max_5_klasa mniej_niz_liceum licencjat magister doktor wiek wiek2, reps(99)
grqreg max_5_klasa mniej_niz_liceum licencjat magister doktor , ols ci olsci reps(20)

/*wykresiki dla charakterystyk niezaleznych + malzenstwo (malzenstwo zeby byl symetryczny wydruk) */
bsqreg ln_placa_h  malzenstwo czarny latynos mniej_niz_liceum max_5_klasa licencjat magister doktor wiek wiek2, reps(99)
grqreg  czarny latynos malzenstwo, ols ci olsci reps(20)

/*wykresy dla wieku */
bsqreg ln_placa_h  malzenstwo czarny latynos mniej_niz_liceum max_5_klasa licencjat magister doktor wiek wiek2, reps(99)
grqreg wiek wiek2, ols ci olsci reps(20)

/* alternatywnie, wyswietlanie łączne kilku wybranych kwantyli */
sqreg ln_placa_h  malzenstwo czarny latynos mniej_niz_liceum max_5_klasa licencjat magister doktor wiek wiek2, quantile(0.25 0.5 0.75) reps(99)



/* P O D S U M O W A N I E */

/*
Małżeństwo ma negatywny wpływ na stawkę godzinową w obu badanych grupach, jednak 
wśród mężczyzn negatywny wpływ jest blisko 3-krotnie większy i różni się istotnie na przestrzeni rozkładu stawek godzinowych.
Czarny kolor skóry w obu grupach wiąże się z negatywnym wpływem na stawkę godzinową, 
jednak u kobiet w ogonach rozkładu zmiennej objaśnianej jest nieistotny. Negatywny wpływ tej 
zmiennej jest blisko 3-krotnie większy u mężczyzn i statystycznie istotny w całym rozkładzie stawek 
godzinowych.
Latynoska uroda także wiąże się z negatywnym wpływem na stawkę godzinową w obu grupach a oszacowania dla kobiet wskazują mniej negatywny wpływ niż dla mężczyzn. Wśród mężczyzn negatywny wpływ takiej karnacji zmienia się istotnie statystycznie na przestrzeni rozkładu zmiennej objaśnianej i maleje wraz ze wzrostem stawki godzinowej. Wyniki uzyskane dla zmiennych związanych z rasą potwierdzają hipotezę badawczą.
Negatywny wpływ bardzo niskiego wykształcenia rośnie wraz z wysokością wynagrodzenia, 
podobnie pozytywny wpływ wykształcenia powyżej średniego. Wskazuje to na mniejsze znaczenie 
wykształcenia w dolnych kwantylach rozkładu płac, gdzie inne charakterystyki, które zostały pominięte w badaniu mają większy wpływ. Wyniki częściowo potwierdzają drugą hipotezę badawczą. Różnicę we wpływie wyższego wykształcenia pomiędzy grupami widać w szczególności w górnym ogonie rozkładu, u kobiet wpływ zaczyna się zmniejszać a u mężczyzn drastycznie rosnąć. Kobiety mają też większy zwrot z edukacji na poziomie szkoły doktorskiej na przestrzeni rozkładu. U mężczyzn wpływ 
jest bardziej liniowy z nachyleniem ku górze, u kobiet widoczna jest stabilizacja wpływu na przestrzeni od 25 centyla do mediany
*/