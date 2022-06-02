### A Pluto.jl notebook ###
# v0.19.5

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

# ╔═╡ 864e1180-f693-11ea-080e-a7d5aabc9ca5
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using ImageShow.ImageCore
	using ColorSchemes
	
	using InteractiveUtils, PlutoUI
	using LinearAlgebra, SparseArrays, Statistics
end

# ╔═╡ ca1a1072-81b6-11eb-1fee-e7df687cc314
PlutoUI.TableOfContents(aside = true)

# ╔═╡ ffa71052-2e18-4cec-8675-92369413716f
supertypes(Int)

# ╔═╡ 5bbf07a0-8833-470d-8603-11563cae6b2c
Int == Int64

# ╔═╡ 59cdf85e-705c-4d0a-bd67-08a30d1f732d
Int <: Signed

# ╔═╡ 799e705e-b560-4d21-822e-10a6726b3c5e
Signed <: Int

# ╔═╡ 62c29c56-313a-44d9-8626-5d181a824c3d
typejoin(Int, Rational)

# ╔═╡ fe2028ba-f6dc-11ea-0228-938a81a91ace
onehot_esplicito = [0, 1, 0, 0, 0, 0]

# ╔═╡ 0a902426-f6dd-11ea-0ae4-fb0c47863fe7
# da notare che esiste anche l'encoding _one-cold_
1 .- onehot_esplicito

# ╔═╡ 4624cd26-f5d3-11ea-1cf8-7d6555eae5fa
struct OneHotImplicito <: AbstractVector{Int}
	n::Int
	k::Int
end

# ╔═╡ 397ac764-f5fe-11ea-20cc-8d7cab19d410
Base.size(x::OneHotImplicito) = (x.n,)

# ╔═╡ 1340e0e5-7d33-4356-affa-60882536b358
size(zeros(10, 20))

# ╔═╡ 94ca00b6-8f94-4786-a27c-eff7b2ad7ae3
onehot_implicito = OneHotImplicito(10, 3)

# ╔═╡ 0d28115a-b97e-4ac7-a4b1-555fcd6beefd
size(onehot_implicito)

# ╔═╡ 82c7046c-f5d3-11ea-04e2-ef7c0f4db5da
Base.getindex(x::OneHotImplicito, i::Int) = Int(x.k == i)

# ╔═╡ 0db6ee04-81b7-11eb-330c-11b578b72c90
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it-2022/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)

Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it-2022), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ b0ba5b8c-f5d1-11ea-1304-3f0e47f935fe
md"# Esempi di strutture"

# ╔═╡ 4419ebba-58ca-454e-b024-380fd364c99b
md"""
## Il sistema di tipi di Julia
"""

# ╔═╡ 2bb8a710-cc5d-4e4b-b861-ecb99470ef47
md"""
Julia è un linguaggio [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch), ovvero provvisto di un sistema di tipi con [polimorfismo parametrico](https://en.wikipedia.org/wiki/Parametric_polymorphism). 
Al di là di termini che possono suonare misteriosi, in pratica ogni oggetto nel linguaggio è associato a un _tipo_ che ne indica il significato.

Possiamo esplorare il [sistema di tipi](https://docs.julialang.org/en/v1/manual/types/) in Julia con qualche semplice comando. 
Per esempio possiamo sapere quali tipi sono un _supertipo_ del tipo `Int` (in altre parole, lo _contengono_): 
"""

# ╔═╡ eb6521e8-4f2e-4319-9c35-384981b321b4
md"""
Per sapere quale tipo è un supertipo sia di `Int` che di `Rational`:
"""

# ╔═╡ 261c4df2-f5d2-11ea-2c72-7d4b09c46098
md"""
### Vettori _one-hot_

L'esempio seguente è importante in machine learning. 
"""

# ╔═╡ 3cada3a0-81cc-11eb-04c8-bde26d36a84e
md"""
Un vettore [one-hot](https://it.wikipedia.org/wiki/One-hot) consiste in un vettore le cui entrate sono tutte 0 eccetto una, che è uguale a 1. Per esempio: 
"""

# ╔═╡ 8d2c6910-f5d4-11ea-1928-1baf09815687
md"""
Quanta _informazione_ (ovvero numero di bit) è necessaria per rappresentare un vettore one-hot?
"""

# ╔═╡ 4794e860-81b7-11eb-2c91-8561c20f308a
md"""
## Le `struct` in Julia - creare nuovi tipi
"""

# ╔═╡ 67827da8-81cc-11eb-300e-278104d2d958
md"""
Una caratteristica centrale del linguaggio Julia è la facilità con cui possiamo  creare nuovi [tipi](https://en.wikipedia.org/wiki/Type_system). Si tratta di un meccanismo fondamentale per la flessibilità del linguaggio stesso: i tipi conferiscono _struttura_ al programma, fornendo informazioni al compilatore sul _significato_ delle diverse operazioni, e permettendogli dunque di _ottimizzare_ il codice che viene fatto girare. 

Creiamo un nuovo tipo per rappresentare vettori one-hot, come _sottotipo_ di `AbstractVector`, con l'intenzione di farlo comportare a tutti gli effetti come un vettore (in particolare, di poter usare la sintassi `vettore[i]`):
"""

# ╔═╡ 9bdabef8-81cc-11eb-14a1-67a9a7d968c0
md"""
Specifichiamo ora cosa succede quando una variabile di tipo `OneHot` viene data in pasto alla funzione `size`: 
"""

# ╔═╡ a22dcd2c-81cc-11eb-1252-13ace134192d
md"""
Per far sì che `OneHot` possa compotersi come un vettore, dobbiamo anche specificare cosa deve succedere quando utilizziamo la sintassi per accedere alle entrate di un vettore: 
"""

# ╔═╡ b024c318-81cc-11eb-018c-e1f7830ff51b
md"""
Notare che `x.k == i` restituisce un valore di tipo booleano, `true` oppure `false`, che viene poi convertito nel corrispondente valore di tipo  `Int`: 
"""

