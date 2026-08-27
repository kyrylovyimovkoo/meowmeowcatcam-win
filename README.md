# Meowmeow cat cam meme detector

Kieruj kamerkę na siebie, zrób minę albo gest ręką i w czasie rzeczywistym dostajesz w zamian kociego mema. Działa jako appka desktopowa (okna OpenCV) albo całkowicie w przeglądarce (MediaPipe WASM, bez instalacji).

Dwa okna/panele obok siebie:
- **Camera** — obraz z kamerki z naniesionymi punktami dłoni, plus podgląd debugowy na żywo w rogu
- **Meme** — mem pasujący do gestu, który akurat robisz

## Gesty

Sprawdzane w tej kolejności — jeśli poza pasuje do więcej niż jednego gestu, wygrywa ten wcześniejszy.

| # | Gesture | Jak wywołać |
|---|---|---|
| 1 | Muehehe | Obie ręce w górze, tylko wyprostowane palce wskazujące, czubki się stykają |
| 2 | You're late! cat | Jedna ręka wskazuje, jej czubek palca blisko nadgarstka drugiej ręki ("pokazujesz na zegarek") |
| 3 | Devo cat | Obie ręce w górze, powyżej czubka głowy |
| 4 | Crash out cord chewing kitty | Obie ręce przy twarzy, jakbyś trzymał(a) pyszny kabelek elektryczny do pogryzienia |
| 5 | Thumbs up cat | Jedna ręka, kciuk wystawiony, reszta palców zwinięta |
| 6 | I will punch you | Jedna ręka, wszystkie cztery palce zwinięte, kciuk schowany |
| 7 | EHHEHEEEHEEEE | Kciuk i mały palec wyprostowane, gest rockstara |
| 8 | Shhh silenced cat | Tylko palec wskazujący, czubkiem opartym o usta |
| 9 | Laugh and point cat | Tylko palec wskazujący, wycelowany prosto w obiektyw (nie w górę) — palec mocno się skraca w 2D, a jego czubek wypada bliżej kamery niż nadgarstek |
| 10 | Erm ackshuALLY! cat | Tylko palec wskazujący, trzymany z dala od twarzy |
| 11 | Shocked/kidnapped cat | Ręka zakrywająca usta |
| 12 | gGIMME MONIE!! | Jedna otwarta dłoń, wszystkie palce wyprostowane, z dala od twarzy |
| 13 | Side eye cat | Odwróć głowę o 15°+ w dowolną stronę (prawdziwy odczyt yaw pozycji głowy) |
| 14 | Pokercat | Domyślny |
| 15 | Spinny OIIAI cat | Kręcisz się!!!! |

Obrazki memów leżą w `memes/`. Część gestów losuje spośród kilku obrazków.

Gestów jest 15, ale plików w `memes/` — 21, bo pięć gestów losuje między kilkoma obrazkami zamiast trzymać się jednego:
- Muehehe — 3 pliki
- Pokercat — 2 pliki
- Erm ackshuALLY! cat — 2 pliki
- Thumbs up cat — 2 pliki
- Shocked/kidnapped cat — 2 pliki

Reszta gestów ma po jednym pliku (w tym `spin cat.mov` dla Spinny OIIAI cat — to jedyny gest z filmikiem zamiast obrazka).

## Uruchomienie — desktop (Python)

Wymaga Pythona 3 i kamerki.

Najprościej: kliknij dwa razy **`Launch Gesture Meme.command`**. Pierwsze uruchomienie zajmuje z minutę (samo się wszystko instaluje), potem startuje od razu. Każde kolejne uruchomienie jest już błyskawiczne.

**Przy pierwszym uruchomieniu:** macOS pokaże ostrzeżenie, że aplikacja pochodzi od niezidentyfikowanego dewelopera ("cannot be opened because it is from an unidentified developer") — to normalne przy każdym pobranym skrypcie, nie tylko przy tym. Kliknij plik prawym przyciskiem → **Otwórz** → potwierdź **Otwórz** w oknie, które się pojawi. Trzeba to zrobić tylko raz.

Albo ręcznie, jeśli wolisz terminal:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 gesture_meme.py
```

Wciśnij `q` lub `Esc` w oknie Camera, żeby wyjść.

## Uruchomienie na Windowsie

1. Na stronie repo: **Code → Download ZIP**.
2. Rozpakuj archiwum do `C:\Users\Public\mycat` (albo innego folderu, którego ścieżka
   składa się wyłącznie ze zwykłych liter łacińskich i cyfr). Ścieżka **nie może**
   zawierać cyrylicy ani polskich znaków (ą, ć, ę, ł, ń, ó, ś, ź, ż) — mediapipe
   wysypuje się wtedy przy starcie błędem `get_runfiles_dir_helper.cc: srcdir is
   not accessible`. Sprawdzone na żywym organizmie: folder w katalogu użytkownika
   zapisanym cyrylicą nie działa.
3. Zainstaluj Python 3 ze Microsoft Store (jeśli jeszcze go nie masz).
4. Dwuklik na **`Uruchom.bat`** w głównym folderze repo. Jeśli Windows pokaże
   ostrzeżenie SmartScreen, kliknij **Więcej informacji → Uruchom mimo to**.
5. Pierwsze uruchomienie instaluje biblioteki i trwa 1-2 minuty, kolejne
   startują od razu.
6. Wyjście z programu: `q` lub `Esc` w oknie Camera.

## Uruchomienie — przeglądarka

Nie trzeba niczego instalować, ale API kamerki wymaga serwowania po HTTP (otwarcie `index.html` bezpośrednio jako URL `file://` nie da uprawnień do kamerki). Z poziomu tego folderu:

```bash
python3 -m http.server 8000
```

Potem otwórz `http://localhost:8000` i zezwól na dostęp do kamerki. Modele ładują się w locie z CDN-a MediaPipe hostowanego przez Google, więc do wersji przeglądarkowej nic lokalnie nie jest potrzebne.

## Podgląd debugowy na żywo

Okno Camera zawsze pokazuje mały odczyt w lewym górnym rogu:

```
gesture: sideEyeCat
yaw: +18.4 deg  (side-eye thr +/-15.0)
```

Przydaje się do strojenia progów detekcji na górze `gesture_meme.py` / `app.js`, jeśli jakiś gest łapie się za łatwo albo za rzadko przy Twoim ustawieniu/oświetleniu.

## Struktura projektu

```
gesture_meme.py   wersja desktopowa (OpenCV + MediaPipe Python tasks API)
app.js            wersja przeglądarkowa (MediaPipe tasks-vision WASM)
index.html        szkielet UI przeglądarki
memes/            obrazki memów (+ jeden filmik, na razie nieużywany)
models/           pliki modeli MediaPipe .task używane przez wersję desktopową
requirements.txt  zależności Pythona
```
