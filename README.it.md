<img src="docs/icon.png" alt="Icona" width="180"/>

# Nocturne
### La retroilluminazione della tastiera, secondo i tuoi orari.

*Read me in [English](README.md).*

Nocturne è una piccola app da barra dei menu che spegne la retroilluminazione della tastiera integrata quando non serve: tutto il giorno, negli orari che scegli tu, oppure dall'alba al tramonto ovunque ti trovi. Quando hai finito te la restituisce com'era.

[![Scarica](https://img.shields.io/badge/scarica-ultima%20versione-brightgreen?style=flat-square)](https://github.com/gabriele-rizzo/Nocturne/releases/latest)
![Piattaforma](https://img.shields.io/badge/piattaforma-macOS-blue?style=flat-square)
![Requisiti](https://img.shields.io/badge/requisiti-macOS%2015.7%2B-fa4e49?style=flat-square)
[![Licenza](https://img.shields.io/badge/licenza-PolyForm%20Noncommercial-lightgrey?style=flat-square)](LICENSE)
[![Sito](https://img.shields.io/badge/Sito-015FBA?style=flat-square)](https://gabriele-rizzo.github.io/Nocturne/)

> [!NOTE]
> Nocturne non è autenticata da Apple, quindi macOS la blocca la prima volta che la apri. In [Installazione](#installazione) trovi come sbloccarla, una volta sola.

<a href="https://www.buymeacoffee.com/gabrielerizzo" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60" width="217"></a>

### Installazione

Scarica l'ultima versione, trascina Nocturne nella cartella Applicazioni e aprila. Vive nella barra dei menu, senza finestre e senza icona nel Dock.

In alternativa, con Homebrew:

```
brew tap gabriele-rizzo/nocturne https://github.com/gabriele-rizzo/Nocturne
brew trust gabriele-rizzo/nocturne
brew install --cask nocturne
```

Homebrew chiede di dare fiducia a un tap che non è tra i suoi prima di eseguire il cask.

La prima volta macOS si rifiuta di aprirla, dicendo che non può verificare se contiene software dannoso. È normale, perché Nocturne non è autenticata. Per sbloccarla apri **Impostazioni di Sistema**, vai su **Privacy e sicurezza** e scorri fino alla sezione sulla sicurezza. Lì trovi la riga che dice che Nocturne è stata bloccata, con accanto il pulsante **Apri comunque**. Premilo, conferma con la password o il Touch ID, e Nocturne parte.

Prima bastava fare clic con il tasto destro e scegliere Apri, ma macOS 15 ha tolto questa scorciatoia: ora si passa dalle Impostazioni di Sistema.

Se preferisci il Terminale, questo fa la stessa cosa:

```
xattr -dr com.apple.quarantine /Applications/Nocturne.app
```

In ogni caso lo fai una volta sola. Gli aggiornamenti si installano senza chiedertelo di nuovo.

Puoi anche compilarla da te. Vedi [Compilazione](#compilazione).

### Utilizzo

Nocturne mette un'icona nella parte destra della barra dei menu. Premila per scegliere quando la retroilluminazione deve restare spenta.

<img src="docs/menu-bar-icon.png" alt="L'icona di Nocturne nella barra dei menu" width="378"/>

Ci sono quattro modalità:

- **Sempre acceso**: Nocturne si fa da parte e la retroilluminazione si comporta normalmente.
- **Sempre spento**: la retroilluminazione resta spenta.
- **Dal tramonto all'alba**: la retroilluminazione è spenta di giorno e torna quando fa buio. Usa il crepuscolo civile, così cambia quando è davvero buio e non nell'istante in cui il sole attraversa l'orizzonte.
- **Personalizzato**: scegli tu le ore in cui deve restare spenta.

<img src="docs/menu.png" alt="Il menu di Nocturne" width="207"/>

Gli orari personalizzati si impostano dal sottomenu, un'ora di inizio e una di fine. Gli intervalli che passano la mezzanotte funzionano, quindi dalle 22:00 alle 07:00 fa quello che ti aspetti.

<img src="docs/custom-schedule.png" alt="Il sottomenu Personalizzato, con l'elenco delle ore di inizio aperto" width="385"/>

**Sospendi per un'ora** mette da parte la programmazione e restituisce la retroilluminazione per un'ora, per quando ti serve vedere i tasti adesso. Compare quando una programmazione potrebbe tenere spenta la luce, e diventa **Riprendi la programmazione** mentre è attiva. Passata l'ora, la programmazione riprende da sola.

**Impedisci attenuazione** evita che macOS abbassi la retroilluminazione dopo un minuto di inattività. È disattivata di default, e Nocturne rimette la tua impostazione originale quando esce.

**Apri al login** avvia Nocturne automaticamente. La prima volta macOS potrebbe chiederti di approvarla nelle Impostazioni di Sistema.

Dal tramonto all'alba ha bisogno della tua posizione per calcolare quando sorge e tramonta il sole. Nocturne calcola gli orari solo in locale, e non invia niente da nessuna parte. Trattandosi di un'app da barra dei menu, macOS potrebbe non mostrare la richiesta di autorizzazione, perciò il menu offre una scorciatoia alle impostazioni di Localizzazione se serve concederla.

### Aggiornamenti

Nocturne sa aggiornarsi da sola: scarica e installa sul posto, quindi non devi trascinare niente nella cartella Applicazioni una seconda volta.

Non controlla di sua iniziativa finché non glielo permetti. Dopo che l'hai usata per un po', Nocturne fa la domanda una volta, e se dici di no non insiste. **Impostazioni…** nel menu, oppure ⌘S, apre una finestra dove puoi controllare subito, cambiare idea sui controlli automatici, o lasciare che gli aggiornamenti si installino senza chiedere.

Ogni versione è firmata con una chiave che ha solo il progetto, e Nocturne non installa nulla che non corrisponda.

### Compilazione

Richiede macOS 15.7 o successivo e Xcode 26 o successivo.

```
git clone https://github.com/gabriele-rizzo/Nocturne.git
cd Nocturne
open Nocturne.xcodeproj
```

Non serve configurare la firma, perché il progetto compila ad-hoc così com'è.

Per firmare con il tuo team di sviluppo Apple, crea un `Local.xcconfig` accanto al progetto:

```
DEVELOPMENT_TEAM = ILTUOTEAMID
CODE_SIGN_IDENTITY = Apple Development
```

È nel gitignore, quindi resta fuori dal repository.

Esegui i test con:

```
xcodebuild test -project Nocturne.xcodeproj -scheme Nocturne -destination 'platform=macOS'
```

### Pubblicare una versione

Basta pubblicare un tag `v`. Il workflow compila l'immagine disco, firma uno zip per l'aggiornatore, scrive l'appcast e pubblica tutti e tre.

La versione arriva dal tag, quindi non c'è niente da modificare prima. `Scripts/version.sh` trasforma `v1.2.0` in una versione `1.2.0` e in un numero di build `10200`, impacchettando major, minor e patch in modo che il numero cresca sempre. La versione nel file di progetto è solo quella che riportano le build locali.

Le note di rilascio sono gli oggetti dei commit dal tag `v` precedente, esclusi quelli che alzano la versione e quelli che puntano il cask, quindi quegli oggetti li legge chi aggiorna. A decidere che cosa conta è `Scripts/release-notes.sh`, che viene chiamato sia dall'appcast sia dal changelog del sito, così i due non si allontanano mai.

Per firmare l'aggiornamento serve la chiave privata di Sparkle in un segreto del repository chiamato `SPARKLE_PRIVATE_KEY`, corrispondente alla chiave pubblica in `Signing.xcconfig`.

### Domande frequenti

##### Consuma o danneggia qualcosa?

No. Nocturne imposta solo la luminosità della retroilluminazione, lo stesso valore che cambiano i tasti F5 e F6. Tutto ciò che tocca viene ripristinato quando esce.

##### Perché a volte la retroilluminazione si riaccende da sola?

macOS regola la retroilluminazione in base al sensore di luce ambientale e la attenua dopo un minuto di inattività. Mentre Nocturne tiene spenta la retroilluminazione disattiva il sensore, così i due non si contendono il controllo, e lo riattiva subito dopo: la retroilluminazione resta quindi sensibile alla luce della stanza ogni volta che le è concesso di accendersi.

##### Funziona con una tastiera esterna?

Nocturne agisce sulla tastiera integrata. Le tastiere esterne gestiscono la propria retroilluminazione e non sono interessate.

##### Perché non è sull'App Store?

Nocturne usa un framework privato di Apple per raggiungere la retroilluminazione, perché non esiste un'API pubblica. Questo esclude l'App Store, e significa anche che una futura versione di macOS potrebbe cambiare quell'interfaccia e romperla. Se Nocturne smette di funzionare dopo un aggiornamento di sistema, la causa è probabilmente questa: apri pure una issue.

##### Cosa succede se va in crash mentre la retroilluminazione è spenta?

Registra quello che ha modificato, così al riavvio successivo rimette a posto luminosità, timer di attenuazione e sensore di luce, invece di lasciarti la tastiera al buio.

### Traduzioni

Nocturne è disponibile in inglese e italiano. Le traduzioni si trovano in `Nocturne/Localizable.xcstrings` e `Nocturne/InfoPlist.xcstrings`, che in Xcode si aprono come cataloghi di stringhe. Aggiungere una lingua è un contributo autonomo: scegli la lingua nell'editor del catalogo, compila i valori, e aggiungi il codice della lingua alle lingue note del progetto.

### Licenza

Nocturne è distribuita con la [PolyForm Noncommercial License 1.0.0](LICENSE). Puoi usarla, modificarla e condividerla per qualsiasi scopo non commerciale. Venderla, o usarla come parte di un prodotto o servizio commerciale, non è consentito.
