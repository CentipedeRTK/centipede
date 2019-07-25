## FAQ

* ### Ca sert à quoi?

> à avoir notre position géographique à quelques centimètre.

* ### Pour quoi faire?

> Localiser des choses très précisément  comme une plante, un chemin, un tuyau, faire une mesure, ... 

> Couplé à un drone (tracteur, quadadcoptère, aile) et un système de navigation, cela donne un système de conduite sans assistance.

* ### C'est simple le RTK?

> Non!, ça demande un peu de matériel (donc un peu d'argent), un peu de connection internet (3-4g mobile et env 10 Mb/heure) et de compréhension de la technologie pour en profiter pleinement.

* ### Donc c'est très cher?

> Oui et Non. 

> Si l'on investi dans un système dit "propriétaire" il faudra investir entre  2500 et 15000 € par antenne.

> Dans le cas du projet Centipède, l'idée est d'utiliser des composants génériques et des logiciels opensources, les coût sont donc divisés par 10, soit environ 250-300 € pour un matériel (sans options), qu'il soit Base ou Rover.

> Le coût global pour la géolocalisation en autonomie s'élève donc rarement à plus de 700 € (Base + rover + accessoires).

* ### C'est quoi une base et un rover?

> Ce sont exactement les mêmes composants (antenne de réception + puce de décodage + nano ordinateur + logiciels)

> * Une base est un ensemble de composants captants les signaux des satellites de navigation (GPS + GLONASS + GALILEO + ...) et qui connait sa position très précisement par calcul. Elle calcule en temps réel la différence entre les signaux reçus par les sattelites et sa position calculée. Ce sont ces variables de correction qui permettent de corriger un Rover. 

> * Un Rover est un ensemble de composants captants les signaux des satellites de navigation (GPS + GLONASS + GALILEO + ...) et qui ressoit une variable de correction d'une base (via 3-4g mobile ou radio). Cette ensemble permet d'avoir, par calcul, une précision géométrique de quelques centimètres en fonction des conditions.

 * ### Ca émet des ondes?

> Non, nous recevons en permanence les ondes des satellites positionnés autour de la terre, nous ne faisons que les capter.

> Oui et Non, Les données de correction de la base sont envoyés à un seveur par WIFI ou cable ethernet.

> Oui, nous utilisons la technolie mobile ( 3-4G ) pour récupérer cette donnée sur le terrain. Nous consommons donc une emission.

> Non, nous avons fait le choix d'utiliser cette technologie pour ne pas rajouter une nouvlle emission d'ondes via une fréquence particulière. Nous utilisons donc l'existant, avec ses avantages et ses inconvénients [zones blanches](https://www.arcep.fr/cartes-et-donnees/nos-publications-chiffrees/observatoire-des-deploiements-mobiles-en-zones-peu-denses/les-deploiements-mobiles-dans-les-zones-peu-denses.html){:target="_blank"}