# ╔═╡ 3f0d5036-b09e-4953-bafe-afb1cd9e6b7b
Int(true), Int(false)

# ╔═╡ c48d7a6b-8e8f-4ab9-a254-d2610371a9b5
[onehot_implicito[i] for i in 1:10]

# ╔═╡ c5ed7d3e-81cc-11eb-3386-15b72db8155d
md"""
Il nostro vettore di tipo `OneHot` si comporta come un vettore di 10 entrate, nonostante richieda al computer solo la memoria necessaria per 2 interi!
"""

# ╔═╡ e2e354a8-81b7-11eb-311a-35151063c2a7
md"""
### La funzione `dump`
"""

# ╔═╡ dc5a96ba-81cc-11eb-3189-25920df48afa
md"""
La funzione `dump` mostra i dati che sono internamente memorizzati da un oggetto in Julia:
"""

# ╔═╡ af0d3c22-f756-11ea-37d6-11b630d2314a
with_terminal() do
	dump(onehot_implicito)
end

# ╔═╡ 06e3a842-26b8-4417-9cf5-8a083ccdb264
md"""
Poiché `dump` scrive su terminale, non è possibile utilizzarlo direttamente all'interno di Pluto, ed è invece necessario racchiuderlo in un blocco `with_terminal`. In alternativa, si può utilizzare la funzione `Dump` del pacchetto `PlutoUI`:
"""

# ╔═╡ 91172a3e-81b7-11eb-0953-9f5e0207f863
Dump(onehot_implicito)

# ╔═╡ e1b4a55f-d474-4f13-b9f3-276464c268db
onehot_implicito

# ╔═╡ fe70d104-81b7-11eb-14d0-eb5237d8ea6c
md"""
### Visualizzare i vettori _one-hot_
"""

# ╔═╡ ef8f44b2-f5fc-11ea-1e4d-bd873cd39d6c
md"""
Dimensione del vettore: $n=$ $(@bind n′ Slider(1:20, show_value=true, default=3))
"""

# ╔═╡ fd9211c0-f5fc-11ea-1745-7f2dae88af9e
md"""
Coordinata uguale ad $1$: $k=$ $(@bind k′ Slider(1:n′, default=1, show_value=true))
"""

# ╔═╡ f1154df8-f693-11ea-3b16-f32835fcc470
x = OneHotImplicito(n′, k′)

# ╔═╡ 1158fcba-1e84-4401-a1d6-a40401a93f05
md"""
La precedente funzione `show_image` è simile a funzioni analoghe che abbiamo utilizzato in lezioni precedenti. 
Il codice della funzione dovrebbe essere autoesplicativo. 
Utilizzeremo lo _schema di colori_ `rainbow`, ma possiamo sceglierne un altro se preferiamo:  
"""

# ╔═╡ f0efe02e-500a-44fc-8654-17c205b21e46
colorschemes

# ╔═╡ 5813e1b2-f5ff-11ea-2849-a1def74fc065
function show_image(x) 
	row_vec = length(size(x)) > 1 ? x : x'
	normalized_vec = row_vec ./ maximum(row_vec)
	get(colorschemes[:rainbow], normalized_vec)
end

# ╔═╡ 982590d4-f5ff-11ea-3802-73292c75ad6c
show_image(x)

# ╔═╡ 81c35324-f5d4-11ea-2338-9f982d38732c
md"## Matrici diagonali"

# ╔═╡ 2cfda0dc-f5d5-11ea-16c4-b5a33b90e37f
md"""
Vediamo un altro esempio fondamentale: quello delle [matrici diagonali](https://it.wikipedia.org/wiki/Matrice_diagonale):
"""

# ╔═╡ 150432d4-f5d5-11ea-32b2-19a2a91d9637
denseD = [5 0 0 
	      0 6 0
	      0 0 -10]	

# ╔═╡ 44215aa4-f695-11ea-260e-b564c6fbcd4a
md"Julia ci permette di rappresentare matrici diagonali in modo conciso nel modo seguente:"

# ╔═╡ 21328d1c-f5d5-11ea-288e-4171ad35326d
D = Diagonal(denseD)

# ╔═╡ 6f412084-eb5e-48b1-809a-90be230ba6f3
typeof(D)

# ╔═╡ 75761cc0-81cd-11eb-1186-7d47debd68ca
md"""
Come vediamo, Julia rappresenta tali [matrici _sparse_](https://it.wikipedia.org/wiki/Matrice_sparsa) utilizzando dei punti al posto degli zeri, in modo da suggerire che le entrate della matrice uguali a zero vengono gestite in modo particolare dalla struttura di tipo  `Diagonal`. 

Un altro modo di creare una matrice diagonale è di fornire direttamente i valori della diagonale sotto forma di un vettore: 
"""

# ╔═╡ 6bd8a886-f758-11ea-2587-870a3fa9d710
Diagonal([5, 6, -10])

# ╔═╡ 4c533ac6-f695-11ea-3724-b955eaaeee49
md"""
Utilizzando la funzione `Dump` possiamo esaminare il contenuto dei diversi tipi tramite cui possiamo rappresentare la stessa matrice:
"""

# ╔═╡ 466901ea-f5d5-11ea-1db5-abf82c96eabf
Dump(denseD)

# ╔═╡ b38c4aae-f5d5-11ea-39b6-7b0c7d529019
Dump(D)

# ╔═╡ 93e04ed8-81cd-11eb-214a-a761ef8c406f
md"""
Come possiamo vedere, il tipo `Diagonal` memorizza solo le entrate diagonali. 
"""

# ╔═╡ 19775c3c-f5d6-11ea-15c2-89618e654a1e
md"## Matrici sparse"

