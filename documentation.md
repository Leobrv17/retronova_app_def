# 📱 Documentation Technique - Retronova App

## 🎯 Vue d'ensemble du projet

**Retronova** est une application mobile développée avec Flutter permettant aux utilisateurs de découvrir, réserver et jouer sur des bornes d'arcade rétro dans leur région. L'application propose un écosystème complet avec un système de tickets virtuels, gestion d'amis, classements et codes promotionnels.

### 🎮 Concept principal

L'application transforme l'expérience des bornes d'arcade traditionnelles en une plateforme moderne et sociale, permettant :
- La géolocalisation des bornes d'arcade
- La réservation de créneaux de jeu
- Un système monétaire virtuel (tickets)
- Une dimension sociale avec amis et classements

---

## 🛠️ Choix technologiques et justifications

### **Framework principal : Flutter**

**Justifications :**
- **Développement cross-platform** : Une seule base de code pour Android et iOS
- **Performance native** : Compilation en code natif pour des performances optimales
- **Écosystème riche** : Large gamme de packages et plugins disponibles
- **Hot Reload** : Développement rapide et itératif
- **Material Design 3** : Interface moderne et cohérente

### **Architecture d'état : Provider Pattern**

**Justifications :**
- **Simplicité** : Plus simple que Bloc ou Riverpod pour une équipe
- **Performance** : Rebuilds optimisés avec Consumer widgets
- **Scalabilité** : Facilement extensible pour de nouvelles fonctionnalités
- **Maintenabilité** : Séparation claire entre logique métier et UI

### **Backend et authentification : Firebase**

**Justifications :**
- **Authentication robuste** : Gestion sécurisée des utilisateurs
- **Rapidité de développement** : Services prêts à l'emploi
- **Scalabilité automatique** : Infrastructure gérée par Google
- **Sécurité** : Tokens JWT et chiffrement intégré

### **API REST personnalisée**

**Justifications :**
- **Flexibilité métier** : Logique spécifique aux bornes d'arcade
- **Performance** : Endpoints optimisés pour les besoins mobiles
- **Contrôle total** : Gestion fine des données et permissions
- **Intégration** : Connexion avec systèmes existants des bornes

---

## 🎯 Objectifs du projet

### **Objectifs utilisateurs**
1. **Découverte simplifiée** : Trouver facilement des bornes d'arcade proches
2. **Réservation fluide** : Éviter les files d'attente physiques
3. **Expérience sociale** : Jouer et comparer ses scores avec des amis
4. **Gamification** : Système de tickets et promotions engageant

### **Objectifs techniques**
1. **Performance** : Application rapide et responsive
2. **Fiabilité** : Gestion robuste des erreurs et états de connexion
3. **Sécurité** : Protection des données utilisateurs et transactions
4. **Maintenabilité** : Code structuré et documenté
5. **Scalabilité** : Architecture prête pour la croissance

### **Objectifs business**
1. **Monétisation** : Vente de tickets virtuels
2. **Fidélisation** : Système d'amis et classements
3. **Analytics** : Suivi des usages et préférences
4. **Marketing** : Codes promotionnels et offres

---

## 🏗️ Architecture de l'application

### **Structure des dossiers**

```
lib/
├── app.dart                    # Configuration principale
├── main.dart                   # Point d'entrée
├── core/                       # Configuration et constantes
│   ├── config/                 # Configuration API et Firebase
│   ├── constants/              # Couleurs, icônes, strings
│   └── theme/                  # Thème Material Design
├── models/                     # Modèles de données
├── providers/                  # Gestion d'état (Provider)
├── services/                   # Services API et authentification
└── presentation/               # Interface utilisateur
    ├── screens/                # Écrans de l'application
    └── widgets/                # Composants réutilisables
```

### **Providers (Gestion d'état)**

1. **AuthProvider** : Authentification Firebase
2. **ArcadeProvider** : Gestion des bornes et réservations
3. **ScoreProvider** : Scores et statistiques
4. **TicketProvider** : Solde de tickets et achats
5. **FriendProvider** : Système d'amis

### **Services**

1. **AuthService** : Interface Firebase Authentication
2. **ApiService** : Gestion utilisateurs via API REST
3. **ArcadeService** : Bornes, jeux et réservations
4. **ScoreService** : Récupération scores et stats
5. **TicketService** : Achats tickets et codes promo
6. **FriendService** : Recherche utilisateurs et amitié

---

## ⚙️ Fonctionnalités implémentées

### 🔐 **Authentification et profil**

**Fonctionnalités :**
- Inscription avec email/mot de passe via Firebase
- Connexion sécurisée avec gestion des erreurs
- Profil utilisateur complet (nom, prénom, pseudo, téléphone, date de naissance)
- Modification du profil en temps réel
- Réinitialisation de mot de passe
- Déconnexion sécurisée

**Implémentation technique :**
- Firebase Authentication pour la sécurité
- Synchronisation avec API REST personnalisée
- Validation côté client (email, téléphone, etc.)
- Gestion des états d'erreur et de chargement

### 🕹️ **Gestion des bornes d'arcade**

**Fonctionnalités :**
- Liste des bornes avec géolocalisation
- Détails complets de chaque borne (jeux disponibles, distance)
- Recherche par nom de borne ou jeu
- Réservation de créneaux de jeu
- Gestion de la file d'attente
- Codes de déverrouillage uniques
- Annulation de réservations

**Implémentation technique :**
- Calcul de distance avec formule de Haversine
- API REST pour les données temps réel
- Gestion des états de réservation (en attente, en cours, terminée)
- Interface utilisateur intuitive avec Material Design

