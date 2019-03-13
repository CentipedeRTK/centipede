
<p align="center"><img src="../docs/images/balise.jpeg"></p>

## Une Balise Open Source pour le monitoring des océans

### Mission conjointe: IFREMER / INRA

date: Mars 2019

Collaborateurs: Julien Ancelin (INRA), Sylvain Bonhommeau (IFREMER), Wilfried Heintz (INRA), Sylvain Poulain (GISCAN), Julien Barde (IRD) , Anne-Elise Nieblas (COOOL Research)

Licence: CC0

L’acquisition de données dans le milieu marin pour des problématiques climatiques est un enjeu majeur à l’échelle internationale. Cependant, les instruments d’acquisition sont souvent très onéreux, spécialisés pour certains champs disciplinaires et dont les spécifications techniques et logicielles sont protégées par les industriels qui font peu d’innovations. La démocratisation de l’électronique libre, des projets open-source / open-data et des objets connectés offrant des solutions de communications très peu chères ont le potentiel de modifier complètement le panorama de l’observation en sciences marines.

Les défis à relever sont la capacité à collecter et transmettre des données dans le domaine marin de manière autonome en termes d’énergie.

Ce projet est consacré au développement de balises capables de collecter des données (hauteur de l’eau, houle, marée) grâce à un capteur GNSS RTK . Cette première mission à la Réunion (mars 2019) est ainsi l’occasion de tester les développements en termes de système de transmission et la capacité de récupérer des volumes de données permettant le monitoring de données océanographiques.

### Utilisation du réseau Centipède <p align="left"><img src="../docs/images/centipede.jpg" height=80px></p>

Le projet Centipède vise à créer un réseau de bases RTK ouvertes et disponibles pour toute personne se trouvant dans la zone de couverture. Cette technologie permet entre autres à des instituts de recherche d’effectuer des relevés expérimentaux en haute précision géographique, en autonomie, à faible coût et avec des outils et méthodes Open Source.

<p align="center"><img src="../docs/images/reach_palmier.png"></p>

Le premier objectif de cette mission était de mettre en place une base de référence capable de corriger les signaux satellitaires pour atteindre une précision centimétrique temps réel des mesures. L'installation à permis de tester la résistance des composants électroniques à la chaleur et l'humidité ambiante ainsi que de fiabiliser la méthode de calcul de son positionnement grâce au RGP. Une documentation est disponible ici pour reproduire pour vos propres besoins le processus de montage et calage de la Base. Le signal de correction RTCM3 produit est diffusé en OpenAcess, via un NTRIP BroadCaster utilisable dans une zone d'action de 10 km de rayon autour de la base.

<p align="left"><img src="../docs/images/dodo_lizmap.png" ></p>

Cette limite garantie la précision de la mesure car le matériel utilisé n'est capable d'utiliser que la fréquence L1 des Satellites GNSS, au-delà, une variabilité supplémentaire risque d'être induite et demande donc d'installer une nouvelle base. Cependant, l'arrivée prochaine de nouvelles puces informatique à faible coût va permettre de travailler sur les fréquences L1 et L2 permettant ainsi de garantir un signal de correction sur des distances proches de 40-50km de la base de référence.

### Test d'acquisition en RTK

Différents tests de validations de la position de la bases ont été effectués via des posts traitements et des mesures par rapport aux stations de référence du RGP. Des tests sur terre ont également été réalisés pour vérifier la fiabilité du signal de correction et sa disponibilité en continue.

<p align="center"><img src="../docs/images/survey_centipede2.png"></p>

Malgré le positionnement obligatoire de la base RTK nomé "DODO" proche des reliefs du bord de côte de L'île de la Réunion, la disponibilité du signal de correction est rapide, fiable et continue avec une bonne disponibilité satellitaire.

<p align="center"><img src="../docs/images/dodo_rtk.jpg" ></p>


### Conception de la balise

