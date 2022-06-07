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

# ╔═╡ 9a0cec14-08db-11eb-3cfa-4d1c327c63f1
begin
    using Plots, PlutoUI, StatsBase, Statistics
end

# ╔═╡ 2c343416-2b20-4aa1-ac7b-2fada1606a38
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)

Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ fb6cdc08-8b44-11eb-09f5-43c167aa53fd
PlutoUI.TableOfContents(aside=true)

# ╔═╡ f3aad4f0-8cc2-11eb-1a25-535297327c65
md"""
# Simulare il guasto di componenti
"""

# ╔═╡ d2c19564-8b44-11eb-1077-ddf6d1395b59
md"""
## Modelli basati sull'agente

Nello studio degli [agent-based models](https://en.wikipedia.org/wiki/Agent-based_model), si cerca di capire il comportamento globale di un sistema in funzione delle regole che specificano il comportamento dei singoli individui, per esempio quanti saranno gli individui infettati in un certo momento, assumendo che i singoli individui interagiscono in un certo modo. 
"""

# ╔═╡ dd5d1601-b8b0-46bd-864f-863f302d0548
html"<img src=https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Complex_systems_organizational_map.jpg/1024px-Complex_systems_organizational_map.jpg width=500 >"

# ╔═╡ 50689c9e-b9a7-4e20-875a-77ae9e6da5b0
md"""
In questo notebook, ci poniamo l'obiettivo di mostrare, in un caso molto semplice, come si possano derivare equazioni **deterministiche** per il comportamento _macroscopico_ di un sistema, a partire dal comportamento _microscopico_ e **probabilistico** dei singoli agenti. 

Le equazioni macroscopiche possono essere a **tempo discreto** (nella forma di [equazioni di ricorrenza](https://it.wikipedia.org/wiki/Relazione_di_ricorrenza) oppure [equazioni alle differenze](https://it.wikipedia.org/wiki/Equazione_alle_differenze)), oppure a **tempo continuo** (nella forma di [equazioni differenziali](https://it.wikipedia.org/wiki/Equazione_differenziale)). 
"""

# ╔═╡ 4ca399f4-8b45-11eb-2d2b-8189e04fc804
md"""
## Modellare il tempo di successo o fallimento 

Iniziamo con un modello molto semplice di **tempo di successo**. Supponiamo di giocare una partita in cui abbiamo una probabilità $p$ di successo ad ogni turno. Di quanti turni abbiamo mediamente bisogno prima di avere successo? Ad esempio, di quanti lanci di dado abbiamo bisogno prima di ottenere un 6? Quanti lanci di 2 dadi ci vorranno prima di ottenere un doppio 6?

Il precedente problema può tornare utile come modello di molte situazioni diverse, ad esempio: il tempo di guasto di una lampadina o di un macchinario; il tempo di decadimento di un nucleo radioattivo; il tempo di guarigione da un'infezione, ecc.


"""

# ╔═╡ 34895756-6c21-497f-a603-1aaa07eb9097
html"<img src=https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Carbonfilament.jpg/1024px-Carbonfilament.jpg width=300>"

# ╔═╡ 43745d01-7906-4722-a427-244b7465ca4a
md"""
Più precisamente, la domanda di base assume la forma seguente:
> Supponiamo di avere $N$ lampadine che funzionano correttamente il giorno $0$. 
> - Se, ogni giorno, ogni lampadina ha una probabilità $p$ di guastarsi, quante sono ancora funzionanti al giorno $t$?
> - Quanto durerà in media una determinata lampadina?
> - E se le lampadine si guastassero esattamente a mezzanotte? Potremmo immaginare un modello più realistico?

Come al solito, adotteremo un punto di vista computazionale: scriveremo il codice della simulazione e ne visualizzeremo i risultati. 
"""

# ╔═╡ 17812c7c-8cac-11eb-1d0a-6512415f6938
md"""
### Visualizzare il fallimento di componenti
"""

# ╔═╡ 179a4db2-8cac-11eb-374f-0f24dc81ebeb
md"""
 $M=$ $(@bind M Slider(2:20, show_value=true, default=8))
"""

# ╔═╡ 17cf895a-8cac-11eb-017e-c79ffcab60b1
md"""
 $p =$ $(@bind prob Slider(0.01:.01:1, show_value=true, default=.1))

 $tₛ =$ $(@bind tₛ Slider(1:100, show_value=true, default=20))
"""

# ╔═╡ a38fe2b2-8cae-11eb-19e8-d563e82855d3
gr()

# ╔═╡ 18da7920-8cac-11eb-07f4-e109298fd5f1
begin
	rectangle(w, h, x, y) = (x .+ [0, w, w, 0], y .+ [0, 0, h, h])
	circle(r, x, y) = (θ = range(0, 2π, length=30); (x .+ r .* cos.(θ), y .+ r .* sin.(θ)))
end

