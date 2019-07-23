**Utilisation d'un cable ethernet à la place du wifi**

L'utilisation du wifi peux être contraigant en fonction du placement de la base RTK, de plus ce moyen de communication avec le réseau entraine de coupures.

Dans ce document, nous allons brancher un module elid reach M+ directement sur un cable ethernet.

*Matériel à prevoir en plus*

* [un module ethernet to USB: 32€](https://fr.rs-online.com/web/p/products/1447999/?grossPrice=Y&cm_mmc=FR-PLA-DS3A-_-google-_-CSS_PLA_FR_FR_Informatique_Et_P%C3%A9riph%C3%A9riques-_-R%C3%A9seaux_Et_Connectivit%C3%A9%7CAdaptateurs_D%27Interface-_-PRODUCT_GROUP&matchtype=&pla-627275384809&gclid=EAIaIQobChMI0uqsz4PL4wIVxEPTCh1P8wFLEAQYASABEgKqIvD_BwE&gclsrc=aw.ds)

* Un vieux cable usb

* le cable  JST-GH port fourni avec le Reach M+

* le cable adaptateur OTG


*Montage*

* couper votre cable USB pour récupérer le fil rouge et le noir.

* raccorder les fils au cable JST-GH port afin d'alimenter le Reach M+

<p align="center"><img src="../docs/images/ethernet/1.jpg"></p>

* Connecter l'adaptateur ethernet USB au cable OTG et ce dernier au Reach M+

* Connecter le cable fabriqué précedement dans le port S1 du M+

* Connecter l'antenne

<p align="center"><img src="../docs/images/ethernet/2.jpg"></p>

*Test*

Pour vérifier le montage, connecter un cable ethernet (connecté à votre réseau) à l'adaptateur et alimenter en usb via un transformateur 220V -> 5V (smartphone), un port USB PC ou une batterie externe.

Une fois que le Reach M+ est démarré (les 3 leds alumés), se connecter au Hotsopt et vérifier qu'il accède bien au web. Une des meilleurs technique est d'ajouter une "correction input" via le réseau centipede et voir siil ressoit bien les données.

