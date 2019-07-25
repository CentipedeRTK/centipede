
# 3.y Utilisation d'un câble ethernet à la place du wifi

L'utilisation du wifi peut être contraignant en fonction du placement de la base RTK, de plus, ce moyen de communication avec le réseau entraîne, en fonction de la distance avec le relai, des coupures voir des pertes de signal.

Dans ce document, nous allons brancher un module emlid reach M+ directement sur un cable ethernet.

## 3.y.1 Matériel à prévoir en plus

* [un module ethernet to USB: 32€](https://fr.rs-online.com/web/p/products/1447999/?grossPrice=Y&cm_mmc=FR-PLA-DS3A-_-google-_-CSS_PLA_FR_FR_Informatique_Et_P%C3%A9riph%C3%A9riques-_-R%C3%A9seaux_Et_Connectivit%C3%A9%7CAdaptateurs_D%27Interface-_-PRODUCT_GROUP&matchtype=&pla-627275384809&gclid=EAIaIQobChMI0uqsz4PL4wIVxEPTCh1P8wFLEAQYASABEgKqIvD_BwE&gclsrc=aw.ds){:target="_blank"}

* Un vieux câble usb

* le cable JST-GH fourni avec le Reach M+

* le câble adaptateur OTG fourni avec le Reach M+


## 3.y.2 Montage

* couper votre câble USB pour récupérer le fil rouge et le noir.

* raccorder les fils au cable JST-GH afin d'alimenter le Reach M+

![ethernet](image/ethernet/1.jpg)

* Connecter l'adaptateur ethernet USB au câble OTG et ce dernier au Reach M+

* Connecter le câble fabriqué précédemment dans le port S1 du M+

* Connecter l'antenne

![ethernet](image/ethernet/2.jpg)

## 3.y.3 Test

Pour vérifier le montage, connecter un câble ethernet (connecté à votre réseau) à l'adaptateur et alimenter en USB via un transformateur 220V -> 5V (smartphone), un port USB PC ou une batterie externe.

Une fois que le Reach M+ est démarré (les 3 leds allumés), se connecter au Hotspot et vérifier qu'il accède bien au web. Une des meilleures techniques est d'ajouter une "correction input" via le réseau centipede et voir s'il reçoit bien les données.

> adress: caster.centipede.fr

> port: 2101

![ethernet](image/ethernet/reach_correction.png)

Résultat dans "status"

![ethernet](image/ethernet/fix.png)
