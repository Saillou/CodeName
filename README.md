# Le jeu

Petit plagiat de code names


## Prerequis

- Godot 4.6 ou une version compatible Godot 4.x
- Windows, Linux ou macOS

## Lancer le projet

1. Ouvrir Godot.
2. Cliquer sur `Import`.
3. Selectionner le fichier `project.godot` de ce dossier.
4. Ouvrir le projet.
5. Lancer la scene principale avec `F5`.

La scene principale est `Scenes/Game.tscn`.

## Comment jouer

- Une grille de 25 cartes est generee.
- Chaque carte contient un mot tire de `resources/WordList.txt`.
- Les couleurs sont reparties aleatoirement :
  - 8 cartes bleues
  - 8 cartes rouges
  - 8 cartes grises
  - 1 carte noire
- Cliquer sur une carte la retourne.
- Le bouton de regeneration melange les mots et les couleurs.
- La fenetre de reponse affiche la grille des couleurs, utile pour verifier ou animer une partie.

## Structure du projet

```text
Scenes/
  Game.tscn                 Scene principale
  Card.tscn                 Scene d'une carte
  Answer.tscn               Fenetre de reponse
  Scripts/
    game.gd                 Logique principale du jeu
    game_config.gd          Constantes globales
    card.gd                 Comportement d'une carte
    card_area.gd            Detection souris sur une carte
    card_data.gd            Donnees d'une carte
    answer.gd               Affichage de la solution
    dev/smoke_test_runner.gd Test rapide du projet

resources/
  WordList.txt              Liste des mots
  Sounds/flip.mp3           Son joue au retournement
```

## Points importants du code

### `game.gd`

Ce script pilote la partie :

- charge les mots depuis `resources/WordList.txt` ;
- cree un paquet de couleurs ;
- instancie 25 cartes depuis `Scenes/Card.tscn` ;
- place les cartes en grille ;
- melange les mots et les couleurs ;
- connecte les signaux des cartes ;
- joue le son quand une carte est retournee.

C'est un bon point d'entree pour comprendre comment une scene principale coordonne plusieurs objets.

### `card.gd`

Ce script gere une carte individuelle :

- modification du texte ;
- modification des couleurs ;
- animation de survol ;
- animation de retournement ;
- emission du signal `flipped`.

Il montre bien comment encapsuler le comportement d'un objet reutilisable.

### `card_area.gd`

Ce script transforme les evenements souris 3D en signaux plus simples :

- `clicked`
- `hovered`
- `unhovered`

C'est pratique pour separer la detection d'entree utilisateur du comportement visuel de la carte.

### `answer.gd`

Ce script gere la fenetre de reponse. Il cree une petite grille de `ColorRect` pour afficher les couleurs des cartes.

Il contient aussi une astuce interessante : la fenetre est placee a cote de la fenetre principale apres une frame, avec `call_deferred` et `await get_tree().process_frame`.

## Modifier la liste des mots

Les mots sont dans :

```text
resources/WordList.txt
```

Un mot par ligne suffit. Le jeu ignore les lignes vides.

Il faut au moins 25 mots pour remplir toutes les cartes. Si la liste est trop courte, le jeu risque de rencontrer une erreur quand il essaie d'acceder a un mot inexistant.

## Modifier la taille de la grille

La taille de la grille est definie dans :

```gdscript
const N_ROWS := 5
const N_COLS := 5
```

dans `Scenes/Scripts/game_config.gd`.

Si vous changez ces valeurs, pensez aussi a adapter :

- le nombre de couleurs creees dans `game.gd` ;
- le test `EXPECTED_CARD_COUNT` dans `Scenes/Scripts/dev/smoke_test_runner.gd` ;
- la liste de mots si la grille contient plus de cartes.

## Lancer le smoke test

Le projet contient un test tres simple qui verifie que la scene cree bien 25 cartes.

Avec Godot en ligne de commande :

```powershell
Godot_v4.6-stable_win64_console.exe --headless --path . -s res://Scenes/Scripts/dev/smoke_test_runner.gd
```

Le test affiche `Smoke test: passed` si tout va bien.