# ╔═╡ 653792a8-f695-11ea-1ae0-43761c502583
md"""
Le matrici diagonali sono un caso particolare di matrici **sparse**, ovvero matrici in cui la gran parte delle entrate sono zero, e che è dunque opportuno memorizzare utilizzando una rappresentazione che sfrutta tale ridondanza. 
Consideriamo per esempio la seguente matrice: 
"""

# ╔═╡ 79c94d2a-f75a-11ea-031d-09d70d229e15
denseM = [0 0 9; 0 0 0; 12 0 4]

# ╔═╡ 10bc5d50-81b9-11eb-2ac7-354a6c6c826b
md"""
Un modo conciso di rappresentare tale matrice è come una lista di tuple `(i, j, v)`, dove $i$ e $j$ sono la riga e la colonna in cui il valore $v$ appare nella matrice.  
Una variante di tale idea è la codifica in formato [compressed sparse column](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_(CSC_or_CCS)):
"""

# ╔═╡ 77d6a952-81ba-11eb-24e3-cb6510a59455
M = sparse(denseM)

# ╔═╡ 1f3ba55a-81b9-11eb-001f-593b9d8639ca
md"""
Tale formato, CSC, è implementato dal pacchetto Julia [SparseArrays.jl](https://docs.julialang.org/en/v1/stdlib/SparseArrays/), il quale implementa in modo efficiente anche operazioni aritmetiche, prodotti matrice-vettore e [array slicing](https://en.wikipedia.org/wiki/Array_slicing). 
Ovviamente, per alcuni specifici tipi di matrice, altri formati potrebbero essere più opportuni. 

Facendo il `Dump` di `sparse(M)`, vediamo che è codificato dai dati seguenti: 
"""

# ╔═╡ 3d4a702e-f75a-11ea-031c-333d591fc442
Dump(sparse(M))

# ╔═╡ 7cc1ec53-d805-4462-91b9-ba9c226776e6
md"""
* `nzval` contiene le entrate della matrice diverse da zero
* in `rowval` l'$i$-esima entrata indica la riga in cui si trova l'$i$-esimo valore di `nzval` (ovvero, abbiamo `length(rowval) == length(nzval)`)
* `colptr[j]` indica qual'è il valore di `nzval` che corrisponde al primo valore diverso da zero che troviamo a partire dalla colonna $j$; per `colptr` abbiamo `length(colptr) == length(nzval) + 1` ed il suo ultimo valore riporta un indice superiore alla lunghezza di `nzval` per indicare che non vi sono ulteriori colonne.
"""

# ╔═╡ 43adc012-7946-4f33-8859-e16e50c94f55
md"""
#### Esercizio - CSC inefficiente

Qual'è un esempio di matrice per il quale il formato CSC non è una scelta efficiente in termini di memoria?
"""

# ╔═╡ 9db7783f-c2ed-48be-8ff0-4e63a4a24955
md"""
!!! hint "Soluzione 1"
	Considerare per esempio 
	```
	M2 = sparse([1, 2, 10^6], [4, 9, 10^6], [7, 8, 9])
	```
	e discutere l'output di `Dump(M2)`. 
"""

# ╔═╡ 313a83f9-06f5-46c5-aec0-1bca8b3408dd
md"""
!!! hint "Soluzione 2"
	Discutere l'output di `Dump(sparse(zeros(10,10)))`. 
"""

# ╔═╡ 62a6ec62-f5d9-11ea-071e-ed33c5dea0cd
md"""## Vettori aleatori
"""

# ╔═╡ 7f63daf6-f695-11ea-0b80-8702a83103a4
md"""
Quanta struttura possiamo trovare in un vettore aleatorio?

Si tratta di una domanda profonda che si collega a vari argomenti matematicamente ricchi, tra cui la [complessità di Kolmogorov](https://en.wikipedia.org/wiki/Kolmogorov_complexity#Kolmogorov_randomness). 

In questa sede ci manterremo però ad un livello elementare, limitandoci a qualche semplice osservazione diretta. Generiamo un vettore aleatorio:
"""

# ╔═╡ 67274c3c-f5d9-11ea-3475-c9d228e3bd5a
v = rand(1:9, 1_000_000)

# ╔═╡ 765c6552-f5d9-11ea-29d3-bfe7b4b04612
md"""
Potremmo essere tentati di dire che _non c'è alcuna struttura_. 

In un certo senso, però, il fatto che il vettore sia aleatorio costituisce di per sè un'assunzione che ci suggerisce molto sulla sua struttura. 
Per esempio, ci sono statistici che direbbero che la media e la deviazione standard di un vettore distribuito come sopra riassumono già gran parte di ciò che c'è da sapere su un tale vettore:
"""

# ╔═╡ 126fb3ea-f5da-11ea-2f7d-0b3259a296ce
mean(v), std(v)

# ╔═╡ 9389f76e-1944-425f-ba0a-f84318be8e0b
md"""
Le precedenti stime empiriche, calcolate su uno specifico vettore `v` precedentemente generato dalla funzione `rand`, sono molto vicine a quelle teoriche, ovvero: 
"""

# ╔═╡ 56e6bd2e-2602-41ea-a6c3-20fc31631f45
5, sqrt(10 * 2/3)

# ╔═╡ 24ce92fa-81cf-11eb-30f0-b1e357d79d53
md"""
Volendo calcolare delle statistiche più specifiche, potremmo calcolare quante volte ciascun valore compare nel vettore `v`: 
"""

# ╔═╡ 2d4500e0-81cf-11eb-1699-d310074fddf5
[sum(v .== i) for i in 1:9]

# ╔═╡ 3546ff30-81cf-11eb-3afc-05c5db61366f
md"""
Osserviamo che ciascun valore appare quasi lo stesso numero di volte degli altri. 

Per concludere, proviamo a calcolarci a mano i valori precedentemente calcolati usando le funzioni `mean` e `std`: 
"""

# ╔═╡ e68b98ea-f5da-11ea-1a9d-db45e4f80241
m = sum(v) / length(v)  # media

