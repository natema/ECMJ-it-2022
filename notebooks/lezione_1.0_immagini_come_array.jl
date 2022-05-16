### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 393ab172-cb31-11ec-1295-cd4041170c04
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ 390fe1cb-08cd-40e9-9468-7594f50b93ce
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)
"""

# ╔═╡ c47fba6d-6423-49c0-acfe-3a4143c5a5ed
md"""
Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ 582880c1-c8dc-4d80-b74f-8639bffc096d
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 37660976-adff-4f3d-96e4-ac7ef58f5912
md"""
# Lezione 1.0 - Immagini come array
"""

# ╔═╡ ec7886c4-2523-4e46-a4ad-8d27a6071c17
md"""
#### Inizializzazione dei pacchetti Julia

_Quando si esegue questo notebook per la prima volta, possono essere necessari vari minuti. Non demordete!_
"""

# ╔═╡ f502e214-c212-4824-a32f-6faf99d4a67a
md"""
Inizieremo analizzando delle **immagini** e come possiamo elaborarle. 
Il nostro obiettivo è quello di trasformare in qualche modo i dati contenuti in un'immagine, cosa che faremo progettando e programmando alcuni **algoritmi**.

Se apriamo un'immagine sul nostro computer o sul web e la ingrandiamo abbastanza, vedremo che consiste di molti piccoli quadrati, o **pixel** ("elementi dell'immagine"). Ogni pixel è un blocco di un solo colore e i pixel sono disposti in una griglia quadrata bidimensionale. 

Probabilmente sapete già che questi pixel vengono rappresentati da un computer numericamente, tipicamente in un qualche tipo di formato RGB (rosso, verde, blu).  

Si noti che un'immagine è già un'**approssimazione** del mondo reale - è una rappresentazione bidimensionale e discreta di una realtà tridimensionale.
"""

# ╔═╡ 95535bfa-b5d2-4a51-b6a2-37fa3c433994
md"""
## Caricare e visualizzare un'immagine in Julia

Utilizzeremo Julia per caricare immagini reali e manipolarle. Possiamo scaricare immagini da Internet, da un file locale o dalla propria webcam.
"""

# ╔═╡ 9804f339-ebea-46ef-850a-051b133ba95b
md"""
### Scaricare un'immagine da internet o da un file locale
Possiamo usare il pacchetto `Images.jl` per caricare un'immagine in tre passi.
"""

# ╔═╡ b850c9b2-5605-4e88-b97e-b74fac45f592
md"""
Passo 1: (da internet) specifichiamo l'URL (indirizzo web) da cui scaricare:
$(html"<br>")
(si noti che Pluto mette i risultati prima dei comandi perché in alcune circostanze l'output ci interessa più del codice.  Ci vuole un po' per abituarcisi).
"""

# ╔═╡ 35238013-e079-46e1-a3a1-885fca7d50e4
url = "https://www-sop.inria.fr/members/Emanuele.Natale/images/zerocalcare_ricerca.png" 

# ╔═╡ e5a15ad7-254a-49b3-952a-7a740fbf504e
md"""
Passo 2: Ora usiamo la funzione `download` per scaricare il file dell' immagine sul nostro computer. 
"""

# ╔═╡ be4bf585-c4a0-4192-87d1-753152872f2b
zerocal_filename = download(url) # scaricare in un file locale. Il nome del file viene restituito

# ╔═╡ 77305f11-9e66-434b-ad13-726c920a0b89
md"""
Passo 3:
Usando il pacchetto `Images.jl` (caricato all'inizio di questo notebook) possiamo **caricare** il file, che automaticamente viene convertito in dati che possiamo manipolare. Memorizzeremo il risultato in una variabile.
"""

# ╔═╡ 58d3f8be-12f2-447c-a7e1-fb5c2bb489fb
zerocal = load(zerocal_filename)

# ╔═╡ 0a15e9d4-6e2c-4f82-a465-ff4d33319e67
md"""
Vediamo che il Pluto notebook ha riconosciuto che abbiamo creato un oggetto che rappresenta un'immagine e ha visualizzato automaticamente l'immagine risultante, ovvero un disegno del famoso fumettista Zerocalcare.

- Esercizio: cambiare l'url.
- Esercizio: caricare un file che si trova già sul proprio computer.
"""

# ╔═╡ 678176f0-3b49-434f-838d-ff6695cf1d2e
md"""
### Acquisire un'immagine dalla propria videocamera

Provate a premere il pulsante di abilitazione qui sotto, e poi
premere la videocamera per acquisire un'immagine.
"""

# ╔═╡ 38001b21-60b6-4699-b582-fc407a31202c
md"""
A breve vedremo in dettaglio come ottenere immagini come la seguente: 
"""

# ╔═╡ 8106abce-c2a7-48af-9f38-8d32eedc9ac2
md"""
### La dimensione di un'immagine

La prima cosa che potremmo voler sapere è la dimensione dell'immagine:
"""