# ╔═╡ a9447530-8cb6-11eb-38f7-ff69a640e3c4
md"""
## Interpolazione di stringhe

Come possiamo visualizzare un'immagine di Daniel Bernoulli e ridimensionarla in Pluto? Per farlo utilizziamo del codice HTML, che rappresentiamo come una stringa. Per sostituire il *valore* di una variabile in Julia all'interno di una stringa, usiamo l'interpolazione di stringhe scrivendo `$(nome_variabile)` all'interno della stringa stessa. Dopodiché, convertiamo la stringa in codice HTML con la funzione `HTML(...)`:
"""

# ╔═╡ 18755e3e-8cac-11eb-37bf-1dfa5fbe730a
@bind bernoulliwidth Slider(10:10:500, show_value=true, default=130)

# ╔═╡ f947a976-8cb6-11eb-2ae7-59eba4c6f40f
url = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg/440px-ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg"

# ╔═╡ 5a0b407e-8cb7-11eb-0c0d-c7767a6b0a1d
s = "<img src=$(url) width=$(bernoulliwidth) >"

# ╔═╡ fe53ee0c-8cb6-11eb-19bc-2976da1abe16
md"""
Notare che potremmo usare tre apici consecutivi (`\"\""`) per rappresentare stringhe su più righe o per includere una stringa che include essa estessa degli apici (come stiamo facendo nel sorgente di questa cella!)
"""

# ╔═╡ 1894b388-8cac-11eb-2287-97f985df1fbd
HTML(s)

# ╔═╡ 88dd73cc-33ae-4151-bbe3-e14d9895f0b3
md"""
Qualche altro esempio di codice HMTL in Pluto: 
"""

# ╔═╡ 86299112-8cc6-11eb-257a-9d803feac359
html"3 <br> 4"

# ╔═╡ b8d01ae4-8cc6-11eb-1d16-47095532f738
@bind num_breaks Slider(1:10, show_value=true, default=2)

# ╔═╡ c5bc97aa-8cc6-11eb-3564-fd96184ff2c3
repeat("<br>", 3) # un modo di ripetere una stringa

# ╔═╡ e1769d6d-9896-4054-ad3b-52f7751711e2
"<br>" * "<br>" * "<br>" # stringhe si possono concatenare con `*`

# ╔═╡ d5cffd96-8cc6-11eb-2714-975d46d4fa27
"<br>"^3 # sintassi equivalente all'uso di `repeat`

# ╔═╡ fc715452-8cc6-11eb-0246-e941f7698cfe
HTML("3 $("<br>"^num_breaks) 4")

# ╔═╡ 71fbc75e-8bf3-11eb-3ac9-dd5401033c78
md"""
## Variabili aleatorie di Bernoulli 

Una [variabile aleatoria di Bernoulli](https://it.wikipedia.org/wiki/Distribuzione_di_Bernoulli) modella il lancio di una moneta: è uguale a 1 (testa) con probabilità $p$, e $0$ (croce) con probabilità $1-p$. 
"""

# ╔═╡ dcd279b0-8bf3-11eb-0cb9-95f351626ed1
md"""
Notare che `rand() < p` restituisce un booleano `Bool` (`true` o `false`), che convertiamo con `Int` per ottenere un valore uguale a 1 o 0.
"""

# ╔═╡ ac98f5da-8bf3-11eb-076f-597ce4455e76
md"""
Quali sono la media e la varianza del campione `filps`?
"""

# ╔═╡ 4edaec4a-8bf4-11eb-3094-010ebe9b56ab
md"""
### Costruire il tipo `Bernoulli`

Sopra abbiamo usato una funzione per generare una variabile aleatoria di Bernoulli, e altre due funzioni per calcolarne la media e la varianza. 
Dal punto di vista matematico, la media e la varianza della variabile aleatoria sono proprietà di quest'ultima. 
Nel [notebook sulle strutture](https://natema.github.io/ECMJ-it-2022/lectures/lezione_4.2_strutture.jl) abbiamo visto come rendere quest'ultima osservazione concreta implementando un nuovo _tipo di oggetto_:
"""

# ╔═╡ 8405e310-8bf8-11eb-282b-d93b4fc683aa
"""
Lancio di una moneta che dà testa con probabilità ``p``.
"""
struct Bernoulli 
	p::Float64
end

# ╔═╡ af2594c4-8cad-11eb-0fff-f59e65102b3f
md"""
Tra i metodi di cui vorremmo disponesse il tipo che stiamo definendo, vi sono il metodo `rand` e `mean`. Operiamo dunque un [_overloading_](https://en.wikipedia.org/wiki/Function_overloading) di quest'ultime funzioni, rispettivamente delle librerie standard `Base` e `Statistics`:
"""

# ╔═╡ 8aa60da0-8bf8-11eb-0fa2-11aeecb89564
Base.rand(X::Bernoulli) = Int( rand() < X.p )

# ╔═╡ 2d9c560e-8bf9-11eb-1ac5-f77f7caf776f
Statistics.mean(X::Bernoulli) = X.p