# ╔═╡ 62f23e22-ec4a-4399-b602-0cdec7a29fb8
mean(v)

# ╔═╡ f20ccac4-f5da-11ea-0e69-413b5e49f423
σ² = sum( (v .- m) .^ 2 ) / (length(v) - 1) # varianza

# ╔═╡ 12a2e96c-f5db-11ea-1c3e-494ae7446886
σ = sqrt(σ²) # deviazione standard

# ╔═╡ 22487ce2-f5db-11ea-32e9-6f70ab2c0353
std(v)

# ╔═╡ 389ae62e-f5db-11ea-1557-c3adbbee0e5c
md"Sometimes the summary statistics are all you want. (But sometimes not.)"

# ╔═╡ 0c2b6408-f5d9-11ea-2b7f-7fece2eecc1f
md"## [Tavole pitagoriche](https://it.wikipedia.org/wiki/Tavola_pitagorica)"

# ╔═╡ 534eb09e-3ca1-471b-86fa-2db036f735b4
md"""
#### Esercizio

Fornire un esempio interessante di matrice di dimensione $n\times n$ senza entrate nulle ma che può essere rappresentata con una struttura di dimensione $O(n)$.
"""

# ╔═╡ 1f8c0b21-9e74-409a-8547-f6f39e58f400
md"""
!!! hint "Soluzione non interessante"
	```
	fill(1, 10, 10)
	```
"""

# ╔═╡ 89bb3a50-cac1-4b45-b1b8-f47c7e8f7c8c
md"""
Scriviamo una funzione `outer` che genera la tavola pitagorica la cui entrata ``(i,j)`` è pari a ``v_i \cdot w_j``. 
"""

# ╔═╡ 5d767290-f5dd-11ea-2189-81198fd216ce
outer(v, w) = [x * y for x ∈ v, y ∈ w]  

# ╔═╡ 587790ce-f6de-11ea-12d9-fde2a17ae314
md"""
Generiamo ora in modo interattivo la tavola pitagorica della _tabellina del ``k``_:

 $k =$ $(@bind k Slider(1:20, show_value=true, default=9))
"""

# ╔═╡ 22b73baa-f6df-11ea-197f-bbb4bd1a7ef5
outer(1:k, 1:k)

# ╔═╡ 3c196bc4-dda0-4ba4-bee6-e5ea67678035
md"""
Notare che la funzione `outer` che abbiamo implementato ci permette di generare una  _tavola pitagorica_ in senso più generale, a partire da vettori arbitrari; tecnicamente, si tratta di quel che è chiamato in matematica [prodotto esterno](https://it.wikipedia.org/wiki/Prodotto_diadico):  
"""

# ╔═╡ b2332814-f6e6-11ea-1c7d-556c7d4687f1
outer([2,4,6], [10,100,1000])

# ╔═╡ 9ab7a72e-81cf-11eb-2b78-073ff51cae58
md"""
La matrice che risulta dal prodotto esterno di due vettori (nell'esempio precedente, ``(2,4,6)`` e ``(10,100,1000)``), salvo casi particolari, non è una matrice sparsa. Tuttavia, sono sufficienti due vettori di dimensione $n$ e $m$ per descrivere la matrice risultante di $nm$ entrate.  

Nel caso della tavola pitagorica, in cui dunque i sopracitati vettori siano della forma $(1, 2, ..., k)$, è addirittura sufficiente un solo valore per avere tutta l'informazione necessaria a ricostruire la tavola. 

#### Esercizio (difficile!) - tavola pitagorica

Implementare una struct `Tavola` che memorizza un solo intero positivo `k` ma restituisce `i*j` quando una sua istanza `t = Tavola(k)` viene chiamata come una matrice, ovvero `t[i, j]`. 
"""

# ╔═╡ c1f129d2-629d-4b58-af57-122f72e093f5
md"""
!!! hint "Suggerimento"
	Consultare l'esempio sui numeri di Fibonacci della [Lezione 4.0](https://natema.github.io/ECMJ-it/lectures/lezione_4.0_programmazione_dinamica.jl). 
	Mentre in quel caso volevamo far in modo che un oggetto di tipo `Fibo` potesse essere chiamato come un vettore, qui vogliamo far si che l'oggetto possa essere chiamato come una matrice. Per far ciò bisogna implementare il metodo `getindex` dove gli indici forniti sono di tipo [`Vararg{Int}`](https://docs.julialang.org/en/v1/base/base/#Core.Vararg):
	```
	Base.getindex(A::Tavola, I::Vararg{Int}) = I[1]*I[2]
	```
"""

# ╔═╡ fee03cf9-b573-47e8-9033-a78ee38faa73
md"""
!!! hint "Soluzione"
	```
	struct Tabella
		k::Int
	end

	Base.getindex(t::Tabella, I::Vararg{Int}) = I[1]*I[2]
	```
	Test:
	```
	t = Tabella(10)
	t[2, 4] # 8
	```
"""

# ╔═╡ 165788b2-f601-11ea-3e69-cdbbb6558e54
md"""
Se ora guardiamo una generica matrice, è naturale chiedersi se abbia o meno una certa struttura:
"""

# ╔═╡ 22941bb8-f601-11ea-1d6e-0d955297bc2e
Mᵣ = outer( rand(5), rand(7) )  

# ╔═╡ c33bf00e-81cf-11eb-1e1a-e5a879a45093
md"""
Nel caso della precedente matrice `Mᵣ`, possiamo provare a visualizzarla per vedere se una qualche struttura salta ai nostri occhi:
"""

# ╔═╡ 2f75df7e-f601-11ea-2fc2-aff4f335af33
show_image( Mᵣ )

# ╔═╡ 7ff664f0-f74b-11ea-0d2d-b53f19e4f4bf
md"""
Di seguito vediamo come [fattorizzare](https://it.wikipedia.org/wiki/Fattorizzazione)  una matrice come prodotto esterno di due vettori, assumendo che sia possibile farlo. Nel caso in cui tale assunzione fosse errata però... 
"""