# ╔═╡ 3c06a554-c384-43c9-8914-2a3ad37c6d94
zerocal_size = size(zerocal)

# ╔═╡ 17d2de7d-b9d9-4323-9af2-c4be17374486
md"""
Julia restituisce una coppia di numeri. Confrontandoli con l'immagine, notiamo che il primo numero è l'altezza, cioè il numero di pixel verticali, mentre il secondo è la larghezza.
"""

# ╔═╡ f0d5f4e7-c27c-4bfe-903f-f6a6f89615fc
zerocal_height = zerocal_size[1]

# ╔═╡ 8445e656-a17c-4d6a-830c-9b91f9ca564f
zerocal_width = zerocal_size[2]

# ╔═╡ dd372687-0bfe-4788-944f-f4f9e6af9271
md"""
## I pixel di un'immagine e l'indicizzazione

Supponiamo di voler esaminare una parte dell'immagine in modo più dettagliato. Risulterebbe allora utile poter specificare la parte dell'immagine su cui vogliamo concentrarci. 

Se pensiamo all'immagine come una griglia di pixel, ciò di cui necessitiamo è un modo di comunicare al computer a quale pixel (o gruppo di pixel) vogliamo fare riferimento. 
Poiché l'immagine è una griglia bidimensionale, le coordinate di un singolo pixel possono essere espresse usando due _numeri interi_. 
Specificare le coordinate in questo modo è ciò che viene chiamato **indicizzazione**.

In Julia l'indicizzazione avviene tramite l'uso delle parentesi quadre `[` e `]`:
"""

# ╔═╡ fbe7454c-55fa-4f47-a1de-2c68111b0620
a_pixel = zerocal[200, 800]

# ╔═╡ c832e8a0-6bbc-4c45-aa4b-196eacb80c82
md"""
Come vediamo, Pluto disegna l'oggetto "pixel" come un blocco del relativo colore.

Quando indicizziamo un'immagine, il primo numero indica la *riga* dell'immagine, partendo dall'alto, mentre il secondo ne indica la *colonna*, partendo da sinistra. 

Si presti attenzione al fatto che, in Julia, la prima riga e la prima colonna sono **numerate a partire da 1**, non da 0 come in alcuni altri linguaggi di programmazione!

Possiamo anche usare variabili come indici:
"""

# ╔═╡ b4c534fb-d1ef-42ee-8e04-87a9d6cbc6b8
md"""
In Pluto, tali variabili possono essere controllate da _slider_ interattivi:
"""

# ╔═╡ 36e429f4-dcbe-44d6-9c87-ca1e1c5b2f94
@bind row_i Slider(1:size(zerocal)[1], show_value=true)

# ╔═╡ b5a46b39-9995-4b35-b9c4-5ec02ed357fa
@bind col_i Slider(1:size(zerocal)[2], show_value=true)

# ╔═╡ 1066d8e8-aa46-4e28-9ed7-baf4e72af194
zerocal[row_i, col_i] # `row_i` e `col_i` sono definiti di seguito

# ╔═╡ 59d0b563-6159-4866-8fd0-a1247a01006d
md"""
### Porzioni di un'immagine e indicizzazione coi _range_

Abbiamo visto che possiamo usare il **numero della riga** e il **numero della colonna** per indicizzare un _singolo pixel_ in un'immagine. 
Ora useremo un **range di numeri** per indicizzare _un intervallo di righe o colonne_, restituendo un **subarray**:
"""

# ╔═╡ 6c33172e-82f5-4645-88c7-43e297ff80cb
zerocal[530:650, 1:zerocal_width]

# ╔═╡ 13e38f4e-6c6c-4dbb-ab56-1dca0dda5b7a
md"""
Vediamo che possiamo usare la sintassi `a:b` per esprimere in Julia "_tutti i numeri tra `a` e `b`_". Per esempio, utilizzando la funzione `collect` che costruisce un array a partire da una collezione di oggetti, possiamo scrivere
"""

# ╔═╡ f6494e1f-1418-4f78-b2c1-177f29612cf5
collect(1:10)

# ╔═╡ c0e78a53-c5ee-4690-8bff-b7199d3ace06
md"""
Possiamo anche usare i due punti `:` da soli, per indicare "_ogni indice_".
"""

# ╔═╡ 3e9efc0f-9604-49d9-9433-25989172883b
zerocal[530:650, :]

# ╔═╡ 85cf547c-22d1-406d-a02a-ee9a14445a1c
zerocal[530, :] # visualizza i pixel della riga 530

# ╔═╡ 539f2a32-77c1-4fc8-b786-bd52469cb34e
zerocal_head = zerocal[100:700, 500:960]