### 🏆 **Système de scores et classements**

**Fonctionnalités :**
- Classements globaux et filtres avancés
- Statistiques personnelles détaillées
- Filtrage par jeu, borne, amis, mode solo/multi
- Historique des parties récentes
- Calcul du taux de victoire
- Séparation parties solo/multijoueur

**Implémentation technique :**
- API optimisée avec paramètres de requête
- Cache local pour performance
- Mise à jour temps réel des statistiques
- Interface responsive pour différentes tailles d'écran

### 🎫 **Système de tickets virtuels**

**Fonctionnalités :**
- Solde de tickets en temps réel
- Différentes offres d'achat avec économies progressives
- Codes promotionnels avec historique
- Historique des achats et transactions
- Calcul automatique des économies
- Statistiques de dépenses

**Implémentation technique :**
- Transactions sécurisées via API
- Mise à jour immédiate du solde
- Validation des codes promo côté serveur
- Interface d'achat intuitive avec confirmations

### 👥 **Système social et amis**

**Fonctionnalités :**
- Recherche d'utilisateurs par pseudo
- Envoi/réception de demandes d'amitié
- Gestion des demandes en attente
- Suppression d'amis
- Invitation d'amis pour parties multijoueur

**Implémentation technique :**
- API de recherche optimisée
- Gestion des états d'amitié (en attente, accepté, rejeté)
- Interface de recherche responsive
- Protection des données personnelles

---

## 🔧 Méthodes de fabrication

### **Approche de développement**

1. **Architecture Driven Development**
    - Conception de l'architecture avant le code
    - Séparation claire des responsabilités
    - Patterns de conception appliqués

2. **API-First Development**
    - Définition des contrats API en amont
    - Développement parallèle frontend/backend
    - Tests avec données mockées

3. **Component-Based Development**
    - Widgets réutilisables
    - Composants atomiques
    - Bibliothèque de composants cohérente

### **Gestion des états**

```dart
// Exemple d'implémentation Provider
class ArcadeProvider with ChangeNotifier {
  List<ArcadeModel> _arcades = [];
  bool _isLoading = false;
  
  Future<void> loadArcades() async {
    _setLoading(true);
    try {
      _arcades = await _arcadeService.getArcades();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
```

### **Gestion des erreurs**

1. **Try-Catch global** dans tous les services
2. **États d'erreur** dans les Providers
3. **Feedback utilisateur** avec SnackBars
4. **Logging** pour le debugging

### **Performance et optimisation**

1. **Lazy Loading** des données
2. **Pagination** pour les listes importantes
3. **Cache local** avec Provider
4. **Optimisation des rebuilds** avec Consumer

### **Sécurité**

1. **Tokens JWT** pour l'authentification
2. **Validation côté client et serveur**
3. **Protection des routes sensibles**
4. **Chiffrement des données sensibles**

---

## 📱 Interface utilisateur

### **Design System**

- **Material Design 3** comme base
- **Couleurs** : Deep Purple (#6200EE) et Teal (#03DAC6)
- **Typography** : Roboto avec hiérarchie claire
- **Navigation** : Bottom Navigation avec 5 onglets principaux

### **Responsive Design**

- **Adaptation automatique** aux différentes tailles d'écran
- **Layout flexible** avec Expanded et Flexible
- **Support tablette** prévu dans l'architecture

### **Accessibilité**

- **Semantic labels** pour les lecteurs d'écran
- **Contraste** respectant les standards WCAG
- **Navigation au clavier** prise en compte

---

## 🚀 Installation et développement

### **Prérequis**

- Flutter SDK 3.8.1+
- Dart SDK 3.0+
- Android Studio ou VS Code
- Compte Firebase configuré
- Émulateur ou appareil physique

### **Configuration**

1. **Cloner le repository**
```bash
git clone https://github.com/votre-username/retronova_app.git
cd retronova_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer Firebase**
- Ajouter `google-services.json` (Android)
- Ajouter `GoogleService-Info.plist` (iOS)

4. **Configurer l'API**
```dart
// lib/core/config/api_config.dart
static const String baseUrl = 'VOTRE_URL_API';
```

5. **Lancer l'application**
```bash
flutter run
```

---

## 🔮 Évolutions futures

### **Version 1.1**
- [ ] Mode hors ligne pour les profils
- [ ] Notifications push pour les réservations
- [ ] Système d'achievements/badges
- [ ] Partage de scores sur les réseaux sociaux

### **Version 1.2**
- [ ] Mode sombre complet
- [ ] Support multilingue
- [ ] Chat en temps réel
- [ ] Tournois organisés
- [ ] Intégration réalité augmentée

### **Optimisations techniques**
- [ ] Migration vers Riverpod
- [ ] Tests automatisés complets
- [ ] CI/CD avec GitHub Actions
- [ ] Analytics avancées
- [ ] Performance monitoring

---

## 📊 Métriques et KPIs

### **Métriques techniques**
- Temps de chargement < 2s
- Taux de crash < 0.1%
- Performance 60 FPS
- Taille APK optimisée

### **Métriques business**
- Taux de conversion achats
- Rétention utilisateurs
- Engagement social
- Satisfaction utilisateur

---

## 🤝 Contribution

L'application suit les **conventions Dart** et utilise les **meilleures pratiques Flutter**. Le code est structuré pour faciliter la collaboration et la maintenance à long terme.

### **Standards de qualité**
- Code review obligatoire
- Tests unitaires pour la logique métier
- Documentation des fonctions publiques
- Respect des patterns établis
