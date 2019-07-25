# 2. Installation d'une Base RTK

## Matériel utilisé

Voici la liste des éléments nécessaires à la mise en place d'une base RTK :

|Matériel|Prix HT|
|--------|----|
|[Emlid Reach M+](https://store.emlid.com/product/reachm-plus/)|240€|
|[Tallysman multi-GNSS antenna](https://store.emlid.com/product/tallysman-multi-gnss-antenna/)|54€|
|[Câble d'extension d'antenne](https://store.emlid.com/product/reach-antenna-extension-cable-2m/)|11€|
|[Feuille aluminium (plan de masse)](https://fr.rs-online.com/web/c/abrasifs-materiaux-techniques/tubes-feuilles-et-angles-en-aluminium/feuilles-en-aluminium/?searchTerm=aluminium&sort-by=P_breakPrice1&sort-order=asc&applied-dimensions=4294555449)|12€|
|[Alimentation](https://fr.rs-online.com/web/p/adaptateurs-ac-dc/1770223/)|6€|
|En Option||
|[Dissipateur chaleur](https://fr.rs-online.com/web/p/dissipateurs-de-chaleur/1263113/)|13€|
|[Pâte thermique](https://fr.rs-online.com/web/p/graisse-thermique/0554311/)|7€|

> scratch 3M ?

Un accès WIFI proche de la base est indispensable pour assurer la connexion du récepteur au réseau internet. Si ce n'est pas le cas, il est possible d'utiliser des CPL ethernet et wifi pour se déporter le réseau wifi vers la zone d'installation de votre antenne. Attention, dans cette configuration le CPL doit être connecté sur la même phase de votre réseau électrique que votre point d'accès à internet (Box).

> Exemple d'utilisation d'un RPI pour les réseaux wifi institutionnels ?

## Choix de la zone d'implantation

La zone d'implantation de l'antenne de réception ne nécessite pas une position dominante, mais doit proposer une visibilité maximum du ciel ; il est indispensable de ne pas avoir d'obstacles (bâtiments, arbres, murs ...) sous les 30 premiers degrés par rapport à la base de l'antenne.

![sky_view](image/montage/skyview-obstacles_1.png)

## Installation de l'antenne de réception et du Reach M+

L'antenne [Tallysman multi-GNSS antenna](https://store.emlid.com/product/tallysman-multi-gnss-antenna/) doit être placée sur un plan de masse en métal ([préconisation du constructeur](http://www.tallysman.com/wp-content/uploads/Embedded-Antennas-Reference-Guide.pdf)) de 10 cm afin d'améliorer la réception des données satellitaires. Il peut être fabriqué en aluminium, inox ou cuivre. Il doit disposer d'un trou central pour le fixer avec un boulon tête fraisée sur un support (mât, toiture, borne béton...) et d'un deuxième trou pour faire passer le fil de l'antenne.
> [Note pour plus tard](https://www.fig.net/resources/proceedings/fig_proceedings/fig2017/ppt/ts08c/TS08C_zhang_schwieger_8513_ppt.pdf)

Coller ensuite l'antenne sur le plan de masse, rajouter le câble d'extension de 2 mètres si nécessaire (en fonction de la configuration de pose) et connecter le Reach M+.

![groundPlane](image/montage/ground_plane.jpg)

Le Reach M+ doit être positionné dans un endroit abrité du soleil direct et de la pluie, si possible en intérieur et dans une zone lui permettant de capter le signal wifi de votre box. Si vous n'avez pas de wifi disponible, vous pouvez utiliser un [cpl wifi](https://www.boulanger.com/ref/8002139?xtor=SEC-1294-GOO&xts=171153&origin=pla&kwd=&gclid=EAIaIQobChMI1tTns9TN4wIVkEPTCh1dzAA7EAYYAiABEgKVZvD_BwE&gclsrc=aw.ds) ou un [Raspberry Pi](https://github.com/jancelin/geo-poppy/wiki/2.-Installation). Il est également possible de le connecter avec un avec un cable ethernet ([exemple de montage](https://jancelin.github.io/centipede/ethernet)) mais pas pour la phase de mise à jour (wifi uniquement).

Voici plusieurs exemples de montage de bases RTK :

![antenne](image/montage/antenne.jpg)

En cas de montage extérieur, il est important de rajouter un dissipateur de chaleur sur le module RTK. La procédure de montage est disponible ici:

[Installation d'un dissipateur thermique](https://jancelin.github.io/centipede/dissipateur)

## Premières configurations

Le Reach M+ est mis sous tension.

* Se connecter au réseau wifi du Reach ("reach:xx:xx") en utilisant le mot de passe __emlidreach__.

* Ouvrir un navigateur (de préférence Mozilla Firefox ou Google Chrome) et taper http://reach.local ou http://192.168.42.1 pour accéder à l'interface de configuration du reach

* Cliquer sur le bouton + et entrer le SSID de votre réseau wifi, le type de sécurité et le mot de passe. Cliquer sur le bouton Save.

* Sélectionner votre réseau wifi et cliquer sur Connect.

* Mettre à jour le Reach M+

* Reboot

![reachupdate](image/montage/reachupdate.jpg)

* Une fois le reach connecté sur votre réseau wifi, une nouvelle IP lui est attribuée ; c'est celle-ci qui est utilisée par la suite (http://reach.local fonctionne également). Cette IP est visible sur l'interface Web du Reach, en haut à gauche de l'écran.

![reachview](image/montage/reachview1.png)

> Note : il est également possible de faire ces manipulations via l'application [ReachView](https://play.google.com/store/apps/details?id=com.reachview&hl=fr) (disponible sur Android et iOS) sur une tablette ou un smartphone.

