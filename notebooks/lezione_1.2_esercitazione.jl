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

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import ImageMagick
	using Images
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ 07ba6402-24ea-458f-a850-98f646a928c8
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)

----
Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ d1419911-296e-4a38-a918-95ddde4a5fa1
PlutoUI.TableOfContents(aside=true)

# ╔═╡ b48d730a-7d60-4252-a7de-65d59b08f4b2
md"""
# Esercitazione 1.2
"""

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""
Questo notebook contiene un _controllo automatico delle risposte, in tempo reale_! In alcuni esercizi è presente un riquadro colorato che esegue un _test case_ sul proprio codice e mostra feedback basato sul risultato. Si modifichi ed esegua semplicemente il codice: il feedback verrà aggiornato automaticamente.
"""

# ╔═╡ 5f95e01a-ee0a-11ea-030c-9dba276aba92
md"""
#### Inizializzazione dei pacchetti Julia

_Quando si esegue questo notebook per la prima volta, può essere necessaria un'attesa di vari minuti (nessun linguaggio è perfetto...)_
"""

# ╔═╡ 540ccfcc-ee0a-11ea-15dc-4f8120063397
md"""
## Esercizio 1 - Manipolare vettori

Come abbiamo visto, un `Vector` è un array 1-dimensionale, e possiamo pensarlo come un'immagine "1D" (una linea colorata).
"""

# ╔═╡ 467856dc-eded-11ea-0f83-13d939021ef3
example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.9]

# ╔═╡ ad6a33b0-eded-11ea-324c-cfabfd658b56
md"""
### Esercizio 1.1
👉 Costruire un vettore random `random_vect` di lunghezza 10 usando la funzioen `rand`. 
"""

# ╔═╡ f51333a6-eded-11ea-34e6-bfbb3a69bcb0
random_vect = missing # scrivete qui il codice che risolve l'esercizio

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector) = hcat(Gray.(Float64.(x)))'
	colored_line(x::Any) = nothing
end

# ╔═╡ 56ced344-eded-11ea-3e81-3936e9ad5777
colored_line(example_vector)

# ╔═╡ b18e2c54-edf1-11ea-0cbf-85946d64b6a2
colored_line(random_vect)

# ╔═╡ 77adb065-bfd4-4680-9c2a-ad4d92689dbf
md"""
### Esercizio 1.2
👉 Scrivete usa funzione `my_sum` che una un ciclo `for`, e che calcola il totale di un vettore di numeri.
"""

# ╔═╡ bd907ee1-5253-4cae-b5a5-267dac24362a
function my_sum(xs)
	return missing # scrivete qui il proprio codice.
end

# ╔═╡ 6640110a-d171-4b32-8d12-26979a36b718
my_sum([1,2,3])

# ╔═╡ cf738088-eded-11ea-2915-61735c2aa990
md"### Esercizio 1.3
👉 Usate la vostra funzione `my_sum` per scrivere una funzione `mean`, che calcola la media di un vettore di numeri."

# ╔═╡ 0ffa8354-edee-11ea-2883-9d5bfea4a236
function mean(xs)
	return missing # scrivete qui il vostro codice
end

# ╔═╡ 1f104ce4-ee0e-11ea-2029-1d9c817175af
mean([1, 2, 3])

# ╔═╡ 1f229ca4-edee-11ea-2c56-bb00cc6ea53c
md"👉 Definite `m` come la media di `random_vect`."

# ╔═╡ 2a391708-edee-11ea-124e-d14698171b68
m = missing # sostituite a `missing` il vostro codice

# ╔═╡ e2863d4c-edef-11ea-1d67-332ddca03cc4
md"""### Esercizio 1.4
👉 Scrivete una funzione `demean`, che dato in input un vettore `xs`, ne sottrae la media ad ogni componente. Utilizzate la funzioen `mean` che avete implementato precedentemente."""

# ╔═╡ ea8d92f8-159c-4161-8c54-bab7bc00f290
md"""
> #### Una nota sulla _mutazione_
> Ci sono due modi di approcciare questo esercizio: potete _modificare_ il vettore originale oppure potete _crearne uno nuovo_. Spesso si preferisce la seconda versione, in modo da preservare i dati originali. Generalmente, il primo approccio viene invece usato nelle parti più critiche del codice per quanto riguarda le prestazioni del programma. 
> Modificare direttamente il vettore in input è un approccio che richiede più attenzione nello scrivere e nell'utilizzarlo correttamente. _State attenti non cedere alla tentazione di **ottimizzazione eccessivamente il codice**, specialmente nella fase di apprendimento di un nuovo linguaggio!_
> 
> Per convenzione, come già accennato, tra i _juliani_ le funzioni che modificano il proprio argomento hanno un `!` al termine del nome. Per esempio, `sort(x)` restituisce una _copia_ ordinata di `x`, mentre `sort!(x)` _modifica_ `x` affinché sia ordinato.
> 
> #### Suggerimenti per evitare codice "mutante"
> 1. Riscrivete_ una funzione mutante esistente come non mutante. Tuttavia, invece di provare a **riscrivere** una funzione mutante, è spesso meglio fare un passo indietro e provare a pensare al vostro problema in termini di _costruire qualcosa di nuovo_. Invece di un ciclo `for`, potrebbe avere più senso usare primitive **descrittive** come [trasmissione con la sintassi dei punti](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) (anche per [operatori matematici](https://docs.julialang.org/en/v1/manual/mathematical-operations/#man-dot-operators)), e [mappa e filtro](https://www.youtube.com/watch?v=_O-HBDZMLrM).
> 
> 
> 2. Se un algoritmo mutante ha più senso per il vostro problema, allora potete usare prima `copy` per creare una copia dell'array e successivamente modificare (solo) quella copia.
> 
> Tratteremo meglio questo argomento negli esercizi successivi!

"""

# ╔═╡ ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
function demean(xs)
	return missing # Scrivete qui il vostro codice. 
end

# ╔═╡ d6ddafdd-1a44-48c7-b49a-554073cdf331
test_vect = let
	
	# feel free to change your test case here!
	to_create = [-1.0, -1.5, 8.5]
	
	
	####
	# this cell is a bit funky to deal with a common pitfall from last year
	# it regenerates the vector if you accidentally wrote a mutating function
	
	# don't worry about how it works for this exercise!
	
	demean
	to_create
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"""
Per testare la vostra funzione, controllate che la media di `demean(test_vect)` sia 0: (_A causa di un errore di arrotondamento in virgola mobile potrebbe *non* essere *esattamente* 0._)
"""

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
demeaned_test_vect = demean(test_vect)

# ╔═╡ 1267e961-5b75-4b55-8080-d45316a03b9b
mean(demeaned_test_vect)

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
### Esercizio 1.5

👉 Generate un vettore di 100 elementi, dove
- i 20 elementi centrali del vettore hanno valore pari a `1`, e
- tutti gli altri elementi sono `0`.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	# scrivete qui il vostro codice!
	return missing
end

# ╔═╡ 4a5e9d2c-dd90-4bb0-9e31-3f5c834406b4
create_bar()

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""

## Esercizio 2 - Manipolare immagini

In questo esercizio familiarizzeremo con le matrici (array bidimensionali) in Julia, manipolando immagini. 

A tal scopo, carichiamo un nuovo disegno di Zerocalcare.
"""

# ╔═╡ 59414833-a108-4b1e-9a34-0f31dc907c6e
url = "https://www-sop.inria.fr/members/Emanuele.Natale/images/armadillo_zerocalcare.png" 

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
armadillo_filename = download(url) # scarica l'immagine in un file locale, restituendo il nome del file. 

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
armadillo = load(armadillo_filename)

# ╔═╡ 15088baa-c337-405d-8885-19a6e2bfd6aa
md"""
Ricordate che, in Julia, le immagini sono matrici rappresentate come oggetti di tipo `RGB`, ovvero pixel di colore (vedere [Lezione 1.0](https://www-sop.inria.fr/members/Emanuele.Natale/docs/MScourse/lezione_1.0_immagini_come_array.jl.html)).
"""

# ╔═╡ 7ad4f6bc-588e-44ab-8ca9-c87cd1048442
typeof(armadillo)

# ╔═╡ c5dc0cc8-9305-47e6-8b20-a9f8ef867799
armadillo_pixel = armadillo[100,100]

# ╔═╡ de772e21-0bea-4fd2-868a-9a7d32550bc9
typeof(armadillo_pixel)

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"""
Ripetiamo alcuni comandi, visti in precedenza, per accedere a porzioni dell'immagine.
"""

# ╔═╡ 87a576d4-154d-43c1-9fec-d8da8be9992e
size(armadillo)

# ╔═╡ 6ccd8902-0dd9-4335-a11a-ee7f9a1a6c09
armadillo_head = armadillo[55:190, 300:460]

# ╔═╡ 21bdc692-91ee-474d-ae98-455913a2342e
md"""
Per ottenere i valori dei singoli _channel_ dei colori, possiamo usare gli _attributi_ `r`, `g` e `b`:
"""

# ╔═╡ 2ae3f379-96ce-435d-b863-deba4586ec71
armadillo_pixel.r, armadillo_pixel.g, armadillo_pixel.b

# ╔═╡ f52e4914-2926-4a42-9e45-9caaace9a7db
md"""
### Esercizio 2.1
👉 Scrivete una funzione **`get_red`** che riceve in input un singolo pixel e restituisce il valore del canale rosso.
"""

# ╔═╡ a8b2270a-600c-4f83-939e-dc5ab35f4735
function get_red(pixel::AbstractRGB)
	# scrivete qui il vostro codice
	return missing
end

# ╔═╡ c320b39d-4cea-4fa1-b1ce-053c898a67a6
get_red(RGB(0.8, 0.1, 0.0))

# ╔═╡ d8cf9bd5-dbf7-4841-acf9-eef7e7cabab3
md"""
### Esercizio 2.2
👉 Scrivete una funzione **`get_reds`** (notare la `s` in più) che riceve in input un array bidimensionale di colori (`image`), e restituisce in output l'array bidimensionale dei rispettivi valori del canale rosso di ogni pixel. (Il risultato dovrebbe essere un array bidimensionale di tipo _Number_.) Usate la funzione `get_red` con cui avete risolto l'esercizio precedente.
"""

# ╔═╡ ebe1d05c-f6aa-437d-83cb-df0ba30f20bf
function get_reds(image::AbstractMatrix)
	# scrivete qui il vostro codice
	return missing
end

# ╔═╡ c427554a-6f6a-43f1-b03b-f83239887cee
get_reds(armadillo_head)

# ╔═╡ 4fd07e01-2f8b-4ec9-9f4f-8a9e5ff56fb6
md"""
Estraendo il valore del canale del colore rosso da ogni pixel, abbiamo otteniamo un array bidimensionale di numeri, e siamo dunque passati da un'immagine (array bidimensionale di oggetti RGB) ad una matrice (array bidimensionale di numeri).

### Esercizio 2.3
Proviamo a visualizzare la matrice che abbiamo ottenuto. 
Al momento, tale matrice viene mostrata in formato testuale. 
Tuttavia, poiché si tratta di un'immagine abbastanza grande, la maggior parte delle righe e delle colonne non si adattano allo schermo. 
Un modo migliore per visualizzarla sarebbe dunque quello di **visualizzare una matrice di numeri come immagine**, in un certo senso operando il processo inverso a quello seguito finora.

Per farlo, è sufficiente _mappare_ ciascun numero ad un oggetto `RGB`, affinché il risultato sia un array bidimensionale di quest'ultimo tipo di oggetti; in quest'ultimo caso, Pluto visualizzerà direttamente l'array come immagine.

Per prima cosa, definite una funzione che trasforma un _numero_ in un _colore_.
"""

# ╔═╡ 97c15896-6d99-4292-b7d7-4fcd2353656f
function value_as_color(x)
	return RGB(x, 0, 0)
end

# ╔═╡ cbb9bf41-4c21-42c7-b0e0-fc1ce29e0eb1
value_as_color(0.0), value_as_color(0.6), value_as_color(1.0)

# ╔═╡ 3f1a670b-44c2-4cab-909c-65f4ae9ed14b
md"""
👉 Usate le funzioni `get_reds` e `value_as_color` per visualizzare i valori del canale rosso dell'immagine `armadillo_head`. 

**Suggerimento**: Come negli esercizi precedenti, usate l'operatore di broadcast
per chiamare una funzione _element-wise_.

(Se necessario, si può usare il pulsante ➕ in basso a sinistra di questa cella per aggiungere altre celle.)
"""

# ╔═╡ f7825c18-ff28-4e23-bf26-cc64f2f5049a
md"""
### Esercizio 2.4
👉 Scrivete quattro funzioni, `get_green`, `get_greens`, `get_blue` e `get_blues`, analoghe a `get_red` e `get_reds` per i colori verde e blu. 
"""

# ╔═╡ c54ccdea-ee05-11ea-0365-23aaf053b7d7
md"""
### Esercizio 2.5

👉 Scrivete una funzione **`mean_color`** che prende in input un oggetto chiamato `image` e calcola le quantità medie di rosso, verde e blu nell'immagine, restituendo il colore medio. 
Utilizzate le funzioni scritte per risolvere gli esercizi precedenti.
"""

# ╔═╡ f6898df6-ee07-11ea-2838-fde9bc739c11
function mean_color(image)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ 5be9b144-ee0d-11ea-2a8d-8775de265a1d
mean_color(armadillo)

# ╔═╡ f6cc03a0-ee07-11ea-17d8-013991514d42
md"""

## Exercizio 3 - Altri filtri

Negli esercizi precedenti, abbiamo visto come usare l'operatore di broadcast in Julia per chiamare una funzione in modo _element-wise_ su un array. In questo esercizio lo useremo per scrivere ulteriori filtri d'immagine, che potrete poi applicare alla vostra stessa immagine della webcam.

### Esercizio 3.1
👉 Scrivete una funzione `invert` che inverte un colore, ovvero prende in input $(r, g, b)$ e restituisce $(1 - r, 1-g, 1-b)$."""

# ╔═╡ 63e8d636-ee0b-11ea-173d-bd3327347d55
function invert(color::AbstractRGB)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ 2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
md"""
Invertiamo ora dei colori:
"""

# ╔═╡ b8f26960-ee0a-11ea-05b9-3f4bc1099050
color_black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 5de3a22e-ee0b-11ea-230f-35df4ca3c96d
invert(color_black)

# ╔═╡ 4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
color_red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
invert(color_red)

# ╔═╡ 846b1330-ee0b-11ea-3579-7d90fafd7290
md"👉 Invertite l'immagine del disegno di Zerocalcare."

# ╔═╡ 943103e2-ee0b-11ea-33aa-75a8a1529931
armadillo_inverted = missing # sostituire a `missing` il proprio codice

# ╔═╡ f68d4a36-ee07-11ea-0832-0360530f102e
md"""
### Esercizio 3.2
👉 Cercate nella documentazione la funzione `floor` ed usatela per scrivere una funzione `quantize(x::Number)` che prende in input un valore $x$ (che potete assumere tra 0 e 1) e lo "quantizza" in intervalli di larghezza $0.1$. Per esempio, controllate che $0.267$ venga mappato in $0.2$.
"""

# ╔═╡ fbd1638d-8d7a-4d12-aff9-9c160cc3fd74
function quantize(x::Number)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ 7720740e-2d2b-47f7-98fd-500ed3eee479
md"""
### Intermezzo: _multiple methods_

In Julia, una stessa funzione dispone spesso di più metodi. Quando una funzione viene chiamata, il metodo viene scelto in base agli argomenti forniti in input alla funzione stessa. Vediamo un esempio:

Questi sono due _metodi_ della stessa funzione, avendo
**lo stesso nome, ma input di diversi tipi**:
"""

# ╔═╡ 90421bca-0804-4d6b-8bd0-3ddbd54cc5fe
function double(x::Number)
	return x * 2
end

# ╔═╡ b2329e4c-6204-453e-8998-2414b869b808
function double(x::Vector)
	return [x..., x...]
end

# ╔═╡ 23fcd65f-0182-41f3-80ec-d85b05136c47
md"""
Quando chiamiamo la funzione `double`, Julia decide quale metodo chiamare in base al tipo dell'argomento in input. 
"""

# ╔═╡ 5055b74c-b98d-41fa-a0d8-cb36200d82cc
double(24)

# ╔═╡ 8db17b2b-0cf9-40ba-8f6f-2e53be7b6355
double([1,2,37])

# ╔═╡ a8a597e0-a01c-40cd-9902-d56430afd938
md"""
Tale caratteristica di un linguaggio di programmazione è chiamata **multiple dispatch**. Si tratta per l'appunto di una delle caratteristiche chiave di Julia, e durante questo corso ne vedremo varie applicazioni pratiche e impareremo ad usarlo per creare astrazioni flessibili e naturali. 
"""

# ╔═╡ f6b218c0-ee07-11ea-2adb-1968c4fd473a
md"""
### Esercizio 3.3
👉 Scrivete il secondo **metodo** della funzione `quantize`, ovvero una nuova *versione* della funzione con lo *stesso* nome. Tale metodo deve prendere in input un oggetto colore chiamato `color`, del tipo `AbstractRGB`. 

`::AbstractRGB` è un **tipo**. Questo assicura che la nuova versione della funzione sarà scelta ogni qual volta sarà fornito come suo argomento di input un oggetto il cui tipo è un **sottotipo** del tipo astratto `AbstractRGB`. Per esempio, entrambi i tipi `RGB` e `RGBX` soddisfano tale requisito.

Il metodo che scrivete deve restituire un nuovo oggetto `RGB`, in cui ogni componente ($r$, $g$ e $b$) è quantizzata. Usate dunque il metodo che avete precedentemente sviluppato per `quantizzare`.
"""

# ╔═╡ 04e6b486-ceb7-45fe-a6ca-733703f16357
function quantize(color::AbstractRGB)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ f6bf64da-ee07-11ea-3efb-05af01b14f67
md"""
### Esercizio 3.4
👉 Scrivete un metodo `quantize(image::AbstractMatrix)` che quantizza un'immagine arrotondando ogni suo pixel con una certa precisione. (Potete assumere che la matrice sia una matrice di oggetti che rappresentano un colore).
"""

# ╔═╡ 13e9ec8d-f615-4833-b1cf-0153010ccb65
function quantize(image::AbstractMatrix)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ f6a655f8-ee07-11ea-13b6-43ca404ddfc7
quantize(0.267), quantize(0.91)

# ╔═╡ 25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
md"""
Proviamo ad applicare il nostro metodo: 
"""

# ╔═╡ 9751586e-ee0c-11ea-0cbb-b7eda92977c9
quantize(armadillo)

# ╔═╡ f6d6c71a-ee07-11ea-2b63-d759af80707b
md"""
### Esercizio 3.5
👉 Scrivete una funzione `noisify(x::Number, s)` che aggiunge della randomness di intensità $s$ ad un valore $x$, ovvero restituisce $x+\Delta$ dove $\Delta$ è un valore casuale tra $-s$ e $+s$. Nel caso in cui il risultato cada al di fuori dell'intervallo $[0, 1]$, andrebbe "ristretto" a tale intervallo. (Julia ha una funzione `clamp`, altrimenti potete scrivere la vostra funzione).
"""

# ╔═╡ f38b198d-39cf-456f-a841-1ba08f206010
function noisify(x::Number, s)
	return missing # scrivete qui il vostro codice.
end

# ╔═╡ f6fc1312-ee07-11ea-39a0-299b67aee3d8
md"""
Scrivete il secondo metodo `noisify(c::AbstractRGB, s)` per aggiungere del _rumore_ di intensità $s$ ad ognuno dei valori di colore $(r, g, b)$, usando il precedente metodo `noisify`. 
"""

# ╔═╡ db4bad9f-df1c-4640-bb34-dd2fe9bdce18
function noisify(color::AbstractRGB, s)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ 0000b7f8-4c43-4dd8-8665-0dfe59e74c0a
md"""
Noise strength:
"""

# ╔═╡ 774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ 48de5bc2-72d3-11eb-3fd9-eff2b686cb75
md"""
> ### Nota sull'_array comprehension_
> A questo punto, conosciamo vari modi per creare un nuovo array a partire da un'array preesistente. Possiamo usare: 
> 1. un ciclo `for` per iterare lungo l'array
> 1. l'operatore di broadcast sull'array
> 1. l'_array comprehension_
>
> L'ultima opzione di cui sopra, è dimostrata di seguito:
>
> ```[function_to_apply(args) for args in some_iterable_of_your_choice]```
>
> L'_array comprehension_ crea un nuovo _iterabile_ corrispondente all'oggeto sul quale si itera nella seconda parte del costrutto. Di seguito forniamo un esempio con cicli `for`, facendo uso di due iterabili al fine di creare un `Array` bidimensionale.
"""

# ╔═╡ f70823d2-ee07-11ea-2bb3-01425212aaf9
md"""
👉 Scrivete un terzo metodo `noisify(image::AbstractMatrix, s)` che aggiunge rumore ad ogni pixel dell'immagine data in input. Tale funzione dovrebbe poter essere scritta in una sola riga. 
"""

# ╔═╡ 21a5885d-00ab-428b-96c3-c28c98c4ca6d
function noisify(image::AbstractMatrix, s)
	# scrivete qui il codice della vostra soluzione
	return missing
end

# ╔═╡ 1ea53f41-b791-40e2-a0f8-04e13d856829
noisify(0.5, 0.1) # modificate questo test.

# ╔═╡ 7e4aeb70-ee1b-11ea-100f-1952ba66f80f
(original=color_red, with_noise=noisify(color_red, color_noise))

# ╔═╡ 8e848279-1b3e-4f32-8c0c-45693d12de96
[
	noisify(color_red, strength)
	for 
		strength in 0 : 0.05 : 1,
		row in 1:10
]'

# ╔═╡ d896b7fd-20db-4aa9-bbcf-81b1cd44ec46
md"""
### Esercizio 3.6
Spostate il cursore in basso per impostare la quantità di rumore applicata al disegno di Zerocalcare.
"""

# ╔═╡ e70a84d4-ee0c-11ea-0640-bf78653ba102
@bind armadillo_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
noisify(armadillo_head, armadillo_noise)

# ╔═╡ 9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
if armadillo_noise == 1
	md"""
	> #### Cosa succede?
	> 
	> L'intensità del rumore è `1.0`, ma possiamo ancora riconoscere il disegno... 
	> 
	> 👉 Modificate la definizione dello slider al fine di poter includere valori superiori a `1.0`.
	"""
end

# ╔═╡ f714699e-ee07-11ea-08b6-5f5169861b57
md"""
👉 Per quale intensità di rumore il disegno diviene irriconoscibile?

Potrebbe essere necessaria un'intensità superiore ad 1. Come mai?
"""

# ╔═╡ bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
answer_about_noise_intensity = md"""
L'immagine non è riconoscibile con intensità ...
"""

# ╔═╡ 4139ee66-ee0a-11ea-2282-15d63bcca8b8
md"""
### Acquisire l'input della videocamera
"""

# ╔═╡ e87e0d14-43a5-490d-84d9-b14ece472061
md"""
### Risultati
"""

# ╔═╡ 87dabfd2-461e-4769-ad0f-132cb2370b88
md"""
### Scrivere un proprio filtro
"""

# ╔═╡ ee5f21fb-1076-42b6-8926-8bbb6ed0ad67
function custom_filter(pixel::AbstractRGB)
	# Scrivete qui il vostro codice
	return pixel
end

# ╔═╡ 9e5a08dd-332a-486b-94ab-15c49e72e522
function custom_filter(image::AbstractMatrix)
	
	return custom_filter.(image)
end

# ╔═╡ 756d150a-b7bf-4bf5-b372-5b0efa80d987
md"""
## Appendice
"""

# ╔═╡ 4bc94bec-da39-4f8a-82ee-9953ed73b6a4
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Suggerimento", [text]))

# ╔═╡ b1d5ca28-edf6-11ea-269e-75a9fb549f1d
md"""
È possibile saperne di più su qualsiasi funzione (come per es. `rand`) cliccando su Live Docs in basso a destra della finestra del Pluto notebook e digitando il nome della funzione in alto.

![image](https://user-images.githubusercontent.com/6933510/107848812-c934df80-6df6-11eb-8a32-663d802f5d11.png)

![image](https://user-images.githubusercontent.com/6933510/107848846-0f8a3e80-6df7-11eb-818a-7271ecb9e127.png)

Si raccomanda di lasciare la finestra aperta mentre si lavora al codice, e di cercare continuamente la documentazione per qualsiasi cosa si scrive.

#### Domanda: non trovo i _Live Docs_

Provate quanto segue:

🙋 **State visualizzando l'anteprima statica (pagina html)?** I Live Docs funzionano solo se state _eseguendo_ il notebook. Se state leggendo questo notebook direttamente sulla pagina del sito del corso, allora è necessario cliccare sul pulsante in alto a destra per scaricare il notebook e poi eseguirlo in locale, come mostrato nella prima lezione del corso.

🙋 **Lo schermo è troppo piccolo?** Provate a ridimensionare la finestra o a zoomare.
""" |> hint

# ╔═╡ 24090306-7395-4f2f-af31-34f7486f3945
hint(md"""Consultate questa lezione per un ripasso della sintassi di base in Julia: 
	[Lezione 0.2. - Introduzione al linguaggio Julia](https://natema.github.io/ECMJ-it/lectures/lezione_0.2_-_introduzione_a_julia.jl.html)""")

# ╔═╡ aa1ff74a-4e78-4ef1-8b8d-3a60a168cf6d
hint(md"""
Ricordate il comando che abbiamo usato nella [Lezione 1.0](https://www-sop.inria.fr/members/Emanuele.Natale/docs/MScourse/lezione_1.0_immagini_come_array.jl.html) per disegnare un quadrato rosso sull'immagine di Zerocalcare.
""")

# ╔═╡ 50e2b0fb-b06d-4ac1-bdfb-eab833466736
md"""
Il presente esercizio può risultare difficile se si fa uso di un ciclo `for` o di _list comprehension_. 

Potete alternativamente fare uso dell'[operatore di broadcast](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) per chiamare una funzione _element-wise_ (elemento per elemento) su un array, come visto nelle precedenti lezioni. 
Per richiamare tale concetto, consideriamo per esempio la funzione `sqrt` che calcola la radice quadrata: 

```
sqrt(3)
```

Se vogliamo chiamare la funzione sui valori 1, 2 e 3, possiamo scrivere:

```
sqrt.([1, 2, 3])
```
""" |> hint

# ╔═╡ f6ef2c2e-ee07-11ea-13a8-2512e7d94426
hint(md"`rand()` genera un numero random, con distribuzione uniforme e di tipo Float64, compreso tra $0$ ed $1$.")

# ╔═╡ 8ce6ad06-819c-4af5-bed7-56ecc08c97be
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Ci siamo quasi.", [text]))

# ╔═╡ dfa40e89-03fc-4a7a-825e-92d67ee217b2
still_missing(text=md"Sostituite a `missing` la vostra soluzione.") = Markdown.MD(Markdown.Admonition("warning", "Risolvere l'esercizio", [text]))

# ╔═╡ 086ec1ff-b62d-4566-9973-5b2cc3353409
keep_working(text=md"La risposta non è corretta.") = Markdown.MD(Markdown.Admonition("danger", "Continuate a provare a risolvere l'esercizio", [text]))

# ╔═╡ 2f6fb3a6-bb5d-4c7a-9297-84dd4b16c7c3
yays = [md"Molto bene!", md"Ottimo!", md"Perfetto!", md"Eccellente!"]

# ╔═╡ c22f688b-dc04-4a94-b541-fe06266c5446
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Giusto!", [text]))

# ╔═╡ 09102183-f9fb-4d89-b4f9-5d76af7b8e90
let
	result = get_red(RGB(0.2, 0.3, 0.4))
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Avete forse dimenticato di restituire il valore di output?")
	elseif result == 0.2
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 63ac142e-6d9d-4109-9286-030a02c900b4
let
	test = [RGB(0.2, 0, 0)   RGB(0.6, 0, 0)]
	result = get_reds(test)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Avete forse dimenticato di restituire il valore dell'output?")
	elseif result == [ 0.2  0.6 ]
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 80a4cb23-49c9-4446-a3ec-b2203128dc27
let
	result = invert(RGB(1.0, 0.5, 0.25)) # I chose these values because they can be represented exactly by Float64
	shouldbe = RGB(0.0, 0.5, 0.75)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Avete forse dimenticato di restituire il valore di output?")
	elseif !(result isa AbstractRGB)
		keep_working(md"Dovete restituire un _colore_, ovvero un oggetto di tipo `RGB`. Usate `RGB(r, g, b)` per creare un colore con valori valori dei canali `r`, `g` e `b`.")
	elseif !(result == shouldbe)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ a6d9635b-85ed-4590-ad09-ca2903ea8f1d
let
	result = quantize(RGB(.297, .1, .0))

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Avete dimenticato di restituire il valore di output?")
	elseif !(result isa AbstractRGB)
		keep_working(md"Bisogna resituire un _color_, ovverosia un oggetto di tipo `RGB`. Usare `RGB(r, g, b)` per creare un colore col valore dei tre canali rispettivamente uguale a `r`, `g` e `b`.")
	elseif result != RGB(0.2, .1, .0)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 31ef3710-e4c9-4aa7-bd8f-c69cc9a977ee
let
	result = noisify(0.5, 0)

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Avete dimenticato di restituire il valore di output?")
	elseif result == 0.5
		
		results = [noisify(0.9, 0.1) for _ in 1:1000]
		
		if 0.8 ≤ minimum(results) < 0.81 && 0.99 ≤ maximum(results) ≤ 1
			result = noisify(5, 3)
			
			if result == 1
				correct()
			else
				keep_working(md"Il risultato dovrebbe essere ristretto all'intervallo ``[0,1]``.")
			end
		else
			keep_working()
		end
	else
		keep_working(md"Quale dovrebbe essere l'output di `noisify(0.5, 0)`?")
		correct()
	end
end

# ╔═╡ ab3d1b70-88e8-4118-8d3e-601a8a68f72d
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Ops!", [md"Verificate che è stata definite una variabile di nome **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
# Il codice seguente cerca di correggere automaticamente la soluzione proposta all'esercizio
if !@isdefined(random_vect)
	not_defined(:random_vect)
elseif ismissing(random_vect)
	still_missing()
elseif !(random_vect isa Vector)
	keep_working(md"`random_vect` deve essere di tipo `Vector`.")
elseif eltype(random_vect) != Float64
	almost(md"""
		Avete generato un vettore di interi random. Per gli esercizi successivi, si richiede un vettore di numeri di tipo `Float64`.
		Il primo argomento (opzionale) della funzione `rand` specifica per l'appunto il tipo degli elementi da generare. 
		Per esempio, `rand(Bool, 10)` generate 10 valori corrispondenti a `true` o `false` (si esegua tale comando per verificare). 
		""")
elseif length(random_vect) != 10
	keep_working(md"`random_vect` non ha la dimensione corretta.")
elseif length(Set(random_vect)) != 10
	keep_working(md"`random_vect` non è sufficientemente `random`")
else
	correct(md"Ben fatto! Si può eseguire nuovamente il proprio codice per generare nuovi vettori.")
end

# ╔═╡ e0bfc973-2808-4f84-b065-fb3d05401e30
if !@isdefined(my_sum)
	not_defined(:my_sum)
else
	let
		result = my_sum([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Avete dimenticato di restituire il valore di output?")
		elseif result != 6
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Avete forse dimenticato di restituire il valore di output?")
		elseif result != 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` dovrebbe essere un numero.")
elseif m != mean(random_vect)
	keep_working()
else
	correct()
end

# ╔═╡ adf476d8-a334-4b35-81e8-cc3b37de1f28
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		input = Float64[1,2,3]
		result = demean(input)
		
		if input === result
			almost(md"""
			Sembra che abbiate **modificato** `xs` all'interno della funzione.
			
			È preferibile evitare tale tipo di mutazione, perché per esempio si potrebbe voler utilizzare nuovamente i dati originali. Per esempio, applicare `demean` ad un set di dati di letture di sensori **modificherebbe** i dati originali e il resto della tua analisi sarebbe errato.
			""")
		elseif ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Avete dimenticato di restituire il valore di output?")
		elseif !(result isa AbstractVector) || length(result) != 3
			keep_working(md"Restituite un vettore della stessa dimensione di `xs`.")
		elseif abs(sum(result) / 3) < 1e-10
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Potreste aver dimenticato di restituire il valore di output?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"Il risultato dovrebbe essere un vettore di 100 elementi.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 4d0158d0-ee0d-11ea-17c3-c169d4284acb
if !@isdefined(mean_color)
	not_defined(:mean_color)
else
	let
		input = reshape([RGB(1.0, 1.0, 1.0), RGB(1.0, 1.0, 0.0)], (2, 1))
		
		result = mean_color(input)
		shouldbe = RGB(1.0, 1.0, 0.5)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Avete forse dimenticato di restituire il valore di output?")
		elseif !(result isa AbstractRGB)
			keep_working(md"Dovete restituire un _colore_, ovvero un oggetto di tipo `RGB`. Usate `RGB(r, g, b)` per creare un colore con valori dei canali `r`, `g` e `b`.")
		elseif !(result == shouldbe)
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 8cb0aee8-5774-4490-9b9e-ada93416c089
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ dfb7c6be-ee0d-11ea-194e-9758857f7b20
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
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

# ╔═╡ 20402780-426b-4caa-af8f-ff1e7787b7f9
@bind cam_data camera_input()

# ╔═╡ e15ad330-ee0d-11ea-25b6-1b1b3f3d7888

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

# ╔═╡ ed9fb2ac-2680-42b7-9b00-591e45a5e105
cam_image = process_raw_camera_data(cam_data)

# ╔═╡ d38c6958-9300-4f7a-89cf-95ca9e899c13
mean_color(cam_image)

# ╔═╡ 82f1e006-60fe-4ad1-b9cb-180fafdeb4da
invert.(cam_image)

# ╔═╡ 54c83589-b8c6-422a-b5e9-d8e0ee72a224
quantize(cam_image)

# ╔═╡ 18e781f8-66f3-4216-bc84-076a08f9f3fb
noisify(cam_image, .5)

# ╔═╡ ebf3193d-8c8d-4425-b252-45067a5851d9
[
	invert.(cam_image)      quantize(cam_image)
	noisify(cam_image, .5)  custom_filter(cam_image)
]

# ╔═╡ 8917529e-fa7a-412b-8aea-54f92f6270fa
custom_filter(cam_image)

# ╔═╡ 7a34c3a9-9847-44ce-96e1-a1b93200417a
wrong_out = "Avete forse dimenticato di restituire il valore di output?"

# ╔═╡ c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
if !@isdefined(quantize)
	not_defined(:quantize)
else
	let
		result = quantize(.3)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"$(wrong_out)")
		elseif result != .3
			if quantize(0.35) == .3
				almost(md"Quale dovrebbe essere l'output di `quantize(0.2)`?")
			else
				keep_working()
			end
		else
			correct()
		end
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageMagick = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.0"
ImageMagick = "~1.2.1"
Images = "~0.24.1"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "d84c956c4c0548b4caf0e4e96cf5b6494b5b1529"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.32"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "a4d07a1c313392a77042855df46c5f534076fab9"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.0"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "d127d5e4d86c7680b20c35d40b503c74b9a39b5e"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4ce9393e871aca86cc457d9f66976c3da6902ea7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.4.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "a66a8e024807c4b3d186eb1cab2aff3505271f8e"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.6"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "6d1c23e740a586955645500bbec662476204a52c"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.1"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "9f46deb4d4ee4494ffb5a40a27a2aced67bdd838"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.4"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "8041575f021cba5a099a456b4163c9a08b566a02"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.0"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "70a0cfd9b1c86b0209e38fbfe6d8231fd606eeaf"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.1"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3676abafff7e4ff07bbd2c42b3d8201f31653dcc"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.9+8"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "3c041d2ac0a52a12a27af2782b34900d9c3ee68c"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "2c1cf4df419938ece72de17f368a021ee162762e"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.0"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IdentityRanges]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be8fcd695c4da16a1d6d0cd213cb88090a150e3b"
uuid = "bbac6d45-d8f3-5730-bfe4-7a449cd117ca"
version = "0.3.1"

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[ImageAxes]]
deps = ["AxisArrays", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "794ad1d922c432082bc1aaa9fa8ffbd1fe74e621"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.9"

[[ImageContrastAdjustment]]
deps = ["ColorVectorSpace", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "2e6084db6cccab11fe0bc3e4130bd3d117092ed9"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.7"

[[ImageCore]]
deps = ["AbstractFFTs", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "db645f20b59f060d8cfae696bc9538d13fd86416"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.8.22"

[[ImageDistances]]
deps = ["ColorVectorSpace", "Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "6378c34a3c3a216235210d19b9f495ecfff2f85f"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.13"

[[ImageFiltering]]
deps = ["CatIndices", "ColorVectorSpace", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageCore", "LinearAlgebra", "OffsetArrays", "Requires", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "bf96839133212d3eff4a1c3a80c57abc7cfbf0ce"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.6.21"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "13c826abd23931d909e4c5538643d9691f62a617"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.8"

[[ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[ImageMetadata]]
deps = ["AxisArrays", "ColorVectorSpace", "ImageAxes", "ImageCore", "IndirectArrays"]
git-tree-sha1 = "ae76038347dc4edcdb06b541595268fca65b6a42"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.5"

[[ImageMorphology]]
deps = ["ColorVectorSpace", "ImageCore", "LinearAlgebra", "TiledIteration"]
git-tree-sha1 = "68e7cbcd7dfaa3c2f74b0a8ab3066f5de8f2b71d"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.2.11"

[[ImageQualityIndexes]]
deps = ["ColorVectorSpace", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1198f85fa2481a3bb94bf937495ba1916f12b533"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.2.2"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageCore", "OffsetArrays", "Requires", "StackViews"]
git-tree-sha1 = "832abfd709fa436a562db47fd8e81377f72b01f9"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.1"

[[ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "IdentityRanges", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e4cc551e4295a5c96545bb3083058c24b78d4cf0"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.8.13"

[[Images]]
deps = ["AxisArrays", "Base64", "ColorVectorSpace", "FileIO", "Graphics", "ImageAxes", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageShow", "ImageTransformations", "IndirectArrays", "OffsetArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "8b714d5e11c91a0d945717430ec20f9251af4bd2"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.24.1"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "c2a145a145dc03a7620af1444e0264ef907bd44f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "0.5.1"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "61aa005707ea2cebf47c8d780da8dc9bc4e0c512"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.4"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[Netpbm]]
deps = ["ColorVectorSpace", "FileIO", "ImageCore"]
git-tree-sha1 = "09589171688f0039f13ebe0fdcc7288f50228b52"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e14c485f6beee0c7a8dcf6128bf70b85f1fe201e"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.9"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "646eed6f6a5d8df6708f15ea7e02a7a2c4fe4800"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.10"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "7dff99fbc740e2f8228c6878e2aad6d7c2678098"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rotations]]
deps = ["LinearAlgebra", "StaticArrays", "Statistics"]
git-tree-sha1 = "2ed8d8a16d703f900168822d83699b8c3c1a5cd8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.0.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "a8f30abc7c64a39d389680b74e749cf33f872a70"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.3"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TiffImages]]
deps = ["ColorTypes", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "OrderedCollections", "PkgVersion", "ProgressMeter"]
git-tree-sha1 = "632a8d4dbbad6627a4d2d21b1c6ebcaeebb1e1ed"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.4.2"

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "52c5f816857bfb3291c7d25420b1f4aca0a74d18"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "59e2ad8fd1591ea019a5259bd012d7aee15f995c"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─07ba6402-24ea-458f-a850-98f646a928c8
# ╟─d1419911-296e-4a38-a918-95ddde4a5fa1
# ╟─b48d730a-7d60-4252-a7de-65d59b08f4b2
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╟─5f95e01a-ee0a-11ea-030c-9dba276aba92
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╟─540ccfcc-ee0a-11ea-15dc-4f8120063397
# ╟─467856dc-eded-11ea-0f83-13d939021ef3
# ╠═56ced344-eded-11ea-3e81-3936e9ad5777
# ╟─ad6a33b0-eded-11ea-324c-cfabfd658b56
# ╠═f51333a6-eded-11ea-34e6-bfbb3a69bcb0
# ╠═b18e2c54-edf1-11ea-0cbf-85946d64b6a2
# ╟─397941fc-edee-11ea-33f2-5d46c759fbf7
# ╟─b1d5ca28-edf6-11ea-269e-75a9fb549f1d
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
# ╟─77adb065-bfd4-4680-9c2a-ad4d92689dbf
# ╠═bd907ee1-5253-4cae-b5a5-267dac24362a
# ╠═6640110a-d171-4b32-8d12-26979a36b718
# ╟─e0bfc973-2808-4f84-b065-fb3d05401e30
# ╟─24090306-7395-4f2f-af31-34f7486f3945
# ╟─cf738088-eded-11ea-2915-61735c2aa990
# ╠═0ffa8354-edee-11ea-2883-9d5bfea4a236
# ╠═1f104ce4-ee0e-11ea-2029-1d9c817175af
# ╟─38dc80a0-edef-11ea-10e9-615255a4588c
# ╟─1f229ca4-edee-11ea-2c56-bb00cc6ea53c
# ╠═2a391708-edee-11ea-124e-d14698171b68
# ╟─2b1ccaca-edee-11ea-34b0-c51659f844d0
# ╟─e2863d4c-edef-11ea-1d67-332ddca03cc4
# ╟─ea8d92f8-159c-4161-8c54-bab7bc00f290
# ╠═ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
# ╟─d6ddafdd-1a44-48c7-b49a-554073cdf331
# ╟─29e10640-edf0-11ea-0398-17dbf4242de3
# ╠═1267e961-5b75-4b55-8080-d45316a03b9b
# ╠═38155b5a-edf0-11ea-3e3f-7163da7433fb
# ╟─adf476d8-a334-4b35-81e8-cc3b37de1f28
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╠═4a5e9d2c-dd90-4bb0-9e31-3f5c834406b4
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─aa1ff74a-4e78-4ef1-8b8d-3a60a168cf6d
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═59414833-a108-4b1e-9a34-0f31dc907c6e
# ╠═c5484572-ee05-11ea-0424-f37295c3072d
# ╠═c8ecfe5c-ee05-11ea-322b-4b2714898831
# ╟─15088baa-c337-405d-8885-19a6e2bfd6aa
# ╠═7ad4f6bc-588e-44ab-8ca9-c87cd1048442
# ╠═c5dc0cc8-9305-47e6-8b20-a9f8ef867799
# ╠═de772e21-0bea-4fd2-868a-9a7d32550bc9
# ╟─e86ed944-ee05-11ea-3e0f-d70fc73b789c
# ╠═87a576d4-154d-43c1-9fec-d8da8be9992e
# ╠═6ccd8902-0dd9-4335-a11a-ee7f9a1a6c09
# ╟─21bdc692-91ee-474d-ae98-455913a2342e
# ╟─2ae3f379-96ce-435d-b863-deba4586ec71
# ╟─f52e4914-2926-4a42-9e45-9caaace9a7db
# ╠═a8b2270a-600c-4f83-939e-dc5ab35f4735
# ╠═c320b39d-4cea-4fa1-b1ce-053c898a67a6
# ╟─09102183-f9fb-4d89-b4f9-5d76af7b8e90
# ╟─d8cf9bd5-dbf7-4841-acf9-eef7e7cabab3
# ╠═ebe1d05c-f6aa-437d-83cb-df0ba30f20bf
# ╠═c427554a-6f6a-43f1-b03b-f83239887cee
# ╟─63ac142e-6d9d-4109-9286-030a02c900b4
# ╟─50e2b0fb-b06d-4ac1-bdfb-eab833466736
# ╟─4fd07e01-2f8b-4ec9-9f4f-8a9e5ff56fb6
# ╠═97c15896-6d99-4292-b7d7-4fcd2353656f
# ╠═cbb9bf41-4c21-42c7-b0e0-fc1ce29e0eb1
# ╟─3f1a670b-44c2-4cab-909c-65f4ae9ed14b
# ╟─f7825c18-ff28-4e23-bf26-cc64f2f5049a
# ╟─c54ccdea-ee05-11ea-0365-23aaf053b7d7
# ╠═f6898df6-ee07-11ea-2838-fde9bc739c11
# ╠═5be9b144-ee0d-11ea-2a8d-8775de265a1d
# ╟─4d0158d0-ee0d-11ea-17c3-c169d4284acb
# ╟─f6cc03a0-ee07-11ea-17d8-013991514d42
# ╠═63e8d636-ee0b-11ea-173d-bd3327347d55
# ╟─80a4cb23-49c9-4446-a3ec-b2203128dc27
# ╟─2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
# ╠═b8f26960-ee0a-11ea-05b9-3f4bc1099050
# ╠═5de3a22e-ee0b-11ea-230f-35df4ca3c96d
# ╠═4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
# ╠═6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
# ╟─846b1330-ee0b-11ea-3579-7d90fafd7290
# ╟─943103e2-ee0b-11ea-33aa-75a8a1529931
# ╟─f68d4a36-ee07-11ea-0832-0360530f102e
# ╠═fbd1638d-8d7a-4d12-aff9-9c160cc3fd74
# ╠═f6a655f8-ee07-11ea-13b6-43ca404ddfc7
# ╟─c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
# ╟─7720740e-2d2b-47f7-98fd-500ed3eee479
# ╠═90421bca-0804-4d6b-8bd0-3ddbd54cc5fe
# ╠═b2329e4c-6204-453e-8998-2414b869b808
# ╟─23fcd65f-0182-41f3-80ec-d85b05136c47
# ╠═5055b74c-b98d-41fa-a0d8-cb36200d82cc
# ╠═8db17b2b-0cf9-40ba-8f6f-2e53be7b6355
# ╟─a8a597e0-a01c-40cd-9902-d56430afd938
# ╟─f6b218c0-ee07-11ea-2adb-1968c4fd473a
# ╠═04e6b486-ceb7-45fe-a6ca-733703f16357
# ╟─a6d9635b-85ed-4590-ad09-ca2903ea8f1d
# ╟─f6bf64da-ee07-11ea-3efb-05af01b14f67
# ╠═13e9ec8d-f615-4833-b1cf-0153010ccb65
# ╟─25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
# ╠═9751586e-ee0c-11ea-0cbb-b7eda92977c9
# ╟─f6d6c71a-ee07-11ea-2b63-d759af80707b
# ╠═f38b198d-39cf-456f-a841-1ba08f206010
# ╠═1ea53f41-b791-40e2-a0f8-04e13d856829
# ╟─31ef3710-e4c9-4aa7-bd8f-c69cc9a977ee
# ╟─f6ef2c2e-ee07-11ea-13a8-2512e7d94426
# ╟─f6fc1312-ee07-11ea-39a0-299b67aee3d8
# ╠═db4bad9f-df1c-4640-bb34-dd2fe9bdce18
# ╟─0000b7f8-4c43-4dd8-8665-0dfe59e74c0a
# ╠═774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
# ╠═7e4aeb70-ee1b-11ea-100f-1952ba66f80f
# ╟─48de5bc2-72d3-11eb-3fd9-eff2b686cb75
# ╠═8e848279-1b3e-4f32-8c0c-45693d12de96
# ╟─f70823d2-ee07-11ea-2bb3-01425212aaf9
# ╠═21a5885d-00ab-428b-96c3-c28c98c4ca6d
# ╟─d896b7fd-20db-4aa9-bbcf-81b1cd44ec46
# ╠═e70a84d4-ee0c-11ea-0640-bf78653ba102
# ╠═ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
# ╟─9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
# ╟─f714699e-ee07-11ea-08b6-5f5169861b57
# ╠═bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
# ╟─4139ee66-ee0a-11ea-2282-15d63bcca8b8
# ╠═20402780-426b-4caa-af8f-ff1e7787b7f9
# ╟─ed9fb2ac-2680-42b7-9b00-591e45a5e105
# ╟─e87e0d14-43a5-490d-84d9-b14ece472061
# ╠═d38c6958-9300-4f7a-89cf-95ca9e899c13
# ╠═82f1e006-60fe-4ad1-b9cb-180fafdeb4da
# ╠═54c83589-b8c6-422a-b5e9-d8e0ee72a224
# ╠═18e781f8-66f3-4216-bc84-076a08f9f3fb
# ╠═ebf3193d-8c8d-4425-b252-45067a5851d9
# ╟─87dabfd2-461e-4769-ad0f-132cb2370b88
# ╠═8917529e-fa7a-412b-8aea-54f92f6270fa
# ╠═ee5f21fb-1076-42b6-8926-8bbb6ed0ad67
# ╠═9e5a08dd-332a-486b-94ab-15c49e72e522
# ╟─756d150a-b7bf-4bf5-b372-5b0efa80d987
# ╟─4bc94bec-da39-4f8a-82ee-9953ed73b6a4
# ╟─8ce6ad06-819c-4af5-bed7-56ecc08c97be
# ╟─dfa40e89-03fc-4a7a-825e-92d67ee217b2
# ╟─086ec1ff-b62d-4566-9973-5b2cc3353409
# ╟─2f6fb3a6-bb5d-4c7a-9297-84dd4b16c7c3
# ╟─c22f688b-dc04-4a94-b541-fe06266c5446
# ╟─ab3d1b70-88e8-4118-8d3e-601a8a68f72d
# ╟─8cb0aee8-5774-4490-9b9e-ada93416c089
# ╟─dfb7c6be-ee0d-11ea-194e-9758857f7b20
# ╟─e15ad330-ee0d-11ea-25b6-1b1b3f3d7888
# ╟─7a34c3a9-9847-44ce-96e1-a1b93200417a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