# ╔═╡ f377e32b-7729-46e0-9bd2-d1100ee5e0b5
md"""
#### Usare gli slider per _muoversi_ in un'immagine

Trovate l'occhio destro di Zerocalcare usando i widget qui sotto.
"""

# ╔═╡ 1cae635f-7322-49af-8655-4d306d18ea47
@bind range_rows RangeSlider(1:size(zerocal_head)[1])

# ╔═╡ 89f0108b-1b14-4033-8726-420fe380268b
@bind range_cols RangeSlider(1:size(zerocal_head)[2])

# ╔═╡ a79d9755-ec63-4cd8-aa40-7b3a0e1a4fc5
right_eye = zerocal_head[range_rows, range_cols]

# ╔═╡ 5ddad93a-cfb9-4ea2-bc24-06727b927b39
md"""
## Modificare un'immagine

Ora che abbiamo visto come accedere ai "dati" (ossia il contenuto) di un'immagine, possiamo iniziare ad **elaborare** tali dati per estrarne informazioni oppure modificarli.

Potremmo voler rilevare che tipo di oggetti sono presenti nell'immagine, ad esempio per determinare se un paziente è affetto da una certa malattia. Per raggiungere un obiettivo di tale alto livello, avremo bisogno di eseguire operazioni di livello intermedio, come per esempio determinare i bordi che separano diverse parti dell'immagine sulla base del loro colore. A sua volta, per realizzare quest'ultimo obiettivo avremo bisogno di eseguire operazioni di basso livello, quali il confronto del colore di pixel vicini per determinare in qualche modo se sono "diversi".
"""

# ╔═╡ 2f36b59f-9a7f-4ce0-83e9-a613de82e08e
md"""
### Rappresentazione dei colori

Possiamo far uso dell'indicizzazione per *modificare* il colore di un pixel. A tal scopo, è necessario poter specificare un nuovo colore.
Il colore è concetto ben più complicato che in apparenza, avendo a che fare con l'interazione delle proprietà fisiche della luce con i meccanismi fisiologici e i processi mentali con cui lo rileviamo. 

Ignoreremo questa complessità utilizzando un modo standard per rappresentare i colori, ovvero come una **tripla RGB**, cioè una tripla di tre numeri $(r, g, b)$, che specificano rispettivamente la quantità di rosso, di verde e di blu che compongono un colore. Questi numeri, compresi tra 0 e 1, sono sommati determinando la percezione del colore finale (i dettagli di tale processo sono affascinanti, ma al di là dello scopo di questo corso).
"""

# ╔═╡ dbdef9a1-e27d-4405-9cb6-555e44cd8b81
RGB(1.0, 0.0, 0.0)

# ╔═╡ 55e4ba77-2349-407b-abdd-d2973b6d7f21
begin
	md"""
	Un pixel composto dalle quantità 
	$(@bind test_r Scrubbable(0:0.1:1; default=0.1)) di rosso, 
	$(@bind test_g Scrubbable(0:0.1:1; default=0.5)) di verde e 
	$(@bind test_b Scrubbable(0:0.1:1; default=1.0)) di blu dà luogo alla seguente percezione (tenere premuto col mouse sui numeri e trascinarlo verso destra o sinistra per cambiarne il valore):
	"""
end

# ╔═╡ 058a66b5-4f33-4eb3-b5c1-1dbd1b540322
RGB(test_r, test_g, test_b)

# ╔═╡ f83b492f-9d6d-494a-8075-17e7ffc94089
md"""
#### Esercizio - Inversione
👉 Scrivere una funzione `invert` che inverte un colore, ovvero cambia i valori $(r, g, b)$ in $(1 - r, 1-g, 1-b)$.
"""

# ╔═╡ 4661df85-5bc2-442b-b31c-44ddd6dffd41
function invert(color::AbstractRGB)
	
	return missing # scrivere qui il proprio codice
end

# ╔═╡ 192e61fa-7b04-4e7e-b251-063658e624e2
md"""
!!! hint 
	Possiamo accedere ai diversi valori di `color` con `color.r` per il rosso, e così via.
"""

# ╔═╡ 9347f15f-2a83-46e2-bbdd-8c65ae17a405
md"Invertiamo alcuni colori:"

# ╔═╡ 64cd6f34-5a1b-4030-b3c8-19905f7be49f
black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 43e106d3-81bd-4b60-85e3-53514ab6f216
invert(black)

# ╔═╡ 98fa75f1-c4e0-41ec-9baa-0aef91bbfa65
red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 69063824-e8db-4a15-9a07-3d8e8cf4e159
invert(red)

# ╔═╡ 776cc406-ad77-4d67-a283-c87103c0f6ac
md"Potete invertire il disegno di Zerocalcare?"

# ╔═╡ 0f41b42f-4aee-4534-9b31-130d66eefaff
zerocal_inverted = missing # inserire qui il codice corretto

