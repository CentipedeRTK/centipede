## 1 FAQ

* ### Ca sert à quoi ?

> à avoir votre position géographique à quelques centimètres.

* ### Pour quoi faire ?

> Localiser des choses très précisément comme une plante, un chemin, un tuyau, faire une mesure, ...

> Couplé à un drone (tracteur, quadcoptère, aile) et un système de navigation, cela donne un système de conduite sans assistance.

* ### C'est simple le RTK?

> Non ! Ça demande un peu de matériel (donc un peu d'argent), un peu de connections Internet (3-4g mobile et env. 10 Mb/heure) et de compréhension de la technologie pour en profiter pleinement.

* ### Donc c'est très cher ?

> Oui et Non.

> Si l'on investi dans un système dit "propriétaire" il faudra investir entre 2500 et 15000 € par antenne.

> Dans le cas du projet Centipède, l'idée est d'utiliser des composants génériques et des logiciels open sources, les coûts sont donc divisés par 10, soit environ 250-300 € pour un matériel (sans options), qu'il soit Base ou Rover.

> Le coût global pour la géolocalisation en autonomie s'élève donc rarement à plus de 700 € (base + rover + accessoires).

* ### Pourquoi avec mon smartphone ou mon récepteur GNSS je n'ai pas cette précision ?

> Parce que les conditions physiques en altitude (ionosphère et troposphère, bref au dessus de notre tête) se modifient en continue ( vent solaire, humidité,...) et "tordent" le signal emis par les satellites, se qui entraine des biais lors des mesures (env 3-5m).

> Parce que votre smartphone ne permet pas de récolter l'ensemble des données satellites de navigations de corrections différnetiel. Pas assez de précision...

> Vous avez besoin de matériels compatibles avec les trames L1 ou L1-L2 des satellites

* ### C'est quoi une base et un rover ?

> Ce sont exactement les mêmes composants (antenne de réception + puce de décodage + nano ordinateur + logiciels), mais ont des fonctions différentes.

> * Une base est un ensemble de composants qui captent les signaux des satellites de navigation (GPS + GLONASS + GALILEO + ...) et qui connaît sa position très précisément par calcul. Elle calcule en temps réel la différence entre les signaux reçus par les satellites et sa position calculée. Ce sont ces variables de correction qui permettent de corriger un Rover.

> * Un Rover est un ensemble de composants qui captent les signaux des satellites de navigation (GPS + GLONASS + GALILEO + ...) et qui reçoit une variable de correction d'une base (via 3-4g mobile ou radio). Cet ensemble permet d'avoir, par calcul, une précision géométrique de quelques centimètres en fonction des conditions.

* ### Ca émet des ondes ?

> Non, nous recevons en permanence les ondes des satellites positionnés autour de la terre, nous ne faisons que les capter.

> Oui et Non, Les données de correction de la base sont envoyés à un serveur par WIFI ou câble ethernet(via une "box internet personnel" ou un réseau entreprise).

> Oui, nous utilisons la technologie mobile (3-4G ) pour récupérer cette donnée sur le terrain. Nous consommons donc une émission.

> Non, nous avons fait le choix d'utiliser cette technologie pour ne pas rajouter une nouvelle émission d'ondes via une l'achat d'une fréquence particulière d'émission. Nous utilisons donc l'existant, avec ses avantages et ses inconvénients. [zones blanches](https://www.arcep.fr/cartes-et-donnees/nos-publications-chiffrees/observatoire-des-deploiements-mobiles-en-zones-peu-denses/les-deploiements-mobiles-dans-les-zones-peu-denses.html){:target="_blank"}

* ### Mon matériel est compatible ?

> Le caster (serveur centralisant l'ensemble des Bases RTK Centipède) transmet une trame de correction en RTCM3, si votre matériel de géolocalisation est compatible avec ce format alors vous pouvez vous connecter librement aux Bases RTK Centipède.

* ### Librement ?

> Le réseau en réception est communautaire donc pas de login et de mot de passe

> Pour la déclaration d'une base RTK en émission, il est nécessaire de suivre à la lettre les prochaines pages de ce site.

* ### Comment me connecter au service si mon matériel est compatible ?

> Vérifier dans un premier temps que vous êtes bien dans une zone couverte géographiquement par le [réseau Centipède](https://centipede.fr){:target="_blank"}

> dans vos paramètres de connexion de votre matériel à un système de correction RTK, veuillez renseigner:

> adresse du serveur: caster.centipede.fr

> Port: 2101

> Pas de login et de mot de passe (ou 1 espace en fonction des systèmes)

> choisir le point de montage dans la liste ou stipuler le point de montage (Mount Point, ex: CT)

> définir le format (si besoin); RTCM3

-----------------------------------------------------------------