# ╔═╡ a0611eaa-81bc-11eb-1d23-c12ab14138b1
md"""
### Lanciare eccezioni in Julia: `error`

Un'eccezione è qualsiasi cosa che può interrompere un programma, ad esempio dati di input non validi.
"""

# ╔═╡ a4728944-f74b-11ea-03c3-9123908c1f8e
function factor( tavola ) 
	v = tavola[:, 1]
	w = tavola[1, :]
	
	if v[1] ≠ 0 
		w /= v[1] 
	end
	
	# Del buon codice controlla il risultato: 
	if outer(v, w) ≈ tavola
	   return v, w
	else
		error("L'input non è un prodotto esterno")
	end
end

# ╔═╡ 05c35402-f752-11ea-2708-59cf5ef74fb4
factor( outer([1, 0, -1], [1, -1, -1] ) )

# ╔═╡ 7f049de0-b46d-4c5e-b4a5-567ae5e562cc
md"""
#### Esercizio - Problemino di conteggio

- Quante sono le possibili matrici $n\times n$ le cui entrate sono uguali a $-1$, $0$ oppure $1$?
- E i possibili prodotto esterni risultanti da due vettori di dimensione $n$ le cui entrate prendono valore nell'insieme $\{-1, 0, 1\}$?
"""

# ╔═╡ 8c11b19e-81bc-11eb-184b-bf6ffefe29de
md"""
Come conseguenza dell'esercizio precedente, una matrice aleatoria in pratica non è mai un prodotto esterno: 
"""

# ╔═╡ 8baaa994-f752-11ea-18d9-b3d0a6b9f7d9
factor( rand(2,2) )

# ╔═╡ 7a2f88fb-ccad-42ec-8f8c-b5a9e14b3eea
md"""
### Visualizzare prodotti esterni
"""

# ╔═╡ 2370f3a5-3fc6-4e62-a615-d23e9277aa72
md"""
Consideriamo il seguente prodotto esterno:
"""

# ╔═╡ a5d637ea-f5de-11ea-3b70-877e876bc9c9
flag = outer([1,1,1,2,2,2,1,1,1], [1,1,1,1,1,1,1,1,1])

# ╔═╡ 7b1dbc34-459a-4143-8090-8a705444a5a2
md"""
La funzione `distinguishable_colors` restituisce automaticamente un array di colori distinti: 
"""

# ╔═╡ 21bbb60a-f5df-11ea-2c1b-dd716a657df8
cs = distinguishable_colors(100)

# ╔═╡ b02ba1b5-fee7-4722-9f9a-defce9b54dd6
md"""
In modo alquanto conveniente, se forniamo una matrice di interi `flag` come argomento all'array di colori `cs`, ci verrà restituita l'immagine in cui ogni entrata $(i,j)$ di `flag` è colorata col colore `cs[flag[i,j]]`:
"""

# ╔═╡ 2668e100-f5df-11ea-12b0-073a578a5edb
cs[flag]

# ╔═╡ c2690dcb-b00c-4c49-88f3-9681e164e506
md"""
In Julia, similmente alla comune notazione matematica, possiamo ottenere la [trasposta di una matrice](https://it.wikipedia.org/wiki/Matrice_trasposta) utilizzando semplicemente il simbolo di apice: 
"""

# ╔═╡ d774117f-f545-4273-9075-bc79d7bf7868
flag'

# ╔═╡ 6c916683-b337-4ce6-9786-6229d749dc2f
md"""
Possiamo indovinare l'immmagine che risulterà se visualizziamo la somma di `flag` e della sua trasposta:
"""

# ╔═╡ 483e0a1f-9890-4c3d-8165-15497db43c7f
flag + flag'