# ╔═╡ 5d18807e-cb36-4ed5-95e9-e18b39efeff6
md"""
### Modificare un singolo pixel

Cominciamo col vedere come si può modificare un'immagine, ad esempio al fine di nascondere informazioni sensibili.
Lo faremo assegnando un nuovo valore al colore di un pixel:
"""

# ╔═╡ 9b529cc7-c380-42c8-b136-70628d36adb9
let
	temp = copy(zerocal_head) # Domanda: a cosa serve il comando `copy`?
	temp[200, 200] = RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ e2e12ede-8349-415b-92a8-3c7b2063bf83
md"""
La differenza non si nota: un singolo pixel è molto piccolo rispetto all'immagine. Quest'ultima contiene $(reduce(*, size(zerocal_head))) pixel, dunque un singolo pixel non ne costituisce che lo $(round(100/reduce(*, size(zerocal_head)), digits=5))%.
"""

# ╔═╡ 23afec58-f186-4935-842d-9a1618fd0228
md"""
### Gruppi di pixel

Vediamo ora come ispezionare e modificare diversi pixel in una volta sola.
Per esempio, possiamo estrarre dall'immagine una riga orizzontale, dell'altezza di un singolo pixel:
"""

# ╔═╡ 9e71cfa4-4e1a-4aee-b3e6-f9c89aa71b8a
zerocal_head[50, 50:100]

# ╔═╡ 78a6251e-49db-4097-8113-1464dd9b344a
md"""
De seguito, una riga viene rappresentata come collezione di rettangoli allineati, e successivamente modificata:
"""

# ╔═╡ 04ef7729-80c3-4a47-994f-281ffa4684ef
let
	temp = copy(zerocal_head)
	temp[150, 150:200] .= RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ 5cb263f0-6a5c-4cca-be16-79d33fbc534a
md"""
Possiamo modificare un intero blocco rettangolare di pixel allo stesso modo:
"""

# ╔═╡ 01c811fe-872f-4794-82c7-fb5c17d1a816
let
	temp = copy(zerocal_head)
	temp[150:200, 150:200] .= RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ 1bbf0a8b-bf01-442d-9239-ffe6f0507003
md"""
#### Esercizio - Matrice con blocco

👉 Creare un vettore di 100 zeri e cambiare il valore delle 20 entrate centrali ad 1.
"""

# ╔═╡ 1195509e-0397-4c52-85c1-c50c97177b1a
function create_bar()
	
	return missing # Scrivere qui il proprio codice
end

# ╔═╡ da3388e6-35b3-4e3a-a1e4-e0e86137a6ed
md"""
## Ridurre la dimensione di un'immagine

Potremmo voler ridurre le dimensioni di quest'immagine. Per farlo, potremmo per esempio considerare solo un singolo pixel ogni 10ª riga e ogni 10ª colonna e ricavare una nuova immagine dal risultato:
"""

# ╔═╡ a993133b-bfc4-47a3-98e7-8402c55bd89c
reduced_image = zerocal[1:10:end, 1:10:end]

# ╔═╡ ba06bb37-7d57-410a-be1d-bf784fde13b8
md"""
Notare che la qualità dell'immagine risultante lascia molto a desiderare: sembriamo aver perso troppi dettagli dell'immagine originale. 

#### Esercizio - Compressione

> Si pensi a cosa si potrebbe fare per ridurre le dimensioni di un'immagine senza perdere troppi dettagli.
"""

# ╔═╡ 9007ab1b-9ffd-4e97-bdda-80bce663459c
md"""

## Salvare un'immagine in un file

Vedremo ora come salvare le immagini che creiamo in un file. Per farlo, possiamo fare **click** col tasto destro su un'immagine visualizzata, oppure possiamo scriverla su file, come segue:
"""

# ╔═╡ 197848bf-b6d8-4c78-9fd9-6368e96d8b98
save("reduced_zerocal.png", reduced_image)

# ╔═╡ c4d4107b-da81-4240-ac9b-06863de8ea15
md"""
## Array comprehension

Chiaramente, se volessimo creare un array con più di qualche elemento, sarà *molto* laborioso farlo a mano. Piuttosto, vorremmo *automatizzare* il processo di creazione di un array seguendo uno schema, per esempio per creare un'intera tavolozza di colori.

Iniziamo con tutti i colori possibili interpolando tra il nero, `RGB(0, 0, 0)`, e il rosso, `RGB(1, 0, 0)`.  Poiché solo uno dei valori sta cambiando, possiamo rappresentarlo come un vettore, cioè un array unidimensionale.

Un metodo pulito per raggiungere questo primo obiettivo è di utilizzare la **array comprehension**. Usiamo le parentesi quadre per creare un array, ma facendo anche uso di una **variabile** che varia su una data **gamma** di valori:
"""

