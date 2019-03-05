# Mise en place d'une antenne RTK (site de Saint-Leu - Ifremer - Réunion)

*Modèle Emlid Reach M+ - v2.16.2*

## Installation du module

La température locale et l'humidité relative étant très élevées, il est nécessaire de retirer le module du boitier et de lui adjoindre un ventilateur équipé d'un dissipateur, comme présenté ci-dessous.

<center><img src="../docs/images/reach_fan.png"></center>

L'antenne est placée sur un mât et le reach est positionné dans un endroit abrité du soleil direct et de la pluie.

<center><img src="../docs/images/reach_roof.jpg"></center>

## Paramétrage de la base

Afin d'utiliser le reach en tant que base fixe, il est indispensable de définir ses coordonnées le plus précisément possible.

## Installation du caster

### Prérequis du serveur

OS: Ubuntu-server 18.04

Installer les paquets docker et docker-compose

``` sudo apt-get install docker docker-compose```

Il est nécessaire d'ouvrir le port 2101 de la machine.

### Déploiement du caster

L'application est conteneurisée dans docker :

Récupérer les codes de centipede :

``` git clone https://github.com/jancelin/centipede.git ```

Modifier le fichier de configuration :

``` cd centipede 
sudo nano ntripcaster.conf ```

Modifier les valeurs suivantes :

server_url
 email
 server_name
 mountpoint

```sudo nano sourcetab.dat```
 name
 position
 

