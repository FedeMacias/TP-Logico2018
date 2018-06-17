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

leDijoUnSpoilerDeUnaSerieQueVe(Persona,OtraPersona,Serie):-
  leDijo(Persona,OtraPersona,Serie,_).

leDijoUnSpoilerDeUnaQueQuiereVer(Persona,OtraPersona,Serie):-
  quiereVer(OtraPersona,Serie),
  leDijo(Persona,OtraPersona,Serie,_).

leSpoileo(Persona,OtraPersona,Serie):-
  relacion(Persona,OtraPersona,Serie),
  leDijoUnSpoilerDeUnaSerieQueVe(Persona,OtraPersona,Serie).
  
leSpoileo(Persona,OtraPersona,Serie):-
  relacion(Persona,OtraPersona,Serie),
  leDijoUnSpoilerDeUnaQueQuiereVer(Persona,OtraPersona,Serie).
  
relacion(Persona,OtraPersona,Serie):-  
  persona(Persona),
  persona(OtraPersona),
  serie(Serie).

noLeSpoileo(Persona,OtraPersona,Serie):-
  not(leSpoileo(Persona,OtraPersona,Serie)).

/*televidenteResponsable(Persona):-
  persona(Persona),
  forAll(OtraPersona,(Persona\= OtraPersona, noLeSpoileo(Persona,OtraPersona,_))).   ME CHILLA POR EL FORALL, REVISAR*/