# ╔═╡ ecfb740e-3f22-4519-a935-f39de017c00c
[RGB(x, 0, 0) for x in 0:0.1:1]

# ╔═╡ 48a1c323-3e94-46cd-8b1c-b66419a4ad32
md"""
Here, `0:0.1:1` is a **range**; the first and last numbers are the start and end values, and the middle number is the size of the step.
"""

# ╔═╡ b7574bde-f9c2-4616-be4a-49260c20be66
md"""
Ricordiamo che `0:0.1:1` è un **range**; il primo e l'ultimo numero sono i valori di inizio e fine e il numero centrale è la dimensione del passo (step).
"""

# ╔═╡ 0876605b-77a9-4683-96fe-454e6bc7939e
[RGB(i, j, 0) for i in 0:0.1:1, j in 0:0.1:1]

# ╔═╡ 2eceb02a-b789-47e1-bdff-5243b1d20bc7
md"""
## Unione di matrici

Spesso è necessario concatenare vettori o matrici. Ciò può essere fatto utilizzando una sintassi simile a quella per la creazione di matrici:
"""

# ╔═╡ c3af1855-da67-4de9-bda7-dab773315b1e
[zerocal_head  zerocal_head]

# ╔═╡ b4463f91-b5cf-41a9-a361-3cfbcd76acfa
[zerocal_head                   reverse(zerocal_head, dims=2)
 reverse(zerocal_head, dims=1)  rot180(zerocal_head)]

# ╔═╡ fd650c20-a7c2-4b36-9a87-76ef2e780767
md"""
## Interattività tramite cursori

Supponiamo di voler visualizzare l'effetto del cambiamento del numero di colori in un  vettore o in una matrice. Una possibilità è farlo giocando "a mano" con il range.

Il notebook Pluto ci permette di farlo utilizzando un'**interfaccia utente**, per esempio con uno **slider**. 
Possiamo definire un cursore come segue:
"""

# ╔═╡ 306f558c-4daf-4b52-8bff-60bd6aee8898
@bind number_reds Slider(1:100, show_value=true)

# ╔═╡ 73b119cb-a061-419a-9e6b-7692f1a028e0
md"""
(Il tipo `Slider` è definito nel pacchetto `PlutoUI.jl`.)

Il comando precedente crea una nuova variabile chiamata `number_reds`, il cui valore è quello mostrato dal cursore. Muovendo quest'ultimo, il valore della variabile viene aggiornato. Poiché Pluto è un notebook **reattivo**, le altre celle che usano il valore di questa variabile saranno *automaticamente aggiornate*.


Usiamo questa funzionalità per creare un cursore per l'array unidimensionale di rossi:
"""

# ╔═╡ 872ca931-273f-4d95-8a3b-78bbfaf44b1b
[RGB(red_value / number_reds, 0, 0) for red_value in 0:number_reds]

# ╔═╡ 087a21c4-3a2c-419c-bc11-a3a4ed83df15
md"""
Muovendo il cursore, dovremmo vedere il numero di pixel di colore rosso cambiare.

Quello che succede dietro le quinte è che stiamo creando un vettore in cui `red_value` assume ogni valore nel range da `0` fino al valore corrente di `number_reds`. Se cambiamo `number_reds`, allora creiamo un nuovo vettore con il nuovo numero di macchie rosse.

#### Esercizio

> Si creino tre cursori con le variabili `r`, `g` e `b`. Poi si creino una singola patch di colore con il colore RGB dato da quei valori.

"""

# ╔═╡ 88c36fe3-2200-4900-8800-d74aa4f7fa68
md"""
#### Esercizio bonus
Provare ad adattare l'esercizio precedente, al fine di creare matrici di dimensioni diverse, creando due cursori, uno per i rossi e uno per i verdi. 
"""

# ╔═╡ 3579cc61-ab1e-423f-97da-ea952422afe0
md"""
## Riassunto

Riassumiamo le idee principali viste in questo notebook:
- Un'immagine non è altro che un **array** di colori
- Possiamo ispezionare e modificare gli array usando l'**indicizzazione**
- Possiamo creare array direttamente o usando l'**array comprehension**
"""

# ╔═╡ f6c1c4ef-81f7-4eca-944b-77a3d32d0a42
md"""
## Soluzioni
!!! solution "Soluzione all'esercizio \"Inversione\""
	```
	function invert(color::AbstractRGB)
		inverted_cols = 1 .- (color.r, color.g, color.b)
		return RGB(inverted_cols)
	end
	```
"""

# ╔═╡ 6942e036-dea0-4576-8938-d18865c330b3


# ╔═╡ db738014-ee97-4b12-b44c-340ee0a7298e
md"""
## Appendice
"""