# ╔═╡ e8d727f2-f5de-11ea-1456-f72602e81e0d
cs[flag + flag']

# ╔═╡ f5fcdeea-f75c-11ea-1fc3-731f0ef1ad14
md"""
#### Esercizio - Prodotti esterni trasposti

Qual'è la relazione tra un prodotto esterno e la trasposta della matrice risultante? Si può scrivere quest'ultima direttamente come prodotto esterno?
"""

# ╔═╡ 0373fbf6-f75d-11ea-2a9e-cbb714d69cf4
md"""
!!! hint "\"Soluzione\""
	Confrontare l'immagine sopra ottenuta con `cs[flag + flag']` e 
	```
	cs[
		outer([1,1,1,2,2,2,1,1,1], [1,1,1,1,1,1,1,1,1]) + 
		outer([1,1,1,1,1,1,1,1,1], [1,1,1,2,2,2,1,1,1])
	])
	```
"""

# ╔═╡ ebd72fb8-f5e0-11ea-0630-573337dff753
md"""
## La [_singular value decomposition_](https://en.wikipedia.org/wiki/Singular_value_decomposition) (SVD)
"""

# ╔═╡ e740999c-f754-11ea-2089-4b7a9aec6030
A = sum( outer(rand(2),rand(2)) for i=1:2 )

# ╔═╡ 0a79a7b4-f755-11ea-1b2d-21173567b257
md"""
È possibile capire se una matrice si può esprimere come somma di prodotti esterni?

La risposta è si: si tratta dell'idea più profonda dell'algebra lineare, ovvero la [decomposizione ai valori singolari](https://it.wikipedia.org/wiki/Decomposizione_ai_valori_singolari), in inglese **SVD** (singular value decomposition):
"""

# ╔═╡ 5a493052-f601-11ea-2f5f-f940412905f2
begin
	U, Σ, V = svd(A)
	
	A ≈ outer( U[:, 1], V[:, 1] * Σ[1] ) + outer( U[:, 2], V[:, 2] * Σ[2] ) 
end

# ╔═╡ 55b76aee-81d0-11eb-0bcc-413f5bd14360
md"""
Come vediamo, la matrice originale $A$ è ricostruita come prodotto esterno delle colonne delle matrici $U$ e $V$ risultanti dalla decomposizione a valori singolari, moltiplicate per dei fattori $Σᵢ$ su cui ci soffermiamo in seguito. 

Per ora, facciamo un'osservazione importante: cosa succede se consideriamo solo i primi 2 prodotti esterni quando proviamo a _ricostruire_ $A$ ricombinando l'output della SVD?
"""

# ╔═╡ 709bf30a-f755-11ea-2e82-bd511e598c77
B = rand(3, 3)

# ╔═╡ 782532b0-f755-11ea-1385-cd1a28c4b9d5
begin
	UU, ΣΣ, VV = svd( B )
    outer( UU[:,1], VV[:,1] * ΣΣ[1] ) + outer( UU[:,2], VV[:,2] * ΣΣ[2] ) 
end

# ╔═╡ 5bc4ab0a-f755-11ea-0fad-4987ad9fc02f
md"""
Come vediamo, una ricostruzione parziale usando la SVD sembra fornire una buona approssimazione della matrice di partenza. 
"""

# ╔═╡ cffb2728-48d5-4f32-90c7-8a7405be6bf5
md"""
### SVD di immagini
"""

# ╔═╡ b6478e1a-f5f6-11ea-3b92-6d4f067285f4
armadillo_url = "https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/armadillo_zerocalcare.png"

# ╔═╡ f2c11f88-f5f8-11ea-3e02-c1d4fa22031e
image = load(download(armadillo_url))

# ╔═╡ 3e6947b6-f2e9-41bb-9160-97f18b90946a
md"""
Convertiamo l'immagine in un array di valori `Float64`:
"""

# ╔═╡ 29062f7a-f5f9-11ea-2682-1374e7694e32
picture = Float64.(channelview(image));

# ╔═╡ 5471fd30-f6e2-11ea-2cd7-7bd48c42db99
size(picture)

# ╔═╡ 6c4d53b2-b3c2-4e2f-bc2a-b17d73cb3bd0
md"""
Separiamo i diversi _canali_, rosso verde e blu, usando la funzione `eachslice`: 
"""

# ╔═╡ 6156fd1e-f5f9-11ea-06a9-211c7ab813a4
pr, pg, pb = eachslice(picture, dims=1)

# ╔═╡ 3d775e5c-98ab-427a-aff6-2bf32e9a4cdd
md"""
Controlliamo il risultato dell'operazione precedente visualizzando le tre matrici  risultanti:
"""

# ╔═╡ a9766e68-f5f9-11ea-0019-6f9d02050521
[RGB.(pr, 0, 0) RGB.(0, pg, 0) RGB.(0, 0, pb)]

# ╔═╡ 1b32370d-a2a5-4ade-9bfc-c33b282a72a0
md"""
Calcoliamo le rispettive SVD: 
"""

# ╔═╡ 0c0ee362-f5f9-11ea-0f75-2d2810c88d65
begin
	Ur, Σr, Vr = svd(pr)
	Ug, Σg, Vg = svd(pg)
	Ub, Σb, Vb = svd(pb)
end;

# ╔═╡ b95ce51a-f632-11ea-3a64-f7c218b9b3c9
md"""
Vediamo che immagine otteniamo sommando solo i primi $h$ prodotti esterni costituiti dai primi $h$ vettori ricavati dalle precedenti SVD. 

Numero $k$ di prodotti esterni sommati: $(@bind h Slider(1:383, show_value=true, default=16)) (possiamo cliccare sullo slider e usare le frecce "←" e "→" per settarne il valore preciso).
"""

# ╔═╡ 7ba6e6a6-f5fa-11ea-2bcd-616d5a3c898b
RGB.(sum(outer(Ur[:,i], Vr[:,i]) .* Σr[i] for i in 1:h), 
	 sum(outer(Ug[:,i], Vg[:,i]) .* Σg[i] for i in 1:h),
	 sum(outer(Ub[:,i], Vb[:,i]) .* Σb[i] for i in 1:h))

# ╔═╡ 0edd7cca-834f-11eb-0232-ff0850027f76
md"## Alcune conclusioni e nuova sintassi"

# ╔═╡ 69be8194-81b7-11eb-0452-0bc8b9f22286
md"""
* Le `struct` sono un ottimo modo per strutturare i dati che costituiscono un oggetto.
* La funzione `dump` (e `Dump` in Pluto) ci permette di esaminare il contenuto di una struttra di dati.
* Matrici diagonali e sparse possono essere efficientemente rappresentate attreverso le funzioni `diagonal` e `sparse`.
* Possiamo lanciare eccezioni facendo uso della funzione `error`. 
* La decomposizione a valori singolari di una matrice si può ottenere tramite la funzione `svd`. 
"""

# ╔═╡ a705d2f2-0222-49b1-9306-21aaee0b6467
md"""
## Appendice
"""

# ╔═╡ 2e68fb0a-55b0-419b-9d40-5c1f7c0000c6
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Suggerimento", [text]))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorSchemes = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
ColorSchemes = "~3.18.0"
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
FileIO = "~1.14.0"
ImageIO = "~0.6.5"
ImageShow = "~0.3.6"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
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
git-tree-sha1 = "9489214b993cd42d17f44c36e359bf6a7c919abf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "0f4e115f6f34bbe43c19751c90a38b2f380637b9"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.3"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "d9a03ffc2f6650bd4c831b285637929d99a4efb5"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.5"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

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
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

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

[[deps.LazyModules]]
git-tree-sha1 = "f4d24f461dacac28dcd1f63ebd88a8d9d0799389"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.0"

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
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

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
git-tree-sha1 = "e7fa2526bf068ad5cbfe9ba7e8a9bbd227b3211b"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.1"

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
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

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
git-tree-sha1 = "bc40f042cfcc56230f781d92db71f0e21496dffd"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.5"

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

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╟─0db6ee04-81b7-11eb-330c-11b578b72c90
# ╠═864e1180-f693-11ea-080e-a7d5aabc9ca5
# ╟─ca1a1072-81b6-11eb-1fee-e7df687cc314
# ╟─b0ba5b8c-f5d1-11ea-1304-3f0e47f935fe
# ╟─4419ebba-58ca-454e-b024-380fd364c99b
# ╟─2bb8a710-cc5d-4e4b-b861-ecb99470ef47
# ╠═ffa71052-2e18-4cec-8675-92369413716f
# ╠═5bbf07a0-8833-470d-8603-11563cae6b2c
# ╠═59cdf85e-705c-4d0a-bd67-08a30d1f732d
# ╠═799e705e-b560-4d21-822e-10a6726b3c5e
# ╟─eb6521e8-4f2e-4319-9c35-384981b321b4
# ╠═62c29c56-313a-44d9-8626-5d181a824c3d
# ╟─261c4df2-f5d2-11ea-2c72-7d4b09c46098
# ╟─3cada3a0-81cc-11eb-04c8-bde26d36a84e
# ╠═fe2028ba-f6dc-11ea-0228-938a81a91ace
# ╠═0a902426-f6dd-11ea-0ae4-fb0c47863fe7
# ╟─8d2c6910-f5d4-11ea-1928-1baf09815687
# ╟─4794e860-81b7-11eb-2c91-8561c20f308a
# ╟─67827da8-81cc-11eb-300e-278104d2d958
# ╠═4624cd26-f5d3-11ea-1cf8-7d6555eae5fa
# ╟─9bdabef8-81cc-11eb-14a1-67a9a7d968c0
# ╠═1340e0e5-7d33-4356-affa-60882536b358
# ╠═397ac764-f5fe-11ea-20cc-8d7cab19d410
# ╠═94ca00b6-8f94-4786-a27c-eff7b2ad7ae3
# ╠═0d28115a-b97e-4ac7-a4b1-555fcd6beefd
# ╟─a22dcd2c-81cc-11eb-1252-13ace134192d
# ╠═82c7046c-f5d3-11ea-04e2-ef7c0f4db5da
# ╟─b024c318-81cc-11eb-018c-e1f7830ff51b
# ╠═3f0d5036-b09e-4953-bafe-afb1cd9e6b7b
# ╠═c48d7a6b-8e8f-4ab9-a254-d2610371a9b5
# ╟─c5ed7d3e-81cc-11eb-3386-15b72db8155d
# ╟─e2e354a8-81b7-11eb-311a-35151063c2a7
# ╟─dc5a96ba-81cc-11eb-3189-25920df48afa
# ╠═af0d3c22-f756-11ea-37d6-11b630d2314a
# ╟─06e3a842-26b8-4417-9cf5-8a083ccdb264
# ╠═91172a3e-81b7-11eb-0953-9f5e0207f863
# ╠═e1b4a55f-d474-4f13-b9f3-276464c268db
# ╟─fe70d104-81b7-11eb-14d0-eb5237d8ea6c
# ╟─ef8f44b2-f5fc-11ea-1e4d-bd873cd39d6c
# ╟─fd9211c0-f5fc-11ea-1745-7f2dae88af9e
# ╠═f1154df8-f693-11ea-3b16-f32835fcc470
# ╠═982590d4-f5ff-11ea-3802-73292c75ad6c
# ╟─1158fcba-1e84-4401-a1d6-a40401a93f05
# ╠═f0efe02e-500a-44fc-8654-17c205b21e46
# ╠═5813e1b2-f5ff-11ea-2849-a1def74fc065
# ╟─81c35324-f5d4-11ea-2338-9f982d38732c
# ╟─2cfda0dc-f5d5-11ea-16c4-b5a33b90e37f
# ╠═150432d4-f5d5-11ea-32b2-19a2a91d9637
# ╟─44215aa4-f695-11ea-260e-b564c6fbcd4a
# ╠═21328d1c-f5d5-11ea-288e-4171ad35326d
# ╠═6f412084-eb5e-48b1-809a-90be230ba6f3
# ╟─75761cc0-81cd-11eb-1186-7d47debd68ca
# ╠═6bd8a886-f758-11ea-2587-870a3fa9d710
# ╟─4c533ac6-f695-11ea-3724-b955eaaeee49
# ╠═466901ea-f5d5-11ea-1db5-abf82c96eabf
# ╠═b38c4aae-f5d5-11ea-39b6-7b0c7d529019
# ╟─93e04ed8-81cd-11eb-214a-a761ef8c406f
# ╟─19775c3c-f5d6-11ea-15c2-89618e654a1e
# ╟─653792a8-f695-11ea-1ae0-43761c502583
# ╠═79c94d2a-f75a-11ea-031d-09d70d229e15
# ╟─10bc5d50-81b9-11eb-2ac7-354a6c6c826b
# ╠═77d6a952-81ba-11eb-24e3-cb6510a59455
# ╟─1f3ba55a-81b9-11eb-001f-593b9d8639ca
# ╠═3d4a702e-f75a-11ea-031c-333d591fc442
# ╟─7cc1ec53-d805-4462-91b9-ba9c226776e6
# ╟─43adc012-7946-4f33-8859-e16e50c94f55
# ╟─9db7783f-c2ed-48be-8ff0-4e63a4a24955
# ╟─313a83f9-06f5-46c5-aec0-1bca8b3408dd
# ╟─62a6ec62-f5d9-11ea-071e-ed33c5dea0cd
# ╟─7f63daf6-f695-11ea-0b80-8702a83103a4
# ╠═67274c3c-f5d9-11ea-3475-c9d228e3bd5a
# ╟─765c6552-f5d9-11ea-29d3-bfe7b4b04612
# ╠═126fb3ea-f5da-11ea-2f7d-0b3259a296ce
# ╟─9389f76e-1944-425f-ba0a-f84318be8e0b
# ╠═56e6bd2e-2602-41ea-a6c3-20fc31631f45
# ╟─24ce92fa-81cf-11eb-30f0-b1e357d79d53
# ╠═2d4500e0-81cf-11eb-1699-d310074fddf5
# ╟─3546ff30-81cf-11eb-3afc-05c5db61366f
# ╠═e68b98ea-f5da-11ea-1a9d-db45e4f80241
# ╠═62f23e22-ec4a-4399-b602-0cdec7a29fb8
# ╠═f20ccac4-f5da-11ea-0e69-413b5e49f423
# ╠═12a2e96c-f5db-11ea-1c3e-494ae7446886
# ╠═22487ce2-f5db-11ea-32e9-6f70ab2c0353
# ╟─389ae62e-f5db-11ea-1557-c3adbbee0e5c
# ╟─0c2b6408-f5d9-11ea-2b7f-7fece2eecc1f
# ╟─534eb09e-3ca1-471b-86fa-2db036f735b4
# ╟─1f8c0b21-9e74-409a-8547-f6f39e58f400
# ╟─89bb3a50-cac1-4b45-b1b8-f47c7e8f7c8c
# ╠═5d767290-f5dd-11ea-2189-81198fd216ce
# ╟─587790ce-f6de-11ea-12d9-fde2a17ae314
# ╠═22b73baa-f6df-11ea-197f-bbb4bd1a7ef5
# ╟─3c196bc4-dda0-4ba4-bee6-e5ea67678035
# ╠═b2332814-f6e6-11ea-1c7d-556c7d4687f1
# ╟─9ab7a72e-81cf-11eb-2b78-073ff51cae58
# ╟─c1f129d2-629d-4b58-af57-122f72e093f5
# ╟─fee03cf9-b573-47e8-9033-a78ee38faa73
# ╟─165788b2-f601-11ea-3e69-cdbbb6558e54
# ╠═22941bb8-f601-11ea-1d6e-0d955297bc2e
# ╟─c33bf00e-81cf-11eb-1e1a-e5a879a45093
# ╠═2f75df7e-f601-11ea-2fc2-aff4f335af33
# ╟─7ff664f0-f74b-11ea-0d2d-b53f19e4f4bf
# ╟─a0611eaa-81bc-11eb-1d23-c12ab14138b1
# ╠═a4728944-f74b-11ea-03c3-9123908c1f8e
# ╠═05c35402-f752-11ea-2708-59cf5ef74fb4
# ╟─7f049de0-b46d-4c5e-b4a5-567ae5e562cc
# ╟─8c11b19e-81bc-11eb-184b-bf6ffefe29de
# ╠═8baaa994-f752-11ea-18d9-b3d0a6b9f7d9
# ╟─7a2f88fb-ccad-42ec-8f8c-b5a9e14b3eea
# ╟─2370f3a5-3fc6-4e62-a615-d23e9277aa72
# ╠═a5d637ea-f5de-11ea-3b70-877e876bc9c9
# ╟─7b1dbc34-459a-4143-8090-8a705444a5a2
# ╠═21bbb60a-f5df-11ea-2c1b-dd716a657df8
# ╟─b02ba1b5-fee7-4722-9f9a-defce9b54dd6
# ╠═2668e100-f5df-11ea-12b0-073a578a5edb
# ╟─c2690dcb-b00c-4c49-88f3-9681e164e506
# ╠═d774117f-f545-4273-9075-bc79d7bf7868
# ╟─6c916683-b337-4ce6-9786-6229d749dc2f
# ╠═483e0a1f-9890-4c3d-8165-15497db43c7f
# ╠═e8d727f2-f5de-11ea-1456-f72602e81e0d
# ╟─f5fcdeea-f75c-11ea-1fc3-731f0ef1ad14
# ╟─0373fbf6-f75d-11ea-2a9e-cbb714d69cf4
# ╟─ebd72fb8-f5e0-11ea-0630-573337dff753
# ╠═e740999c-f754-11ea-2089-4b7a9aec6030
# ╟─0a79a7b4-f755-11ea-1b2d-21173567b257
# ╠═5a493052-f601-11ea-2f5f-f940412905f2
# ╟─55b76aee-81d0-11eb-0bcc-413f5bd14360
# ╠═709bf30a-f755-11ea-2e82-bd511e598c77
# ╠═782532b0-f755-11ea-1385-cd1a28c4b9d5
# ╟─5bc4ab0a-f755-11ea-0fad-4987ad9fc02f
# ╟─cffb2728-48d5-4f32-90c7-8a7405be6bf5
# ╠═b6478e1a-f5f6-11ea-3b92-6d4f067285f4
# ╠═f2c11f88-f5f8-11ea-3e02-c1d4fa22031e
# ╟─3e6947b6-f2e9-41bb-9160-97f18b90946a
# ╠═29062f7a-f5f9-11ea-2682-1374e7694e32
# ╠═5471fd30-f6e2-11ea-2cd7-7bd48c42db99
# ╟─6c4d53b2-b3c2-4e2f-bc2a-b17d73cb3bd0
# ╠═6156fd1e-f5f9-11ea-06a9-211c7ab813a4
# ╟─3d775e5c-98ab-427a-aff6-2bf32e9a4cdd
# ╠═a9766e68-f5f9-11ea-0019-6f9d02050521
# ╟─1b32370d-a2a5-4ade-9bfc-c33b282a72a0
# ╠═0c0ee362-f5f9-11ea-0f75-2d2810c88d65
# ╟─b95ce51a-f632-11ea-3a64-f7c218b9b3c9
# ╠═7ba6e6a6-f5fa-11ea-2bcd-616d5a3c898b
# ╟─0edd7cca-834f-11eb-0232-ff0850027f76
# ╟─69be8194-81b7-11eb-0452-0bc8b9f22286
# ╟─a705d2f2-0222-49b1-9306-21aaee0b6467
# ╟─2e68fb0a-55b0-419b-9d40-5c1f7c0000c6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
