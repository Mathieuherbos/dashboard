# Projet — Dashboard personnel connecté

Contexte pour Claude Code (à garder à jour au fil des modifs).

## C'est quoi

Une application web perso **mono-fichier** : `index.html`. Un dashboard personnel avec onglets :
Objectifs (annuels/mensuels/hebdo/quotidiens), To-Do du jour (récurrentes + ponctuelles, report auto à minuit heure de Bruxelles), Sport (séances + graphiques), Santé (poids, nutrition, arrêt cigarette, check-in humeur/énergie/sommeil), Finances (side business + remboursements), et Vue d'ensemble (graphiques, heatmap, récap hebdo).

## Architecture

- **100% front-end**, aucun build. HTML + CSS + JS vanilla dans un seul fichier.
- Librairies via CDN : Chart.js et `@supabase/supabase-js`.
- **Données** : stockées en `localStorage` (cache/offline) ET synchronisées dans **Supabase** (table `dashboards`, une ligne JSON par utilisateur).
- **Auth** : Supabase, connexion par lien magique email (magic link). Accès privé.
- **Hébergement** : GitHub Pages (branche par défaut, dossier racine).

## Configuration à renseigner

En haut du `<script>` dans `index.html` :
```js
const SUPABASE_URL = "https://TON-PROJET.supabase.co";
const SUPABASE_ANON_KEY = "TA_CLE_ANON_PUBLIQUE";
```
La clé `anon` est publique (protégée par les règles RLS) → OK de la committer.
Ne JAMAIS committer la clé `service_role` ni un token d'accès.

## Base de données

`supabase-init.sql` : crée la table `dashboards` + les policies RLS (chaque user ne voit que sa ligne).

## Modèle de données (résumé)

Objet unique sérialisé en JSON, avec un champ `_mig` (numéro de migration). La fonction `migrate()` applique les évolutions de schéma de façon non destructive. Sous-objets : `objectives`, `recurring`, `todosByDate`, `sport`, `health` (profile, weightByDate, nutritionByDate, customFoods, smoking, checkinByDate), `finances` (incomeGoal, incomeEntries, debts).

## Comment mettre à jour l'app

1. Modifier `index.html`.
2. `git add -A && git commit -m "..." && git push`.
3. GitHub Pages redéploie automatiquement (~1 min).

Pour changer le schéma de données : incrémenter `_mig`, ajouter un bloc `if (d._mig < N) { ... }` dans `migrate()`, mettre à jour `seed()`. Ne jamais écraser les données existantes.

## Verrouillage privé

Dans Supabase → Authentication : Site URL + Redirect URLs = l'URL GitHub Pages. Après la 1re connexion, désactiver les inscriptions ("Allow new users to sign up") pour rester le seul utilisateur.