# ╔═╡ 16f43cbf-b6b8-494e-9af9-1ba4f67dbbcd
function camera_input(;max_size=150, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ da8fec70-22df-4bff-a302-72be9b30fb88
@bind webcam_data1 camera_input()

# ╔═╡ 9de5cc61-fdc0-4a82-a906-ca62b76db227
@bind webcam_data2 camera_input()

# ╔═╡ 36512299-d36a-466f-8a51-0e3bb4fe15c4

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ 7b567c34-16fa-4042-8e61-ec1b4c01416d
myclass = process_raw_camera_data(webcam_data1);

# ╔═╡ 898aebde-aea0-426e-aebd-a1e606ba7fc5
[
	myclass              myclass[   :    , end:-1:1]
	myclass[end:-1:1, :] myclass[end:-1:1, end:-1:1]
]

# ╔═╡ 12864824-d447-4a0f-969d-a47868dbd9a1
myclass2 = process_raw_camera_data(webcam_data2);

# ╔═╡ 92a1cecf-7a94-412b-93b6-ae2e17bc866e
[
	myclass2              myclass2[   :    , end:-1:1]
	myclass2[end:-1:1, :] myclass2[end:-1:1, end:-1:1]
]

# ╔═╡ 1fee3d76-5f1e-4131-af27-c08d234514f1
exercise_css = html"""
<style>

ct-exercise > h4 {
    background: #73789a;
    color: white;
    padding: 0rem 1.5rem;
    font-size: 1.2rem;
    border-radius: .6rem .6rem 0rem 0rem;
	margin-left: .5rem;
	display: inline-block;
}
ct-exercise > section {
	    background: #31b3ff1a;
    border-radius: 0rem 1rem 1rem 1rem;
    padding: .7rem;
    margin: .5rem;
    margin-top: 0rem;
    position: relative;
}


/*ct-exercise > section::before {
	content: "👉";
    display: block;
    position: absolute;
    left: 0px;
    top: 0px;
    background: #ffffff8c;
    border-radius: 100%;
    width: 1rem;
    height: 1rem;
    padding: .5rem .5rem;
    font-size: 1rem;
    line-height: 1rem;
    left: -1rem;
}*/


ct-answer {
	display: flex;
}
</style>

"""

# ╔═╡ 4af04353-1072-4c5e-9f0a-659c9053ecfe
exercise(x, number="") = 
@htl("""
	<ct-exercise class="exercise">
	<h4>Exercise <span>$(number)</span></h4>
	<section>$(x)
	</section>
	</ct-exercise>
	""")

# ╔═╡ a9f6104c-564d-4929-b818-7f38cc36c956
quick_question(x, number, options, correct) = let
	name = join(rand('a':'z',16))
@htl("""
	<ct-exercise class="quick-question">
	<h4>Quick Question <span>$(number)</span></h4>
	<section>$(x)
	<ct-answers>
	$(map(enumerate(options)) do (i, o)
		@htl("<ct-answer><input type=radio name=$(name) id=$(i) >$(o)</ct-answer>")
	end)
	</ct-answers>
	</section>
	</ct-exercise>
	""")
end

# ╔═╡ bc54a69c-1a9d-4cd9-bf71-0bb02d544d5e
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 51fa8a95-c0cf-4743-8b14-8099368c590b
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Ops!", [md"Assicuratevi di ver definito una variabile chiamata **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 0c5bc446-fd84-4d84-bb16-baa51124cff6
yays = [md"Bene!", md"Ottimo!", md"Perfetto! 🎉", md"Fantastico!", md"Continua così!", md"Ottimo lavoro!", md"Meraviglioso!", md"Risposta esatta!", md"Proseguiamo alla prossima sezione."]

# ╔═╡ 6eceecdb-002b-4d95-afb7-77fc8ac0d93f
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Giusto!", [text]))

# ╔═╡ cec121f8-7de6-4af2-b0f0-23a17cbbc65b
begin
	colored_line(x::Vector{<:Real}) = Gray.(Float64.((hcat(x)')))
	colored_line(x::Any) = nothing
end

# ╔═╡ e2a86435-a926-4d4c-af2c-4ec0bcde7f3c
colored_line(create_bar())

# ╔═╡ f96b70f5-a099-42c8-ae9e-29488ff002fe
still_missing(text=md"Sostituire `missing` con la propria risposta.") = Markdown.MD(Markdown.Admonition("warning", "Risolvere l'esercizio", [text]))

# ╔═╡ d1e6a92b-8c03-4bfd-9ebf-de87fc2e3a35
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Ci siamo quasi!", [text]))

# ╔═╡ 3c740194-4a34-4547-aabc-054559544fe1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Suggerimento", [text]))

# ╔═╡ b206a2b1-80f0-45c1-8163-26e77343dcb2
keep_working(text=md"La risposta non è corretta.") = Markdown.MD(Markdown.Admonition("danger", "C'è un errore!", [text]))

# ╔═╡ 9301d2c9-3000-45dc-86dc-b0dca5279ec3
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Forse avete dimenticato di restituire l'output (`return`)?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"Il risultato dovrebbe essere un `Vector` di 100 elementi.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.13.0"
HypertextLiteral = "~0.9.3"
ImageIO = "~0.6.1"
ImageShow = "~0.3.4"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageIO]]
deps = ["FileIO", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "464bdef044df52e6436f8c018bea2d48c40bb27b"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.1"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "25f7784b067f699ae4e4cb820465c174f7022972"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.4"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "76c987446e8d555677f064aaac1145c4c17662f8"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.14"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─390fe1cb-08cd-40e9-9468-7594f50b93ce
# ╟─c47fba6d-6423-49c0-acfe-3a4143c5a5ed
# ╟─582880c1-c8dc-4d80-b74f-8639bffc096d
# ╟─37660976-adff-4f3d-96e4-ac7ef58f5912
# ╟─ec7886c4-2523-4e46-a4ad-8d27a6071c17
# ╠═393ab172-cb31-11ec-1295-cd4041170c04
# ╟─f502e214-c212-4824-a32f-6faf99d4a67a
# ╟─95535bfa-b5d2-4a51-b6a2-37fa3c433994
# ╟─9804f339-ebea-46ef-850a-051b133ba95b
# ╟─b850c9b2-5605-4e88-b97e-b74fac45f592
# ╠═35238013-e079-46e1-a3a1-885fca7d50e4
# ╟─e5a15ad7-254a-49b3-952a-7a740fbf504e
# ╠═be4bf585-c4a0-4192-87d1-753152872f2b
# ╟─77305f11-9e66-434b-ad13-726c920a0b89
# ╠═58d3f8be-12f2-447c-a7e1-fb5c2bb489fb
# ╟─0a15e9d4-6e2c-4f82-a465-ff4d33319e67
# ╟─678176f0-3b49-434f-838d-ff6695cf1d2e
# ╠═da8fec70-22df-4bff-a302-72be9b30fb88
# ╠═7b567c34-16fa-4042-8e61-ec1b4c01416d
# ╟─38001b21-60b6-4699-b582-fc407a31202c
# ╠═898aebde-aea0-426e-aebd-a1e606ba7fc5
# ╟─8106abce-c2a7-48af-9f38-8d32eedc9ac2
# ╠═3c06a554-c384-43c9-8914-2a3ad37c6d94
# ╟─17d2de7d-b9d9-4323-9af2-c4be17374486
# ╠═f0d5f4e7-c27c-4bfe-903f-f6a6f89615fc
# ╠═8445e656-a17c-4d6a-830c-9b91f9ca564f
# ╟─dd372687-0bfe-4788-944f-f4f9e6af9271
# ╠═fbe7454c-55fa-4f47-a1de-2c68111b0620
# ╟─c832e8a0-6bbc-4c45-aa4b-196eacb80c82
# ╠═1066d8e8-aa46-4e28-9ed7-baf4e72af194
# ╟─b4c534fb-d1ef-42ee-8e04-87a9d6cbc6b8
# ╠═36e429f4-dcbe-44d6-9c87-ca1e1c5b2f94
# ╠═b5a46b39-9995-4b35-b9c4-5ec02ed357fa
# ╟─59d0b563-6159-4866-8fd0-a1247a01006d
# ╠═6c33172e-82f5-4645-88c7-43e297ff80cb
# ╟─13e38f4e-6c6c-4dbb-ab56-1dca0dda5b7a
# ╠═f6494e1f-1418-4f78-b2c1-177f29612cf5
# ╟─c0e78a53-c5ee-4690-8bff-b7199d3ace06
# ╠═3e9efc0f-9604-49d9-9433-25989172883b
# ╠═85cf547c-22d1-406d-a02a-ee9a14445a1c
# ╠═539f2a32-77c1-4fc8-b786-bd52469cb34e
# ╟─f377e32b-7729-46e0-9bd2-d1100ee5e0b5
# ╠═1cae635f-7322-49af-8655-4d306d18ea47
# ╠═89f0108b-1b14-4033-8726-420fe380268b
# ╠═a79d9755-ec63-4cd8-aa40-7b3a0e1a4fc5
# ╟─5ddad93a-cfb9-4ea2-bc24-06727b927b39
# ╟─2f36b59f-9a7f-4ce0-83e9-a613de82e08e
# ╠═dbdef9a1-e27d-4405-9cb6-555e44cd8b81
# ╟─55e4ba77-2349-407b-abdd-d2973b6d7f21
# ╠═058a66b5-4f33-4eb3-b5c1-1dbd1b540322
# ╟─f83b492f-9d6d-494a-8075-17e7ffc94089
# ╠═4661df85-5bc2-442b-b31c-44ddd6dffd41
# ╟─192e61fa-7b04-4e7e-b251-063658e624e2
# ╟─9347f15f-2a83-46e2-bbdd-8c65ae17a405
# ╠═64cd6f34-5a1b-4030-b3c8-19905f7be49f
# ╠═43e106d3-81bd-4b60-85e3-53514ab6f216
# ╠═98fa75f1-c4e0-41ec-9baa-0aef91bbfa65
# ╠═69063824-e8db-4a15-9a07-3d8e8cf4e159
# ╟─776cc406-ad77-4d67-a283-c87103c0f6ac
# ╠═0f41b42f-4aee-4534-9b31-130d66eefaff
# ╟─5d18807e-cb36-4ed5-95e9-e18b39efeff6
# ╠═9b529cc7-c380-42c8-b136-70628d36adb9
# ╟─e2e12ede-8349-415b-92a8-3c7b2063bf83
# ╟─23afec58-f186-4935-842d-9a1618fd0228
# ╠═9e71cfa4-4e1a-4aee-b3e6-f9c89aa71b8a
# ╟─78a6251e-49db-4097-8113-1464dd9b344a
# ╠═04ef7729-80c3-4a47-994f-281ffa4684ef
# ╟─5cb263f0-6a5c-4cca-be16-79d33fbc534a
# ╠═01c811fe-872f-4794-82c7-fb5c17d1a816
# ╟─1bbf0a8b-bf01-442d-9239-ffe6f0507003
# ╠═1195509e-0397-4c52-85c1-c50c97177b1a
# ╠═e2a86435-a926-4d4c-af2c-4ec0bcde7f3c
# ╟─9301d2c9-3000-45dc-86dc-b0dca5279ec3
# ╟─da3388e6-35b3-4e3a-a1e4-e0e86137a6ed
# ╠═a993133b-bfc4-47a3-98e7-8402c55bd89c
# ╟─ba06bb37-7d57-410a-be1d-bf784fde13b8
# ╟─9007ab1b-9ffd-4e97-bdda-80bce663459c
# ╠═197848bf-b6d8-4c78-9fd9-6368e96d8b98
# ╟─c4d4107b-da81-4240-ac9b-06863de8ea15
# ╠═ecfb740e-3f22-4519-a935-f39de017c00c
# ╠═48a1c323-3e94-46cd-8b1c-b66419a4ad32
# ╟─b7574bde-f9c2-4616-be4a-49260c20be66
# ╠═0876605b-77a9-4683-96fe-454e6bc7939e
# ╟─2eceb02a-b789-47e1-bdff-5243b1d20bc7
# ╠═c3af1855-da67-4de9-bda7-dab773315b1e
# ╠═b4463f91-b5cf-41a9-a361-3cfbcd76acfa
# ╟─fd650c20-a7c2-4b36-9a87-76ef2e780767
# ╠═306f558c-4daf-4b52-8bff-60bd6aee8898
# ╟─73b119cb-a061-419a-9e6b-7692f1a028e0
# ╠═872ca931-273f-4d95-8a3b-78bbfaf44b1b
# ╟─087a21c4-3a2c-419c-bc11-a3a4ed83df15
# ╟─88c36fe3-2200-4900-8800-d74aa4f7fa68
# ╠═9de5cc61-fdc0-4a82-a906-ca62b76db227
# ╠═12864824-d447-4a0f-969d-a47868dbd9a1
# ╠═92a1cecf-7a94-412b-93b6-ae2e17bc866e
# ╟─3579cc61-ab1e-423f-97da-ea952422afe0
# ╟─f6c1c4ef-81f7-4eca-944b-77a3d32d0a42
# ╟─6942e036-dea0-4576-8938-d18865c330b3
# ╟─db738014-ee97-4b12-b44c-340ee0a7298e
# ╟─16f43cbf-b6b8-494e-9af9-1ba4f67dbbcd
# ╟─36512299-d36a-466f-8a51-0e3bb4fe15c4
# ╟─1fee3d76-5f1e-4131-af27-c08d234514f1
# ╟─4af04353-1072-4c5e-9f0a-659c9053ecfe
# ╟─a9f6104c-564d-4929-b818-7f38cc36c956
# ╟─bc54a69c-1a9d-4cd9-bf71-0bb02d544d5e
# ╟─51fa8a95-c0cf-4743-8b14-8099368c590b
# ╟─6eceecdb-002b-4d95-afb7-77fc8ac0d93f
# ╟─0c5bc446-fd84-4d84-bb16-baa51124cff6
# ╟─cec121f8-7de6-4af2-b0f0-23a17cbbc65b
# ╟─f96b70f5-a099-42c8-ae9e-29488ff002fe
# ╟─d1e6a92b-8c03-4bfd-9ebf-de87fc2e3a35
# ╟─3c740194-4a34-4547-aabc-054559544fe1
# ╟─b206a2b1-80f0-45c1-8163-26e77343dcb2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
