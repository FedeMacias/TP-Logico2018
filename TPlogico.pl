mira(juan,himym).
mira(juan,futurama).
mira(juan,got).
mira(nico,starWars).
mira(maiu,starWars).
mira(maiu,onePiece).
mira(maiu,got).
mira(nico,got).
mira(gaston,hoc).
/*no se agrega mad men ni a alf ya que por el principio de universo cerrado al no estar en la base de conocimientos se asumen falsas*/

esPopular(got).
esPopular(hoc).
esPopular(starWars).

quiereVer(juan,hoc).
quiereVer(aye,got).
quiereVer(gaston,himym).

capitulosDeTemporada(got,12,3).
capitulosDeTemporada(got,10,2).
capitulosDeTemporada(himym,23,1).
capitulosDeTemporada(drHouse,16,8).

/*no se agrega mad men ya que por el principio de universo cerrado al no estar en la base de conocimientos se asume falso*/

%paso(Serie, Temporada, Episodio, Lo que paso)
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

serie(Serie):-
  mira(_,Serie).

persona(Persona):-
  mira(Persona,_).

persona(Persona):-
  quiereVer(Persona,_).

esSpoiler(Serie,Spoiler):-
  serie(Serie),
  paso(Serie,_,_,Spoiler).

noEsSpoiler(Serie,Spoiler):- not(esSpoiler(Serie,Spoiler)).

leDijoUnSpoilerDeUnaSerieQueVe(Persona,OtraPersona,Serie):-
  mira(OtraPersona, Serie),
  leDijo(Persona,OtraPersona,Serie,Spoiler),
  esSpoiler(Serie,Spoiler).

leDijoUnSpoilerDeUnaQueQuiereVer(Persona,OtraPersona,Serie):-
  quiereVer(OtraPersona,Serie),
  leDijo(Persona,OtraPersona,Serie,Spoiler),
  esSpoiler(Serie,Spoiler).

leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona,OtraPersona,Serie):-
  leDijoUnSpoilerDeUnaSerieQueVe(Persona,OtraPersona,Serie).

leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona,OtraPersona,Serie):-
  leDijoUnSpoilerDeUnaQueQuiereVer(Persona,OtraPersona,Serie).


leSpoileo(Persona,OtraPersona,Serie):-
  relacion(Persona,OtraPersona,Serie),
  leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona,OtraPersona,Serie).


relacion(Persona,OtraPersona,Serie):-
  persona(Persona),
  persona(OtraPersona),
  serie(Serie).

televidenteResponsable(Persona):-
  serie(Serie),
  persona(Persona),
  forall(persona(OtraPersona),(Persona \= OtraPersona,
not(leSpoileo(Persona, OtraPersona, Serie)))).

sucesoFuerte(muerte(_)).

sucesoFuerte(relacion(amorosa,_,_)).

sucesoFuerte(relacion(parentesco,_,_)).

esPopularOFuerte(Serie):-
  esPopular(Serie).

esPopularOFuerte(Serie):-
  paso(Serie,_,_,Suceso),
  forall(paso(Serie,_,_,Suceso),sucesoFuerte(Suceso)).

miraOQuiereVer(Persona,Serie):-
  quiereVer(Persona,Serie).

miraOQuiereVer(Persona,Serie):-
  mira(Persona,Serie).

alguienLeSpoileo(Persona,Serie):-
  leDijo(_, Persona, Serie,_).

vieneZafando(Persona,Serie):-
  persona(Persona),
  esPopularOFuerte(Serie),
  miraOQuiereVer(Persona,Serie),
  not(alguienLeSpoileo(Persona,Serie)).

%pruebas
:- begin_tests(temporadas_series).
test(got_temporada_3_tiene_12_capitulos, nondet):-
  capitulosDeTemporada(Serie, Capitulos, Temporada),
  Serie == got, Capitulos == 12, Temporada == 3.
test(got_temporada_2_tiene_10_capitulos, nondet):-
  capitulosDeTemporada(Serie, Capitulos, Temporada),
  Serie == got, Capitulos == 10, Temporada == 2.
test(himym_temporada_1_tiene_23_capitulos, nondet):-
  capitulosDeTemporada(Serie, Capitulos, Temporada),
  Serie == himym, Capitulos == 23, Temporada == 1.
test(drHouse_temporada_8_tiene_16_capitulos, nondet):-
  capitulosDeTemporada(Serie, Capitulos, Temporada),
  Serie == drHouse, Capitulos == 16, Temporada == 8.
:- end_tests(temporadas_series).

:- begin_tests(esSpoiler).
test(muerte_emperor_es_spoiler, nondet):-
  esSpoiler(starWars,muerte(emperor)).
test(muerte_de_pedro_no_es_spoiler, nondet):-
  noEsSpoiler(starWars,muerte(pedro)).
test(parentesco_anakin_y_rey_es_spoiler, nondet):-
  esSpoiler(starWars,relacion(parentesco, anakin, rey)).
test(parentesco_anakin_y_lavezzi_no_es_spoiler, nondet):-
  noEsSpoiler(starWars, relacion(parentesco, anakin, lavezzi)).
:- end_tests(esSpoiler).

:- begin_tests(nose).
test(muerte_emperor_es_spoiler, nondet):-
  esSpoiler(starWars,muerte(emperor)).
test(muerte_de_pedro_no_es_spoiler, nondet):-
  noEsSpoiler(starWars,muerte(pedro)).
:- end_tests(nose).
