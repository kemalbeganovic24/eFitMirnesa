# 🏋️‍♀️ eFitMirnesa

**eFitMirnesa** je native iOS aplikacija izgrađena u **SwiftUI** frameworku, namijenjena vođenju i praćenju rada sa klijentima u fitness studiju. Omogućava potpunu evidenciju članova, razdvojeno praćenje treninga (grupni i individualni), te vođenje precizne historije tjelesnih mjera i uplata.

---

## 🚀 Ključne funkcionalnosti

### 👥 Upravljanje članovima
- Dodavanje novih članova sa osnovnim podacima (telefon, datum rođenja, mjesec registracije)
- Pregled statusa i filtriranje članova po mjesecima
- Karton člana sa kompletnom historijom uplata i treninga

### 🏋️‍♂️ Evidencija treninga
- **Individualni treninzi:** grupni unos prisutnosti za individualne klijente, pohranjen u centralnu `trainings` kolekciju
- **Grupni treninzi:** zaseban unos koji se upisuje direktno u `trainingsHistory` kartona svakog člana sa oznakom `type: "grupni"`
- **Retroaktivni unos:** `DatePicker` omogućava evidenciju treninga za bilo koji izabrani datum, ne samo za današnji

### 📅 Kalendar i pregled dolazaka
- Pregled prisutnosti po izabranom datumu
- Preklopnik **Grupni / Individualni** za trenutno filtriranje vrste treninga
- Brisanje pogrešno unesenih treninga direktno iz kalendara (*swipe-to-delete*)

### 📐 Praćenje mjerenja i napretka
- Evidencija tjelesnih mjera: `chest`, `waist`, `hips`, `arms`, `legs`, `upperWaist`, `lowerWaist`
- Podrška za decimalne vrijednosti uz pametno parsiranje zareza i tačke (`parseDouble` helper)

---

## 🛠️ Tehnologije i arhitektura

| Dio | Tehnologija |
|---|---|
| Jezik | Swift 5 |
| UI | SwiftUI |
| Arhitektura | MVVM (Model-View-ViewModel) |
| Baza | Firebase Firestore (listeneri u realnom vremenu) |
| Reaktivnost | Combine, `@Published` svojstva |

---

## 📱 Ekrani aplikacije

| Ekran | Opis |
|---|---|
| `ActivitySelectionView` | Glavni meni sa karticama za brzu navigaciju |
| `KartoniClanovaView` / `OClanuView` | Pregled članova, detaljni karton, uplate i mjerenja |
| `GrupniTreningView` | Unos grupnih treninga po datumima |
| `IndividualniTreningView` | Unos individualnih treninga |
| `CalendarView` | Dnevni kalendar sa brisanjem i filtriranjem dolazaka |

---

## 🔧 Podešavanje i pokretanje

### Zahtjevi

- macOS sa **Xcode** (novija verzija)
- iOS simulator ili iPhone
- Firebase projekat sa uključenim **Firestore**-om

### Koraci

1. Kloniraj repozitorij:
   ```bash
   git clone https://github.com/tvoj-username/eFitMirnesa.git
   cd eFitMirnesa
   ```
2. Otvori projekat u Xcodeu (`.xcodeproj` ili `.xcworkspace`).
3. Dodaj svoj Firebase konfiguracijski fajl **`GoogleService-Info.plist`** u projekat
   (Firebase Console → Project settings → Your apps → iOS → Download), uz čekiranu opciju *Copy items if needed*.
4. Sačekaj da Xcode preuzme zavisnosti (Firebase SDK).
5. Odaberi simulator ili uređaj i pokreni (**Run ▶**).

---

## 🗄️ Struktura podataka (Firestore)

- **`members`**: članovi sa osnovnim podacima, uplatama, mjerenjima i podkolekcijom `trainingsHistory`
- **`trainings`**: individualni treninzi (prisutnost po datumu)

> Nazive kolekcija uskladi sa stvarnom bazom ako se razlikuju.

---

## ⚠️ Napomene

- `GoogleService-Info.plist` sadrži konfiguraciju Firebase projekta, pa ga razmisli ne objavljivati ako je repozitorij javan.
- Za produkciju podesi **Firebase Security Rules**, jer aplikacija čuva lične podatke članova (telefon, datum rođenja).

---

## 👤 Autor

Kemal Beganović