# ╔═╡ 8d56b6d2-8cc8-11eb-0dbd-b3533dde4aa3
md"""
Ricordiamo che per convenzione in Julia i nomi di variabili iniziano con la lettera minuscola mentre i tipi iniziano con la maiuscola (con la possibili eccezioni per variabili mathematiche di una sola lettera).
"""

# ╔═╡ a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
B = Bernoulli(1//4)

# ╔═╡ ce94541c-8bf9-11eb-1ac9-51e66a017813
mean(B)

# ╔═╡ fa2a4404-fea7-41b2-bc26-3983f1d4bbd3
md"""
Verifichiamo i metodi disponibili per il typo `Bernoulli`: 
"""

# ╔═╡ c166edb6-8cc8-11eb-0436-f74164ff6ea7
methods(Bernoulli)

# ╔═╡ 3ef23da4-8cb4-11eb-0d5f-d5ee8fc56227
md"""
L'oggetto `B` rappresenta a tutti gli effetti una _variabile random Bernoulli di parametro $p$_. Per futuri usi, questa e molte altre distribuzioni sono implementate nei pacchetti [Distributions.jl](https://juliastats.org/Distributions.jl/stable/) e [MeasureTheory.jl](https://cscherrer.github.io/MeasureTheory.jl/stable/).
"""

# ╔═╡ a057e7ee-8bf9-11eb-2ceb-2dda3718a70a
md"""
## Eseguire la simulazione 
"""

# ╔═╡ ec5faae8-5ddc-42a2-993b-0fcc41b47012
md"""
Immaginiamo di rappresentare una popolazione di individui malati con un vettore di booleani, e che ogni individuo, ad ogni istante di tempo discreto, può guarire con una probabilità fissata $p_r$ uguale per tutti: 
"""

# ╔═╡ 9282eca0-08db-11eb-2e36-d761594b427c
T = 100 # massimo valore di $t$

# ╔═╡ fe0aa72c-8b46-11eb-15aa-49ae570e5858
md"""
 $N =$ $(@bind N Slider(1:1000, show_value=true, default=70))

 $p_r =$ $(@bind pᵣ Slider(0:0.01:.1, show_value=true, default=0.05))

 $t =$ $(@bind t Slider(1:T, show_value=true, default=1))
"""

# ╔═╡ caa3faa2-08e5-11eb-33fe-cbbc00cfd459
md"""
### Evoluzione temporale della media

Negli esempi precedenti abbiamo visto come la media sembri comportarsi in modo assai più deterministico nel tempo. Osserviamo che _in media_ il numero di lampadine ancora funzionanti $N_t$ si comporta come segue:

$${\color{lightgreen} N_{t+1}} - {\color{lightgreen}N_t} = -{\color{red} p \, N_t}$$

ovvero

$$N_{t+1} = (1 - p) N_t ,$$

che dunque _srotolando la riccorrenza_ ci dà

$$N_t = (1-p)^t \, N_0.$$
"""

# ╔═╡ 113c31b2-08ed-11eb-35ef-6b4726128eff
md"""
Confrontiamo la stima teorica coi risultati numerici: 
"""

# ╔═╡ 6a545268-0846-11eb-3861-c3d5f52c061b
exact = [N * (1-pᵣ)^t for t in 0:T]

# ╔═╡ 3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
md"""
Le due curve tendono a coincidere per $N$ (numero di individui nel sistema) via via più grandi.
"""

# ╔═╡ f32b936a-8bf6-11eb-1dd7-fd8c5904bf1f
md"""
## Distribuzione binomiale

Sia $N_0$ il numero di lampadine al tempo $0$. 
Quante di esse saranno guaste al tempo $1$? 
Chiamiamo quest'ultima quantità $\Delta N_0$. 
Possiamo stimare che mediamente $\mathbb E[\Delta N_0] = pN_0$ (un'altra notazione usata in fisica per il valor medio $\mathbb E[\Delta N_0]$ è $\langle \Delta N_0 \rangle$). Tuttavia il valore effettivo di $\Delta N_0$ potrebbe discostarsi di molto da $pN_0$. Per esempio, potrebbe anche accadere che tutte le lampadine si guastino al primo passo, seppure si tratta di un evento molto improbabile:
"""

# ╔═╡ d5be7579-dc01-474d-911d-635fa6a89860
let 
	p = 0.05
	N = 10
	p^N # probabilità che tutte le `N` variabili `Bernoulli(p)` siano 1.
end

# ╔═╡ ec485765-8dd6-4d1d-802b-f14b1879e0df
md"""
La distribuzione del numero di lampadine che falliscono al primo passo può essere espressa con la sommatoria

$\Delta N_0 = \sum_{i=1}^{N_0} B_0^i$

dove $B_0^i$ è 1 se e solo se l'$i$-esima lampadine si guasta tra l'istante $0$ e l'istante $1$. La distribuzione precedente, definita unicamente dai parametri $p$ (probabilità di successo o fallimento) e $N$ (numero di tentativi), è detta [binomiale](https://it.wikipedia.org/wiki/Distribuzione_binomiale), e di seguito la implementeremo come un nuovo tipo: 
"""

# ╔═╡ 48fb6ed6-8cb1-11eb-0894-b526e6c43b01
struct Binomial
	N::Int64
	p::Float64
end

# ╔═╡ 713a2644-8cb1-11eb-1904-f301e39d141e
md"""
Notare che, a differenza di altri linguaggi, in Julia non è necessario fornire tale struttura di metodi, che possono essere aggiunti successivamente, anche da altri utenti che caricano il nostro codice come libreria, e che possono dunque estenderlo senza modificare la libreria originale. 
"""

# ╔═╡ 511892e0-8cb1-11eb-3814-b98e8e0bbe5c
Base.rand(X::Binomial) = sum(rand(Bernoulli(X.p)) for i in 1:X.N)

# ╔═╡ 178631ec-8cac-11eb-1117-5d872ba7f66e
function simulate(N, p)
	v = fill(0, N, N)
	t = 0 
	
	while any( v .== 0 ) && t < 100
		t += 1
		for i= 1:N, j=1:N
			if rand() < p && v[i,j]==0
				v[i,j] = t
			end					    
		end
	end
	
	return v
end

# ╔═╡ 17bbf532-8cac-11eb-1e3f-c54072021208
simulation = simulate(M, prob)

# ╔═╡ 17e0d142-8cac-11eb-2d6a-fdf175f5d419
begin
	w = .9
	h = .9
	c = [:lightgreen, :red, :purple][1 .+ (simulation .<  (tₛ .- 1)) .+ (simulation .< tₛ)] 
	
	plot(ratio=1, legend=false, axis=false, ticks=false)
	for i=1:M, j=1:M
		plot!(rectangle(w, h, i, j), c=:black, fill=true, alpha=0.5)
		plot!(circle(0.3, i+0.45, j+0.45), c = c[i, j], fill=true, alpha=0.5)
	end
	for i=1:M, j=1:M
		if simulation[i,j] < tₛ
	       annotate!(i+0.45, j+0.5, text("$(simulation[i, j])", 7, :white))
		end
	end
    
	plot!(lims=(0.5, M+1.1), title="time = $(tₛ-1);  failed count: $(sum(simulation.<tₛ))")
end

# ╔═╡ 17fe87a0-8cac-11eb-2938-2d9cd19ecc0f
begin
	plot(size=(500, 300))
	cdf= [ count(simulation .≤ i) for i=0:100] 
	bar!(cdf, c=:purple, legend=false, xlim=(0, tₛ),alpha=0.8)
end

# ╔═╡ 1829091c-8cac-11eb-1b77-c5ed7dd1261b
begin
	newcdf = [ count(simulation .> i) for i=0:100] 
	bar!( newcdf, c=:lightgreen, legend=false, xlim=(0, tₛ), alpha=0.8)
end

# ╔═╡ 1851dd6a-8cac-11eb-18e4-87dbe1714be0
bar(countmap(simulation[:]), c=:red, legend=false, xlim=(0, tₛ+.5), size=(500, 300))

# ╔═╡ ba7ffe78-0845-11eb-2847-851a407dd2ec
bernoulli(p) = Int(rand() < p)

# ╔═╡ b6786ec8-8bf3-11eb-1347-61f231fd3b4c
flips = [Int(bernoulli(0.25)) for i in 1:100]

# ╔═╡ 0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
mean(flips)

# ╔═╡ 093275e4-8cc8-11eb-136f-3ffe522c4125
var(flips)

# ╔═╡ e2d764d0-0845-11eb-0031-e74d2f5acaf9
function step!(infectious, p)
	for i in 1:length(infectious)
		if infectious[i] && Bool(bernoulli(p))
			infectious[i] = false
		end
	end
	return infectious
end

# ╔═╡ 58d8542c-08db-11eb-193a-398ce01b8635
begin
	infected = trues(N)
	results = [copy(infected)]
	for i in 2:T
		nextstep = copy(step!(infected, pᵣ)) 
		push!(results, nextstep)
	end
	results
end

# ╔═╡ cb6ca4af-76f1-4795-bf94-607bb042711f
results[1:3]

# ╔═╡ 33f9fc36-0846-11eb-18c2-77f92fca3176
function simulate_failure(p, T)
	alive = trues(N)
	num_alive = [N]
	
	for t in 1:T
		step!(alive, p)
		push!(num_alive, count(alive))
	end
	
	return num_alive
end

# ╔═╡ cb278624-08dd-11eb-3375-276bfe8d7b3a
begin
	p = 0.05
	plot(simulate_failure(pᵣ, T), label="Run 1", alpha=0.5, lw=2, m=:o)
	plot!(simulate_failure(pᵣ, T), label="Run 2", alpha=0.5, lw=2, m=:o)
	plot!(simulate_failure(pᵣ, T), label="Run 3", alpha=0.5, lw=2, m=:o)
	
	xlabel!("Tempo t")
	ylabel!("Numero di lampadine funzionanti")
end

# ╔═╡ f3c85814-0846-11eb-1266-63f31f351a51
all_data = [simulate_failure(pᵣ, T) for i in 1:30];

# ╔═╡ 01dbe272-0847-11eb-1331-4360a575ff14
begin
	plot(all_data, alpha=0.1, leg=false, 
		m=:o, ms=1, size=(500, 400), label="")
	xlabel!("Tempo t")
	ylabel!("Numero di lampadine funzionanti")
end

# ╔═╡ be8e4ac2-08dd-11eb-2f72-a9da5a750d32
plot!(mean(all_data), leg=true, label="Media", 
	lw=3, c=:red, m=:o, alpha=0.5, size=(500, 400))

# ╔═╡ 8bc52d58-0848-11eb-3487-ef0d06061042
begin
	plot(replace.(all_data, 0.0 => NaN), yscale=:log10, 
		alpha=0.3, leg=false, m=:o, ms=1, size=(500, 400))
	plot!(mean(all_data), yscale=:log10, 
		lw=3, c=:red, m=:o, label="mean", alpha=0.5)
	
	xlabel!("Tempo t")
	ylabel!("Numero di lampadine funzionanti")
end

# ╔═╡ 4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
begin
	plot(mean(all_data), m=:o, alpha=0.5, label="Media delle simulazioni",
		size=(500, 400))
	plot!(exact, lw=3, alpha=0.8, label="Modello deterministico", leg=:right)
	title!("Teoria vs simulazione")
	xlabel!("Tempo")
	ylabel!("Numero di \"sopravvissuti\"")
end
	

# ╔═╡ 3a1ed6b3-4217-4198-a2f3-a98e0fb6af14
[rand(B) for i in 1:20]

# ╔═╡ 1173ebbe-8cb1-11eb-0a21-7d40a2c8a855
rand(Binomial(10, 0.25))

# ╔═╡ dfdaf1dc-8cb1-11eb-0287-f150380d323b
md"""
 $N =$ $(@bind binomial_N Slider(1:100, show_value=true, default=10))

 $p =$ $(@bind binomial_p Slider(0.0:0.01:1, show_value=true, default=0.25))
"""

# ╔═╡ ca3db0a8-8cb1-11eb-2f7b-c9343a29ed02
begin
	experiment() = rand(Binomial(binomial_N, binomial_p))
	binomial_data = [experiment() for i in 1:10000]
	histogram(binomial_data, alpha=0.5, size=(500, 300), leg=false, bar_width=.9)
end

# ╔═╡ 2d85b8f8-7cb5-4fb3-ab6b-51b7c5a6ea0b
md"""
#### Domanda - Istogrammi

Come possiamo alternativamente disegnare un istogramma utilizzando le funzioni `bar` e `countmap`?
"""

# ╔═╡ 2f980870-0848-11eb-3edb-0d4cd1ed5b3d
md"""
## Tempo continuo

Possiamo immaginare che nelle simulazioni precedentemente considerate le _unità di tempo_ rappresentino diversi giorni. 
Sotto tale ipotesi, potrebbe adesso interessarci studiare il processo ad un livello più _fine_ di _granularità_. 
Supponiamo, dunque, di osservare il tempo a passi di tempo di ampiezza $\delta t$. 
Se invece di osservare il processo ogni giorno, lo osserviamo ogni ora, abbiamo che anche la probabilità degli avvenimenti che ci interessano (per es. il rompersi di una lampadina), va conseguentemente adattata. 
In particolare, si può dimostrare che la probabilità $p_{\delta t}$ di un avvenimento in un unità di tempo $\delta t$, quando quest'ultima è sufficientemente piccola, è proporzionale ad essa: 

$p_{\delta t} \simeq  \lambda {\delta t}$

per una opportuna costante $\lambda$, che prende il nome di **rate**. 
Se indichiamo con $I(t)$ il valore del processo al tempo $t$ (per es. le lampadine ancora funzionanti), allora

$$I(t + \delta t) - I(t) \simeq -\lambda \,\delta t \, I(t), $$

ovvero 

$$\frac{I(t + \delta t) - I(t)}{\delta t} \simeq -\lambda \, I(t),$$

in cui possiamo riconoscere la definizione di derivata. 
Considerando $\delta t \rightarrow 0$, sotto opportune ipotesi di _differenziabilità_ del processo, avremo allora l'[equazione differenziale ordinaria](https://it.wikipedia.org/wiki/Equazione_differenziale_ordinaria)

$$\frac{dI(t)}{dt} = -\lambda \, I(t)$$

Supponendo che inizialmente $I(0) = I_0$, possiamo verificare che la seguente equazione è una soluzione del problema definito dall'equazione: 

$$I(t) = I_0 \exp(-\lambda \, t).$$

Si può alternativamente arrivare all'equazione precedente ragionando sulla ricorrenza $I_{t} = (1 - \lambda \, \delta t)^{(t / \delta t)} I_0$ che rappresenta una versione _arbitrariamente fine_ della ricorrenza $N_t = (1-p)^t N_0$ vista in precedenza. 
"""

# ╔═╡ 8d2858a4-8c38-11eb-0b3b-61a913eed928
md"""
### Dal discreto al continuo

Confrontiamo le distribuzioni che otteniamo per diversi time step $\delta t$: 
"""

# ╔═╡ 93da8b36-8c38-11eb-122a-85314d6e1921
function plot_cumulative!(p, N, δ=1; kw...)
    ps = [p * (1 - p)^(n-1) for n in 1:N]
    cumulative = cumsum(ps) # somme cumulative
    scatter!([n*δ for n in 1:N], cumulative; kw...)
end

# ╔═╡ f1f0529a-8c39-11eb-372b-95d591a573e2
plotly()

# ╔═╡ 9572eda8-8c38-11eb-258c-739b511de833
begin
	plot(size=(500, 300))
	for i in 0:2
		plot_cumulative!(0.1/2^i, 2^i*30, 1/2^i, alpha=.3, ms=8/2^i, label="δt=$(1/2^i)")
	end
	plot!()
end

# ╔═╡ 9f41d4f2-8c38-11eb-3eae-a1ec0d86d64c
begin
	λ = -log(1 - 0.1)
	plot!(0:0.01:30, t -> 1 - exp(-λ*t), lw=2, label="δt→0")
end

# ╔═╡ 1336397c-8c3c-11eb-2ecf-eb017a3a65cd
md"""
Qual'è la corretta interpretazione del parametro di rate $\lambda$?
"""

# ╔═╡ d74bace6-08f4-11eb-2a6b-891e52952f57
md"""
## Il modello SIR
"""

# ╔═╡ dbdf2812-08f4-11eb-25e7-811522b24627
md"""
Applicheremo ora quanto visto a un modello di base dell'epidemiologia, il [modello SIR](https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model_without_vital_dynamics), acronimo di _susceptible-infected-recovered_, in formula $S \to I \to R$.
In tale modello, gli individui _suscettibili_ $S_t$ sono coloro che non si sono finora ammalati e potrebbero dunque ammalarsi, gli individui _infettati_ $I_t$ sono coloro che sono ammalati e potrebbero guarire, e gli individui _ripresi_ $R_t$ sono coloro che sono guariti e sono oramai immuni alla malattia. 

Dal precedente esempio sulle lampadine, sappiamo come modellare il numero di persone che guariscono quando abbiamo $I_t$ infettati, ciascuno che potrebbe guarire con una certa probabilità $c$ ad ogni passo del processo. 

Ci concentriamo pertanto su come modellare le variabili $S_t$ e $I_t$. 
Sia $N$ il numero totale di individui, ovvero $N=S_t+I_t+R_t$. 
Supponiamo che ogni individuo può contrarre la malattia con probabilità $b$ da un altro individuo scelto uniformemente a caso dall'intera popolazione di $N$ persone, se quest'ultimo è infetto:

$\Delta I_t = I_{t+1}-I_t = b \cdot I_t\Big(\frac {S_t}{N}\Big).$
"""

# ╔═╡ d6cf9e1a-39d6-4ccb-9b20-eb0cfbe09785
md"""
### Modello discreto

Definiamo le variabili _normalizzate_ $s_t = S_t/N$, $i_t = I_t/N$ e $r_t = R_t/N$. 

#### Esercizio - Modello SIR

Dimostrare che, se ogni individuo può contrarre la malattia da un altro individuo scelto a caso nella popolazione, allora le equazioni che definiscono il modello a tempo discreto sono 

$$\begin{align}
s_{t+1} &= s_t - b \, s_t \, i_t ,\\
i_{t+1} &= i_t + b \, s_t \, i_t - c \, i_t ,\\
r_{t+1} &= r_t + c \, i_t.
\end{align}$$
"""

# ╔═╡ 4e3c7e62-090d-11eb-3d16-e921405a6b16
md"""
### Modello continuo

Come fatto precedentemente, immaginiamo di osservare il processo ad una risoluzione temporale via via più fine, con step di ampiezza $\delta t$, considerando $\delta t \to 0$. Allora, per opportuni rate $\beta$ e $\gamma, abbiamo il modello a tempo continuo

$$\begin{align}
\textstyle \frac{ds(t)}{dt} &= -\beta \, s(t) \, i(t) ,\\
\textstyle \frac{di(t)}{dt} &= \beta \, s(t) \, i(t) - \gamma \, i(t),\\
\textstyle \frac{dr(t)}{dt} &=  \gamma \, i(t).
\end{align}$$

Di seguito implementiamo una simulazione del modello a tempo discreto. Notare che il metodo numerico più semplice per risolvere (approssimativamente) il sistema ODE (ordinary differential equations), vale a dire il [metodo di Eulero](https://it.wikipedia.org/wiki/Metodo_di_Eulero), si riduce fondamentalmente a risolvere il modello a tempo discreto. Un'intera suite di risolutori di ODE più avanzati è fornita dall'ecosistema [Julia `DiffEq`](https://diffeq.sciml.ai/dev/).
"""

# ╔═╡ d994e972-090d-11eb-1b77-6d5ddb5daeab
begin
	NN = 100
	SS = NN - 1
	II = 1
	RR = 0
end

# ╔═╡ 349eb1b6-0915-11eb-36e3-1b9459c38a95
function discrete_SIR(SS, II, RR; p_infection=0.1, p_recovery=0.01, T=1000)
	# create initial state by normalizing initial counts
	s, i, r = SS/NN, II/NN, RR/NN
	results = [(s=s, i=i, r=r)]
	
	for t in 1:T
		Δi = p_infection * s * i
		Δr = p_recovery * i
		
		s_new = s - Δi
		i_new = i + Δi - Δr
		r_new = r      + Δr

		push!(results, (s=s_new, i=i_new, r=r_new))
		s, i, r = s_new, i_new, r_new
	end
	
	return results
end

# ╔═╡ 39c24ef0-0915-11eb-1a0e-c56f7dd01235
SIR = discrete_SIR(SS, II, RR, p_infection=0.1, p_recovery=0.01, T=1000)

# ╔═╡ 442035a6-0915-11eb-21de-e11cf950f230
begin
	ts = 1:length(SIR)
	discrete_time_SIR_plot = plot(ts, [x.s for x in SIR], 
		m=:o, label="S", alpha=0.2, linecolor=:blue, leg=:right, size=(400, 300))
	plot!(ts, [x.i for x in SIR], m=:o, label="I", alpha=0.2)
	plot!(ts, [x.r for x in SIR], m=:o, label="R", alpha=0.2)
	xlims!(0, 500)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
StatsBase = "~0.33.10"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

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

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ef49a187604f865f4708c90e3f431890724e9012"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.59.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

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

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "2537ed3c0ed5e03896927187f5f2ee6a4ab342db"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.14"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "2dbafeadadcf7dadff20cd60046bba416b4912be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.21.3"

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

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "d4491becdc53580c6dadb0f6249f90caae888554"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

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

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "f41020e84127781af49fc12b7e92becd7f5dd0ba"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "1162ce4a6c4b7e31e0e6b14486a6986951c73be9"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.2"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─2c343416-2b20-4aa1-ac7b-2fada1606a38
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╟─fb6cdc08-8b44-11eb-09f5-43c167aa53fd
# ╟─f3aad4f0-8cc2-11eb-1a25-535297327c65
# ╟─d2c19564-8b44-11eb-1077-ddf6d1395b59
# ╟─dd5d1601-b8b0-46bd-864f-863f302d0548
# ╟─50689c9e-b9a7-4e20-875a-77ae9e6da5b0
# ╟─4ca399f4-8b45-11eb-2d2b-8189e04fc804
# ╟─34895756-6c21-497f-a603-1aaa07eb9097
# ╟─43745d01-7906-4722-a427-244b7465ca4a
# ╟─17812c7c-8cac-11eb-1d0a-6512415f6938
# ╠═178631ec-8cac-11eb-1117-5d872ba7f66e
# ╟─179a4db2-8cac-11eb-374f-0f24dc81ebeb
# ╟─17cf895a-8cac-11eb-017e-c79ffcab60b1
# ╠═17bbf532-8cac-11eb-1e3f-c54072021208
# ╠═a38fe2b2-8cae-11eb-19e8-d563e82855d3
# ╠═17e0d142-8cac-11eb-2d6a-fdf175f5d419
# ╠═18da7920-8cac-11eb-07f4-e109298fd5f1
# ╠═17fe87a0-8cac-11eb-2938-2d9cd19ecc0f
# ╠═1829091c-8cac-11eb-1b77-c5ed7dd1261b
# ╠═1851dd6a-8cac-11eb-18e4-87dbe1714be0
# ╟─a9447530-8cb6-11eb-38f7-ff69a640e3c4
# ╠═18755e3e-8cac-11eb-37bf-1dfa5fbe730a
# ╟─f947a976-8cb6-11eb-2ae7-59eba4c6f40f
# ╠═5a0b407e-8cb7-11eb-0c0d-c7767a6b0a1d
# ╠═fe53ee0c-8cb6-11eb-19bc-2976da1abe16
# ╠═1894b388-8cac-11eb-2287-97f985df1fbd
# ╟─88dd73cc-33ae-4151-bbe3-e14d9895f0b3
# ╠═86299112-8cc6-11eb-257a-9d803feac359
# ╠═b8d01ae4-8cc6-11eb-1d16-47095532f738
# ╠═c5bc97aa-8cc6-11eb-3564-fd96184ff2c3
# ╠═e1769d6d-9896-4054-ad3b-52f7751711e2
# ╠═d5cffd96-8cc6-11eb-2714-975d46d4fa27
# ╠═fc715452-8cc6-11eb-0246-e941f7698cfe
# ╟─71fbc75e-8bf3-11eb-3ac9-dd5401033c78
# ╠═ba7ffe78-0845-11eb-2847-851a407dd2ec
# ╟─dcd279b0-8bf3-11eb-0cb9-95f351626ed1
# ╠═b6786ec8-8bf3-11eb-1347-61f231fd3b4c
# ╟─ac98f5da-8bf3-11eb-076f-597ce4455e76
# ╠═0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
# ╠═093275e4-8cc8-11eb-136f-3ffe522c4125
# ╟─4edaec4a-8bf4-11eb-3094-010ebe9b56ab
# ╠═8405e310-8bf8-11eb-282b-d93b4fc683aa
# ╟─af2594c4-8cad-11eb-0fff-f59e65102b3f
# ╠═8aa60da0-8bf8-11eb-0fa2-11aeecb89564
# ╠═2d9c560e-8bf9-11eb-1ac5-f77f7caf776f
# ╟─8d56b6d2-8cc8-11eb-0dbd-b3533dde4aa3
# ╠═a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
# ╠═3a1ed6b3-4217-4198-a2f3-a98e0fb6af14
# ╠═ce94541c-8bf9-11eb-1ac9-51e66a017813
# ╟─fa2a4404-fea7-41b2-bc26-3983f1d4bbd3
# ╠═c166edb6-8cc8-11eb-0436-f74164ff6ea7
# ╟─3ef23da4-8cb4-11eb-0d5f-d5ee8fc56227
# ╟─a057e7ee-8bf9-11eb-2ceb-2dda3718a70a
# ╟─ec5faae8-5ddc-42a2-993b-0fcc41b47012
# ╠═e2d764d0-0845-11eb-0031-e74d2f5acaf9
# ╠═9282eca0-08db-11eb-2e36-d761594b427c
# ╟─fe0aa72c-8b46-11eb-15aa-49ae570e5858
# ╠═58d8542c-08db-11eb-193a-398ce01b8635
# ╠═cb6ca4af-76f1-4795-bf94-607bb042711f
# ╠═33f9fc36-0846-11eb-18c2-77f92fca3176
# ╠═cb278624-08dd-11eb-3375-276bfe8d7b3a
# ╠═f3c85814-0846-11eb-1266-63f31f351a51
# ╠═01dbe272-0847-11eb-1331-4360a575ff14
# ╠═be8e4ac2-08dd-11eb-2f72-a9da5a750d32
# ╠═8bc52d58-0848-11eb-3487-ef0d06061042
# ╟─caa3faa2-08e5-11eb-33fe-cbbc00cfd459
# ╟─113c31b2-08ed-11eb-35ef-6b4726128eff
# ╠═6a545268-0846-11eb-3861-c3d5f52c061b
# ╠═4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
# ╟─3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
# ╟─f32b936a-8bf6-11eb-1dd7-fd8c5904bf1f
# ╠═d5be7579-dc01-474d-911d-635fa6a89860
# ╟─ec485765-8dd6-4d1d-802b-f14b1879e0df
# ╠═48fb6ed6-8cb1-11eb-0894-b526e6c43b01
# ╟─713a2644-8cb1-11eb-1904-f301e39d141e
# ╠═511892e0-8cb1-11eb-3814-b98e8e0bbe5c
# ╠═1173ebbe-8cb1-11eb-0a21-7d40a2c8a855
# ╟─dfdaf1dc-8cb1-11eb-0287-f150380d323b
# ╠═ca3db0a8-8cb1-11eb-2f7b-c9343a29ed02
# ╟─2d85b8f8-7cb5-4fb3-ab6b-51b7c5a6ea0b
# ╟─2f980870-0848-11eb-3edb-0d4cd1ed5b3d
# ╟─8d2858a4-8c38-11eb-0b3b-61a913eed928
# ╠═93da8b36-8c38-11eb-122a-85314d6e1921
# ╠═f1f0529a-8c39-11eb-372b-95d591a573e2
# ╠═9572eda8-8c38-11eb-258c-739b511de833
# ╠═9f41d4f2-8c38-11eb-3eae-a1ec0d86d64c
# ╟─1336397c-8c3c-11eb-2ecf-eb017a3a65cd
# ╟─d74bace6-08f4-11eb-2a6b-891e52952f57
# ╟─dbdf2812-08f4-11eb-25e7-811522b24627
# ╟─d6cf9e1a-39d6-4ccb-9b20-eb0cfbe09785
# ╟─4e3c7e62-090d-11eb-3d16-e921405a6b16
# ╠═349eb1b6-0915-11eb-36e3-1b9459c38a95
# ╠═d994e972-090d-11eb-1b77-6d5ddb5daeab
# ╠═39c24ef0-0915-11eb-1a0e-c56f7dd01235
# ╠═442035a6-0915-11eb-21de-e11cf950f230
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
