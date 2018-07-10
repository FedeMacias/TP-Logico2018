mira(juan, himym).
mira(juan, futurama).
mira(juan, got).
mira(nico, starWars).
mira(maiu, starWars).
mira(maiu, onePiece).
mira(maiu, got).
mira(nico, got).
mira(gaston, hoc).
mira(pedro, got).
/*no se agrega mad men ni a alf ya que por el principio de universo cerrado al no estar en la base de conocimientos se asumen falsas*/

esPopular(hoc).
esPopular(Serie):-
  serie(Serie),
  popularidad(Serie, Coeficiente),
  popularidad(starWars, CoeficienteDeStarWars),
  Coeficiente >= CoeficienteDeStarWars.

/*Se aceptan cambios de nombre de variables*/
popularidad(Serie, Coeficiente):-
  cantidadPersonasQueMiran(Serie, PersonasQueMiran),
  cantidadDeConversacionesSobre(Serie, ConversacionesTotales),
  Coeficiente is PersonasQueMiran * ConversacionesTotales.

cantidadPersonasQueMiran(Serie ,PersonasQueMiran):-
  findall(Persona, mira(Persona, Serie), TodasLasQueMiran),
  length(TodasLasQueMiran, CantidadDePersonasQueMiran),
  PersonasQueMiran is CantidadDePersonasQueMiran.

cantidadDeConversacionesSobre(Serie, ConversacionesTotales):-
  findall(Conversacion, leDijo(_, _, Serie, Conversacion), ConversacionesSobreSerie),
  length(ConversacionesSobreSerie, CantidadDeConversacionesSobreSerie),
  ConversacionesTotales is CantidadDeConversacionesSobreSerie.

quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).

capitulosDeTemporada(got, 12, 3).
capitulosDeTemporada(got, 10, 2).
capitulosDeTemporada(himym, 23, 1).
capitulosDeTemporada(drHouse, 16, 8).

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

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
leDijo(nico, juan, futurama, muerte(seymourDiera)).
leDijo(pedro, aye, got, relacion(amistad, tyrion, dragon)).
leDijo(aye, nico, got, relacion(parentesco, tyrion, dragon)).

serie(Serie):-
  mira(_, Serie).

persona(Persona):-
  mira(Persona, _).

persona(Persona):-
  quiereVer(Persona, _).

esSpoiler(Serie, Spoiler):-
  serie(Serie),
  paso(Serie, _, _, Spoiler).

noEsSpoiler(Serie, Spoiler):- not(esSpoiler(Serie, Spoiler)).

leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona, OtraPersona, Serie):-
  mira(OtraPersona, Serie),
  leDijo(Persona, OtraPersona, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona, OtraPersona, Serie):-
  quiereVer(OtraPersona, Serie),
  leDijo(Persona, OtraPersona, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

relacion(Persona,OtraPersona,Serie):-
  persona(Persona),
  persona(OtraPersona),
  Persona \= OtraPersona,
  serie(Serie).

leSpoileo(Persona,OtraPersona,Serie):-
  relacion(Persona,OtraPersona,Serie),
  leDijoUnSpoilerDeUnaQueVioOQuiereVer(Persona,OtraPersona,Serie).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, _)).

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

vieneZafando(Persona,Serie):-
  persona(Persona),
  esPopularOFuerte(Serie),
  miraOQuiereVer(Persona,Serie),
  not(leSpoileo(_,Persona,Serie)).

malaGente(Persona):-
  forall(leDijo(Persona, OtraPersona, _, _), leSpoileo(Persona, OtraPersona, _)).

malaGente(Persona):-
  leSpoileo(Persona, _, Serie),
  not(mira(Persona, Serie)).

fullSpoil(Persona,OtraPersona):-
  persona(Persona),
  persona(OtraPersona),
  Persona \= OtraPersona,
  amigo(OtraPersona,UnTercero),
  fullSpoil(Persona,UnTercero).

fullSpoil(Persona,OtraPersona):-
  persona(Persona),
  persona(OtraPersona),
  Persona \= OtraPersona,
  leSpoileo(Persona,OtraPersona,_).
  
%plotTwist(Serie, Temporada, Episodio, listaPalabrasClave)
plotTwist(got, 3, 2, [suenio, sinPiernas]).
plotTwist(got, 3, 12, [fuego, boda]).
plotTwist(superCampeones, 9, 9,[suenio, coma, sinPiernas]).
plotTwist(drHouse, 8, 7,[coma, pastillas]).

plotTwistFuerteParaSerie(Serie,plotTwist(Serie,Temporada,Episodio,Palabras)):-
	plotTwist(Serie,Temporada,Episodio,Palabras),
	not(esCliche(Serie,Palabras)),
	pasoEnFinalDeTemporada(Serie,Temporada,Episodio).

pasoEnFinalDeTemporada(Serie,Temporada,Episodio):-
	capitulosDeTemporada(Serie, Episodio, Temporada).
	
esCliche(Serie, Palabras):-
	plotTwist(UnaSerie,_,_,UnasPalabras),
	contieneOtraLista(Palabras,UnasPalabras),
	UnaSerie \= Serie.
	
contieneOtraLista([],[]).
contieneOtraLista([Cabeza|Cola1],[Cabeza|Cola2]) :-
	contieneOtraLista(Cola1,Cola2).
contieneOtraLista(Cola1, [_|Cola2]) :-
	contieneOtraLista(Cola1,Cola2).
	
	
contieneSucesoFuerte(Serie,Suceso):-
	paso(Serie,_,_,Suceso),
	sucesoFuerte(Suceso).
contieneSucesoFuerte(Serie,Suceso):-
	plotTwistFuerteParaSerie(Serie,Suceso).


%pruebas
:- begin_tests(series).
test(madMen_no_es_una_serie_que_exista_en_este_universo, nondet):-
  not(serie(madMen)).
:- end_tests(series).

:- begin_tests(temporadasSeries).
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
:- end_tests(temporadasSeries).

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

:- begin_tests(leSpoileo).
test(gaston_le_dijo_a_maiu_de_got, nondet):-
  leSpoileo(gaston, maiu, got).
test(nico_le_dijo_a_maiu_de_starWars, nondet):-
  leSpoileo(nico, maiu, starWars).
:- end_tests(leSpoileo).

:- begin_tests(televidenteResponsable).
test(son_televidenteResponsable_juan_maiu_aye, nondet):-
  televidenteResponsable(juan),
  televidenteResponsable(maiu),
  televidenteResponsable(aye).
test(no_son_televidenteResponsable_nico_gaston, nondet):-
  not(televidenteResponsable(nico)),
  not(televidenteResponsable(gaston)).
:- end_tests(televidenteResponsable).

:- begin_tests(vieneZafando).
test(maiu_no_viene_zafando, nondet):-
  not(vieneZafando(maiu, _)).
test(juan_viene_zafando_hoc_himym_got, nondet):-
  vieneZafando(juan, hoc),
  vieneZafando(juan, himym),
  vieneZafando(juan, got).
test(juan_no_viene_zafando_futurama, nondet):-
  not(vieneZafando(juan, futurama)).
test(nico_viene_zafando_starWars, nondet):-
  vieneZafando(nico, starWars).
:- end_tests(vieneZafando).

:- begin_tests(malaGente).
test(gaston_es_mala_gente, nondet):-
  malaGente(gaston).
:- end_tests(malaGente).