Ce premier prototype s'inspire des expériences de l'équipe de SONEL ( Système d'Observation du Niveau des Eaux Littorales) qui rassemble et de diffuse des observations du niveau marin à la côte enregistrées par des marégraphes, de la meilleure qualité métrologique possible, pour apporter aux chercheurs des éléments qui leur permettront de répondre aux questions qu’ils se posent aujourd’hui sur les changements qui affectent les différentes composantes du niveau de la mer. Cette équipe à développée des bouées GPS mesurant le niveau de la mer à une "résolution de 1 à 2.2 cm par rapport à des marégraphes conventionnels ce qui est satisfaisant pour des applications marégraphiques et offre d’intéressantes perspectives pour les futures études sur l’évolution du niveau de la mer" (Andre, Gael & Martin Miguez, Belen & Ballu, Valérie & Testut, L & Woppelmann, Guy & Tiphaneau, Pascal. (2014). La mesure du niveau de la mer par bouées GPS : l’expérience multi-capteurs de l’île d’Aix.).

Les mesures de ces bouées GPS ont été réalisées en mode GNSS single et ensuite post-traitées en mode cinématique en utilisant une station du réseau GNSS permanent de l’IGN. Ce processus demande de récupérer les données des récepteurs manuellement régulièrement et ensuite d'effectuer un traitement informatique assez lourd. Les résultats ne sont donc disponibles qu'à posteriori. L'idée pour ce nouveau prototype est d'utiliser la technologie RTK afin de disposer de données de mesures fiables, instantanées et donc de pouvoir monitorer en temps réel les océans.

De plus, SONEL utilise des récepteur GPS propriétaire coûteux et donc difficilement déployable, ce prototype devra donc être le moins cher possible et libre afin d'offrir la possibilité de monitorer un maximum de zones possible pour permettre une collecte de masse de données.

<p align="center"><img src="../docs/images/champagne.jpeg" ></p>

Ce prototype version 0.1 est nommé "Champagne". Il est composé d'un module Emlid Reach M+ embarquant une puce Ublox NEO-M8P mono fréquence, un Opérating système Linux, le logiciel RTKLib et enfin ReachView, une web interface permettant le paramétrage simplifié de RTKlib. L'ensemble des codes du M+ sont disponibles ici. Une antenne de réception multi-GNSS Tallysman est montée sur un ground Plane de 12 cm en aluminium. Afin de recevoir le signal RTM3 de correction RTK et renvoyer les données dans une base de données centrale, un smartphone avec un forfait 4G est utilisé, il sera remplacé par une clé USB 4G compatible prochainement. Le tout est alimenté avec une batterie externe USB en attendant un montage autonome en électricité via des panneaux solaires.

<p align="center"><img src="../docs/images/reach_bouee.jpg" ></p>

### Test de la balise

Ce premier test est réalisé dans le lagon de Saint-Leu (la Réunion) avant son positionnement permanent au large du lagon. Cette situation à permis de vérifier facilement et régulièrement son bon fonctionnement et d'effectuer d'autres tests à proximité pendant l'acquisition avec d'autres matériels terrestre.

<p align="center"><img src="../docs/images/champagne_misealeau.jpeg"></p>

Une première phase de test à été effectué pour vérifier la bonne étanchéité de la balise, son effet "bouchon", sa capacité à récupérer la trame RTCM3 de la base Centipede "DODO" et avoir un "fix" RTK (Q=1 et AR ratio=999.99) constant afin de garantir une donnée de qualité (+- 2 cm en altimétrie par rapport à nos estimations en mesures statiques).

<p align="center"><img src="../docs/images/champagne_aleau.jpeg" ></p>


La balise à été fixée à un poteau délimitant l'une des réserves marine de la Réunion et a acquis des données de longitude, latitude, altimétrie, fix GNSS, variabilité de la position et qualité du signal pendant une durée de quatre heures.

<p align="center"><img src="../docs/images/champagne_bouchon.jpeg"></p>


### Premiers résultats

La fréquence d'acquisition des données était de 5 HZ soit 5 données par secondes, cela représente une quantité non négligeable en terme de volume, mais permet de récupérer l’essentiel et le fiable suite au nettoyage des données aberrantes sur cette courte période de mesure. La balise n'a pas montré de perte de données ni de coupure pendant l'acquisition et les composants n'ont pas eux d'effets de surchauffe malgré l'ambiance confinée de la balise étanche et la bulle de protection transparente (effet de serre). Un effet "bouchon" à été observé visuellement lié à la morphologie du matériel, l'effet clapot, le courant et le vent présent dans le lagon. L'analyse des données à montrée une influence de son point d'accroche avec un effet de masque (poteau en métal influençant la réception des données satellitaires) quand la balise se trouvais à proximité. Néanmoins, il semble à première vue que les données collectées concordent et permettent de monitorer les cycles et périodes des mouvements des océans.

<p align="center"><img src="../docs/images/champagne_graph.jpeg"></p>

### Enfin...

Il nous reste maintenant à lancer des tests en continue et en autonomie énergétique. Il sera nécessaire également de se comparer aux autres bouées du même type (matériel SONEL par exemple) afin de d'estimer la variabilité de nos mesures, de déterminer si ce mode de collecte de données est fiable et à quelle niveau de précision nos données converges.

A suivre...
