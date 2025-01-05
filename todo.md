# Idées d'amélioration

## Style

[x] Un peu plus moderne d'utiliser `apt` que `apt-get`
[x] Unifier les 3 fonctions de log
[x] Uniformiser les indentations (la plupart des fonctions ont 4 espaces par tab, d'autres en ont 2, ex.: focus)
[x] Aérer autour des opérateurs (ex: `for(i=0;i<10;i++)` devient `for (i = 0; i < 10; i++)`)
[x] Combiner déclaration et définition sur la même ligne lorsque possible (ex: `local jq_version` suivi de `jq_version=$(jq --version)` devient `local jq_version = $(jq --version)`)
[x] Quand il y a deux ligne `echo` de suite, les combiner: `echo "$i) Exit"` suivi de `echo` devient `echo -e "$i) Exit\n"`
[x] Les shebang `#!/bin/bash` en début de fichier devraient être seulement sur les fichiers qui devraient pouvoir être appelés directement
[x] Le fichier `openssh-server.yaml` devrait être dans le dossier `functions/yaml` au lieu d'être à la racine
[ ] Définir des variables pour chaque code ANSII (ex: dans log_warning et log_error ils sont hardcodé)
[ ] Les fichiers ont un shebang `#!/bin/bash`, et utilisent des fonctionnalités de `bash`, mais sont nommés `.sh` plutôt que `.bash`
[ ] Il y a des lignes de comentaires en français et d'autres en anglais. Uniformiser ?
[ ] Les variables "max_*" au milieu de la fonction `verbose` devraient être `local` si elles sont pas utilisées hors de la fonction
[ ] `session_add` et `session_remove` sont presque identiques. Unifier ?
[ ] La fonction `unmount_pvc` supprime `openssh` et le fichier de session, le nom de la fonction est peut-être mal choisi (pourquoi unmount_pvc ?)
[ ] Il y a un juste milieu entre tout mettre dans le même fichier et faire un
    fichier différent par fonction. Je trouve qu'en ce moment il y a des
    fichiers un peu trop petits avec une seule fonction de 5 lignes. Les
    fonctions qui sont utilisés ensemble ou qui s'appellent une l'autre seraient
    probablement mieux d'être dans le même fichier.
    - Exemple: dans `unmount_pvc.sh`, il y a deux variables `stop_port_forward`
        et `scale_up` utiliséss, mais qui ne sont pas déclarées dans le fichier.
        Ça rend un peu difficile de suivre d'où elles viennent. La fonction
        serait plus claire si elle était dans le même fichier que la déclaration
        de ces variables.

## Bugs

[x] Ajouter un fichier .gitignore
[x] freescript.log ne devrait probablement pas être commit dans le dépôt Git
[x] Dans `select_namespace`: "à toi de voir si tu retournes 1 ou pas"
[ ] Dans `find_deployment`, le warning dit `skipping scale_down`, j'imagine que ça va pas là.
[ ] Certains messages dans les logs sont en français, d'autres en anglais
[ ] L'affichage des DNS bugs pour les app qui ont plus d'un port
[ ] Dans les menu `select_namespace`, si on tape 0 ça fait un bug de `sed`
[ ] Les PVCs qui viennent d'être unmount s'affichent encore dans le menu tant que le script n'a pas redémarré
[ ] Peut-être mieux de pas hardcoder le timezone à Montréal dans `openssh-server.yaml`
    - Soit le laisser à `UTC`
    - Soit permettre à l'utilisateur de le configurer dans un fichier

## Fonctionnalités

[x] Je suis tellement habitué de bouger avec les touches `hjkl` dans vim, ça serait cool que ça gère ça en plus des flèches dans le menu interactif des PVCs
[x] Ajouter un module pour obtenir les informations des bases de données CNPG
[ ] Ajouter un module volsync
[ ] Garder plusieurs versions du fichier log (ex: 5, ou nombre configurable) plutôt que de l'écraser à chaque fois
[ ] Ajouter des instructions dans le README pour expliquer comment utiliser le script
[ ] Ça serait bien qu'il y ait une option pour afficher les logs des autres pods dans un namespace (plutôt que seulement le principal)
[ ] Automatiser le mount sur l'ordinateur local avec `sshfs` dans un dossier genre `mounted_pvcs/[nom de l'app]`
[ ] Si on peut enlever le mot de passe `apps`, je l'enleverais, pas nécessaire sur une connection interne à mon localhost.
[ ] Il y a des sleeps qui me semblent un peu inutile, quand on veut faire quelque
    chose rapidement, c'est un peu pénible attendre 2 secondes pour rien :P
[ ] Dans `scale_down` (et toutes les fonctions qui font des while true et qui attendent),
    peut-être qu'il devrait y avoir une limite, genre 2 minutes, et que le
    script s'arrête ou retourne au menu principal si ça prend plus longtemps que
    ça, parce que pour l'instant si l'opération est gelée, le script va rester
    gelé à l'infini aussi.
