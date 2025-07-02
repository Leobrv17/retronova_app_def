# 🎮 Retronova App

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Retronova** est une application mobile Flutter permettant aux utilisateurs de découvrir, réserver et jouer sur des bornes d'arcade retro dans leur région. L'application offre un système de tickets virtuels, un système d'amis, et des classements pour une expérience de jeu social complète.

## 🚀 Fonctionnalités

### 🕹️ Arcade & Réservations
- **Découverte de bornes** : Parcourez les bornes d'arcade près de chez vous
- **Réservation de parties** : Réservez des créneaux de jeu avec un système de file d'attente
- **Gestion des codes de déverrouillage** : Codes uniques pour débloquer vos parties
- **Support multijoueur** : Invitez vos amis pour des parties en équipe

### 🎯 Système de Scores
- **Classements globaux** : Comparez vos performances avec tous les joueurs
- **Statistiques personnelles** : Suivez vos victoires, défaites et progression
- **Filtres avancés** : Filtrez par jeu, borne, amis ou mode de jeu
- **Historique des parties** : Consultez toutes vos parties passées

### 🛒 Boutique & Tickets
- **Achat de tickets** : Différentes offres avec économies progressives
- **Codes promo** : Utilisez des codes promotionnels pour obtenir des tickets gratuits
- **Historique des achats** : Suivez tous vos achats et utilisations de codes
- **Solde en temps réel** : Consultez votre solde de tickets à tout moment

### 👥 Système Social
- **Ajout d'amis** : Recherchez et ajoutez des joueurs
- **Demandes d'amitié** : Gérez vos demandes entrantes et sortantes
- **Parties entre amis** : Invitez vos amis pour des sessions de jeu

### 👤 Profil Utilisateur
- **Authentification Firebase** : Connexion sécurisée avec email/mot de passe
- **Profil personnalisable** : Modifiez vos informations personnelles
- **Statistiques détaillées** : Consultez vos performances globales

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── app.dart                    # Configuration principale de l'app
├── main.dart                   # Point d'entrée
├── core/                       # Configuration et constantes
│   ├── config/
│   ├── constants/
│   └── theme/
├── models/                     # Modèles de données
├── providers/                  # Gestion d'état (Provider pattern)
├── services/                   # Services API et authentification
└── presentation/              # Interface utilisateur
    ├── screens/
    └── widgets/
```

### Technologies
- **Framework** : Flutter 3.8.1+
- **Authentification** : Firebase Auth
- **Gestion d'état** : Provider Pattern
- **API** : REST API avec authentification JWT
- **Validation** : Email Validator
- **Requêtes HTTP** : Package HTTP de Dart

## 🛠️ Installation

### Prérequis
- Flutter SDK 3.8.1 ou supérieur
- Dart SDK 3.0+
- Android Studio / VS Code
- Compte Firebase
- Émulateur Android/iOS ou appareil physique

### Configuration Firebase

1. **Créez un projet Firebase** sur [Firebase Console](https://console.firebase.google.com)

2. **Activez l'authentification** :
    - Allez dans Authentication > Sign-in method
    - Activez "Email/Password"

3. **Ajoutez les fichiers de configuration** :
   ```bash
   # Android
   android/app/google-services.json
   
   # iOS
   ios/Runner/GoogleService-Info.plist
   ```

### Installation des dépendances

```bash
# Clonez le repository
git clone https://github.com/votre-username/retronova_app.git
cd retronova_app

# Installez les dépendances Flutter
flutter pub get

# Pour iOS, installez les CocoaPods
cd ios
pod install
cd ..
```

### Configuration de l'API

Modifiez le fichier `lib/core/config/api_config.dart` :

```dart
class ApiConfig {
  static const String baseUrl = 'VOTRE_URL_API_ICI';
  // ...
}
```

## 🚀 Lancement

### Développement
```bash
# Vérifiez la configuration
flutter doctor

# Lancez l'application
flutter run

# Mode debug avec hot reload
flutter run --debug

# Mode release
flutter run --release
```

### Build de Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommandé pour Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🏛️ Architecture des Providers

L'application utilise le pattern Provider pour la gestion d'état :

### AuthProvider
- Gestion de l'authentification Firebase
- États de connexion/déconnexion
- Gestion des erreurs d'authentification

### ArcadeProvider
- Gestion des bornes d'arcade
- Réservations et annulations
- Recherche et filtrage

### ScoreProvider
- Récupération des scores et classements
- Statistiques personnelles
- Filtres de scores

### TicketProvider
- Gestion du solde de tickets
- Achats et codes promo
- Historique des transactions

### FriendProvider
- Système d'amis
- Recherche d'utilisateurs
- Gestion des demandes d'amitié

## 🎨 Thème et Design

L'application utilise Material Design 3 avec :
- **Couleur principale** : Deep Purple (#6200EE)
- **Couleur secondaire** : Teal (#03DAC6)
- **Interface responsive** : Support tablettes et téléphones
- **Mode sombre** : Prêt pour l'implémentation

## 🔐 Sécurité

- **Authentification** : Firebase Auth avec tokens JWT
- **Validation côté client** : Validation des formulaires et emails
- **Headers sécurisés** : Tokens d'authentification dans toutes les requêtes API
- **Gestion d'erreurs** : Gestion robuste des erreurs réseau et d'authentification

## 📱 Plateformes Supportées

- ✅ Android (API 23+)
- ✅ iOS (12.0+)
- 🔄 Web (en développement)

## 🧪 Tests

```bash
# Lancer tous les tests
flutter test

# Tests avec couverture
flutter test --coverage

# Tests d'intégration
flutter drive --target=test_driver/app.dart
```

## 📦 Dépendances Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.14.0
  firebase_auth: ^5.6.0
  provider: ^6.1.5
  http: ^1.4.0
  email_validator: ^2.1.17
  flutter_localizations:
    sdk: flutter
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. **Fork** le projet
2. **Créez** votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Commitez** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrez** une Pull Request

### Standards de Code
- Suivez les [conventions Dart](https://dart.dev/guides/language/effective-dart)
- Utilisez `flutter analyze` pour vérifier le code
- Ajoutez des tests pour les nouvelles fonctionnalités
- Documentez les fonctions publiques

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

- **Développeur Principal** - [@votre-username](https://github.com/votre-username)

## 📞 Support

Pour toute question ou problème :
- 🐛 [Issues GitHub](https://github.com/votre-username/retronova_app/issues)
- 📧 Email : support@retronova.com
- 💬 Discord : [Serveur Retronova](https://discord.gg/retronova)

## 🗺️ Roadmap

### Version 1.1 (Prochaine)
- [ ] Mode hors ligne pour les profils
- [ ] Notifications push pour les réservations
- [ ] Système de achievements/badges
- [ ] Partage de scores sur les réseaux sociaux

### Version 1.2 (Futur)
- [ ] Mode sombre complet
- [ ] Support des langues multiples
- [ ] Chat en temps réel
- [ ] Tournois organisés

---

<div align="center">
  <p><strong>Fait avec ❤️ et Flutter</strong></p>
  <p>© 2024 Retronova. Tous droits réservés.</p>
</div>