# Roadmap — Mini Connected Locker

Projet fil rouge pour monter en compétences sur la stack iOS/IoT visée par le poste **iOS Software Engineer – Connected Locker (DSU)** chez Decathlon Digital : Swift, SwiftUI, CoreBluetooth (BLE), MQTT, AWS IoT.

**Objectif final** : une app iOS qui lit la fréquence cardiaque d'un appareil BLE (Heart Rate Service, UUID standard `0x180D`), l'affiche en live, et publie les mesures vers le cloud via MQTT/AWS IoT Core.

**Pourquoi ce projet** : il reproduit le pattern exact du poste (device physique → BLE → app iOS → cloud), sans nécessiter de matériel Decathlon — le profil Heart Rate BLE est un standard ouvert présent sur beaucoup d'appareils, ou simulable avec une app "BLE peripheral simulator".

---

## Phase 1 — Bases Swift & SwiftUI
**Durée estimée : 1-2 semaines**

- [ ] Swift : optionnels, closures, `async/await`, protocoles/generics
- [ ] SwiftUI : `@State`, `@Published` / `ObservableObject` (ou `@Observable`), navigation simple
- [ ] Livrable : petite app SwiftUI à état (compteur, formulaire) pour valider les bases

## Phase 2 — CoreBluetooth / BLE
**Durée estimée : 1-2 semaines**

- [ ] Comprendre le modèle BLE : Peripheral / Central, Services, Characteristics
- [ ] Implémenter un `CBCentralManager` : scan, connexion, lecture des notifications du Heart Rate Service (`0x180D`)
- [ ] Tester avec un vrai appareil ou une app de simulation BLE peripheral
- [ ] Livrable : app qui scanne, se connecte, affiche le BPM en live dans une vue SwiftUI

## Phase 3 — Architecture modulaire
**Durée estimée : 1 semaine**

- [ ] Extraire la logique BLE dans un Swift Package séparé (`HeartRateKit`)
- [ ] Exposer une interface propre via Combine ou `AsyncStream`
- [ ] Ajouter un mode mock ("fake peripheral") pour tester sans BLE réel
- [ ] Livrable : package réutilisable + app de démo qui le consomme

## Phase 4 — MQTT
**Durée estimée : 1 semaine**

- [ ] Intégrer un client MQTT Swift (ex. CocoaMQTT)
- [ ] Monter un broker de test (HiveMQ public broker, ou Mosquitto via Docker)
- [ ] Publier les données BPM en temps réel sur un topic MQTT
- [ ] Livrable : données BLE visibles en live sur le broker (via MQTT Explorer)

## Phase 5 — AWS IoT Core
**Durée estimée : 1-2 semaines**

- [ ] Créer un IoT Thing sur AWS, générer certificats et policy
- [ ] Connecter l'app à AWS IoT Core (TLS mutuel) à la place du broker de test
- [ ] Ajouter une IoT Rule pour router les messages vers DynamoDB ou un dashboard
- [ ] Livrable : pipeline complet BLE → iPhone → MQTT/AWS IoT → stockage/visualisation

## Phase 6 — Polish & présentation
**Durée estimée : quelques jours**

- [ ] README avec schéma d'architecture (BLE ↔ App ↔ MQTT ↔ AWS IoT)
- [ ] Historique Git qui montre la progression phase par phase
- [ ] Courte démo (vidéo ou GIF) pour l'entretien

---

**Durée totale réaliste** : 5 à 8 semaines en parallèle d'une activité pro à temps plein.