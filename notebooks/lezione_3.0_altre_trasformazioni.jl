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

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	using PlutoUI 
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using Plots, LaTeXStrings
	using PlutoUI
	using LinearAlgebra
	using ForwardDiff
	using NonlinearSolve
	using StaticArrays
end

# ╔═╡ 972b2230-7634-11eb-028d-df7fc722ec70
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it-2022/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)

Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it-2022), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ b7895bd2-7634-11eb-211e-ef876d23bd88
PlutoUI.TableOfContents(aside=true)

# ╔═╡ d664f0f0-0c86-43e8-9f79-f285eb32bdd6
begin
	armadillo_url = "https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/armadillo_zerocalcare.png"
	personaggi_url = "https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/zerocalcare_characters.png"
	zero_url = "https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/zerocalcare_miniature.png"
end

# ╔═╡ c74b5fe6-167b-4dd3-93f1-fc25bc609931
md"""
Scegliamo "a mano" l'immagine che utilizzeremo di seguito:
"""

# ╔═╡ 96766502-7a06-11eb-00cc-29849773dbcf
# img_original = load(download(armadillo_url));
img_original = load(download(personaggi_url));
# img_original = load(download(zero_url));

# ╔═╡ e0b657ce-7a03-11eb-1f9d-f32168cb5394
md"""
# Ancora trasformazioni

Continuimo a prendre dimestichezza con Julia e con vari tipi di trasformazioni giocando con delle immagini. Mentre il fatto in sé di manipolare delle immagini non è il nostro primo interesse, tale possibilità ci offre un modo di esplorare varie idee matematiche in modo visivo e sperabilmente più leggero.
"""

# ╔═╡ 005ca75a-7622-11eb-2ba4-9f450e71df1f
let range = -1.5:.1:1.5
md"""
	
Ridefiniamo una matrice _scrubbable_ come fatto nella lezione precedente: 
	
 $A =$

``(``	
 $(@bind a Scrubbable( range; default=1.0))
 $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
$(@bind c Scrubbable(range; default=0.0 ))
$(@bind d Scrubbable(range; default=1.0)) 
``)``  
"""
end

# ╔═╡ 85686412-7a75-11eb-3d83-9f2f8a3c5509
A = [a b ; c d]

# ╔═╡ 0f742343-f41f-4de3-9b08-a95fef040623
md"""
Selezionimao inoltre una trasformazione $T^{-1}$:|
"""

# ╔═╡ 313a1972-7106-46ca-9fdd-1e004b63b8e4
md"""
Visualizziamo l'immagine con cui lavoreremo, usando varie funzioni che definiremo in seguito: 
"""

# ╔═╡ b52f4faa-ecc1-492b-b720-43b1c3623f9d
md"""
Di seguito settiamo in modo interattivo i parametri utilizzati da alcune delle trasformazioni precedenti, e varie altre proprietà dell'immagine visualizzata: 
"""

# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
md"""
##### Parametri della trasformazione

α = $(@bind α Slider(-30:.1:30, show_value=true, default=0))

β = $(@bind β Slider(-10:.1:10, show_value=true, default = 5))

h = $(@bind h Slider(.1:.1:10, show_value=true, default = 5))
"""

# ╔═╡ bc696d68-9841-4a44-8448-c351ae7847ef
md"""
##### Parametri della visualizzazione
"""

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
md"""
zoom = $(@bind  z Scrubbable(.1:.1:3,  default=1))
"""

# ╔═╡ 7f28ac40-7914-11eb-1403-b7bec34aeb94
md"""
traslazione = [$(@bind panx Scrubbable(-1:.1:1, default=0)), 
$(@bind pany Scrubbable(-1:.1:1, default=0)) ]
"""

# ╔═╡ 5d33f6ea-7e9c-11eb-2fb3-dbb7cb07c60c
md"""
risoluzione = $(@bind pixels Slider(1:1000, default=800, show_value=true))
"""

# ╔═╡ 45dccdec-7912-11eb-01b4-a97e30344f39
md"""
mostra la griglia: $(@bind show_grid CheckBox(default=true))

finezza della griglia: $(@bind ngrid Slider(5:5:20, show_value=true, default = 10))
"""

# ╔═╡ d2fb356e-7f32-11eb-177d-4f47d6c9e59b
md"""
Cornice circolare $(@bind circular CheckBox(default=true))

Raggio: $(@bind r Slider(.1:.1:1, show_value=true, default = 1))
"""

# ╔═╡ 55b5fc92-7a76-11eb-3fba-854c65eb87f9
md"""
L'immagine originale è collocata in un riquadro con coordinate [-1,1]x[-1 1], e poi trasformata.
"""

# ╔═╡ 78d61e28-79f9-11eb-0605-e77d206cda84
md"""
### Domanda sulle trasformazioni lineari

Il fatto che una trasformazione mappi rette in rette e preservi l'origine, costituisce una condizione sufficiente affinché sia lineare?
"""

# ╔═╡ d9115c1a-7aa0-11eb-38e4-d977c5a6b75b
md"""
#### Mini-progetto

Scrivere un notebook che implementa una visualizzazione prospettica su modello di quella fornita [in questa lezione di Khan Academy](https://www.khanacademy.org/humanities/renaissance-reformation/early-renaissance1/beginners-renaissance-florence/a/linear-perspective-interactive). 
"""

# ╔═╡ e965cf5e-79fd-11eb-201d-695b54d08e54
md"""
### Julia style: definire funzioni vettoriali
"""

# ╔═╡ 1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
md"""
Codice scritto nel modo seguente può risultare di difficile lettura: 
```
f(v) = [ v[1]+v[2] , v[1]-v[2] ]
``` 
oppure (ancora peggio)
```
f = v ->  [ v[1]+v[2] , v[1]-v[2] ]  
```
Come abbiamo accennato mostrando l'uso di tuple anziché array come argomenti di una funzione, il modo di screvere che segue dovrebbe risultare più chiaro
```
f((x,y)) = [ x+y , x-y ] 
``` 
oppure (ma un po' peggio)
```
f = ((x,y),) -> [ x+y , x-y ]
```

In ogni caso, notiamo che i quattro modi di scrivere precedenti sono equivalenti ed implementano ciascuno la stessa funzione $f:\mathbb R^2 \rightarrow \mathbb R^2$.
"""

# ╔═╡ 28ef451c-7aa1-11eb-340c-ab3a1193a3c4
md"""
### Funzioni parametriche

Il sintassi per scrivere funzioni in forma _anonima_ risulta utile quando si vuole far dipendere la funzione da un **parametro**, consideriamo per esempio

`f(α) = ((x,y),) -> [x + αy, x - αy]`

La scrittura precedente permette di esprimere espressioni come `[x + 7y, x - 7y]` scrivendo `f(7)([x, y])`, per esempio se $x=1$ e $y=2$ possiamo scrivere
`f(7)([1, 2])` .
"""

# ╔═╡ a0afe3ae-76b9-11eb-2301-cde7260ddd7f
md"""
## Ancora trasformazioni lineari
"""

# ╔═╡ fc2deb7c-7aa1-11eb-019f-d3e3c80b9ff1
md"""
Rivediamo di seguito qualche famosa trasformazione lineare:
"""

# ╔═╡ d364f91a-76b9-11eb-1807-75e733940d53
begin
	 id((x, y)) = SA[x, y] # identità
	
	 scalex(α) = ((x, y),) -> SA[α*x,   y] # scaling di $x$
	 scaley(α) = ((x, y),) -> SA[x,   α*y] # scaling di $y$
	 scale(α)  = ((x, y),) -> SA[α*x, α*y] # scaling di $x$ e $y$
	
	 swap((x, y))  = SA[y, x]  # simmetria diagonale
	 flipy((x, y)) = SA[x, -y] # simmetria verticale
	
	 rotate₂(θ) = ((x, y),) -> SA[cos(θ)*x + sin(θ)*y, 
		 					    -sin(θ)*x + cos(θ)*y] # rotazione
	 shear(α)  = ((x, y),) -> SA[x + α*y, y] # inclinazione
end

# ╔═╡ 58a30e54-7a08-11eb-1c57-dfef0000255f
# T⁻¹ = id
# T⁻¹ = rotate₂(α)
T⁻¹ = shear(α)
# T⁻¹ = lin(A) # uses the scrubbable 
# T⁻¹ = shear(α) ∘ shear(-α)
# T⁻¹ = nonlin_shear(α)  
# T⁻¹ = inverse(nonlin_shear(α))
# T⁻¹ = nonlin_shear(-α)
# T⁻¹ = xy 
# T⁻¹ = warp(α)
# T⁻¹ = ((x,y),)-> (x+α*y^2,y+α*x^2) # potrebbe essere non-invertibile
# T⁻¹ = ((x,y),)-> (x,y^2)  
# T⁻¹  = flipy ∘ ((x,y),) ->  ( (β*x - α*y)/(β-y), -h*y/(β-y) ) 

# ╔═╡ 080d87e0-7aa2-11eb-18f5-2fb6a7a5bcb4
md"""
E ricordiamo l'espressione di una trasformazione lineare generale da $\mathbb R^2$ a $\mathbb R^2$: 
"""

# ╔═╡ 15283aba-7aa2-11eb-389c-e9f215bd03e2
begin
	lin(a, b, c, d) = ((x, y),) -> (a*x + b*y, c*x + d*y)
	
	lin(A) = v -> A * [v...]  # una versione dell'espressione precedente che fa uso del fatto che Julia supporta l'algebra lineare _out of the box_. 
end

# ╔═╡ 2612d2c2-7aa2-11eb-085a-1f27b6174995
md"""
Notare che `lin(A)` definita sopra è equivalente a `lin(a, b, c, d)` quando 

$$A = \begin{bmatrix} a & b \\ c & d \end{bmatrix}.$$
"""

# ╔═╡ a290d5e2-7a02-11eb-37db-41bf86b1f3b3
md"""
## Alcune trasformazioni non-lineari
"""

# ╔═╡ b4cdd412-7a02-11eb-149a-df1888a0f465
begin
	# traslazione: una trasformazione non-lineare ma **affine**
	translate₂(α,β)  = ((x, y),) -> SA[x+α, y+β]   
	# inclinazione non-lineare
	nonlin_shear(α) = ((x, y),) -> SA[x, y + α*x^2] 
end

# ╔═╡ 903ac4a8-b1f8-4858-a532-18c3ebb5b2d8
# il `warp` visto in precedenza
warp(α) = ((x, y),) -> rotate₂(α*√(x^2+y^2))(SA[x, y]) 

# ╔═╡ 17a6f4e2-2d0f-4b49-a99e-4f9c17d5ffea
md"""
Di seguito ricordiamo le trasformazioni polari viste in precedenza: 
"""

# ╔═╡ 425c9c7c-bee0-4729-ad98-ce311ed03092
begin
	# da coordinate polari a cartesiane
	xy((r, θ)) = SA[ r*cos(θ), r*sin(θ) ]  
	# da coordinate cartesiane a polari
	rθ(x)      = SA[ norm(x), atan(x[2],x[1]) ] 
end

# ╔═╡ cab5d8c1-46a6-4bdf-b23b-2325858713b3
md"""
La trasformazione da cartesiane a polari fa uso della funzione `atan` che abbiamo precedentemente usato a scatola chiusa (_black box_); possiamo visualizzarne il grafico per cercare di svilupparne una compresione intuitiva: 
"""

# ╔═╡ df873cce-fdaf-485c-9236-55badeb73d82
plotly; # usa il backend `plotly` per i grafici

# ╔═╡ 9730776a-c2ad-44a6-af2d-3feb6cb91060
begin
	x = y = -1:.01:1
	heatmap(x, y, (x, y) -> atan(x, y))
end

# ╔═╡ 5de5f6d9-f957-4901-bcf3-32313cf84106
begin
	# alcune trasformazioni ancora più avanzate, per chi vuole sperimentare
	# exponentialish =  ((x,y),) -> [log(x+1.2), log(y+1.2)]
	# reim(log(complex(y,x)))
	# merc = ((x,y),) ->  [ log(x^2+y^2)/2 , atan(y,x) ] 
end

# ╔═╡ 704a87ec-7a1e-11eb-3964-e102357a4d1f
md"""
### Composizione di trasformazioni
"""

# ╔═╡ b93f47fd-9900-49bc-9d14-96d9344f28fc
md"""
Possiamo [comporre funzioni](https://en.wikipedia.org/wiki/Function_composition) usando la notazione matematica con l'operatore `\circ` (seguito dal tasto `Tab`): $f \circ g\ (x)$ è equivalente a $f(g(x))$. Verifichiamo con un esempio:
"""

# ╔═╡ 4b0e8742-7a70-11eb-1e78-813f6ad005f4
( sin ∘ cos )(.42) ≈ sin(cos(.42))

# ╔═╡ 36f00e34-dfa2-4057-8f87-271991d7e64d
md"""
Notare che, nonostante `( sin ∘ cos )(x) ≈ sin(cos(x))` siano _uguali_ nel senso che restituiscono lo stesso oggetto (vale a dire il valore $(round(sin(cos(.42)), digits=3))...), notare che le due espressioni esprimono due processi diversi: `sin(cos(.42))` calcola prima `x = cos(.42)` e poi `sin(x)`, mentre l'epressione `( sin ∘ cos )(.42)`, a priori, calcola il valore in `.42` dell'oggetto `sin ∘ cos` considerata come un'unica funzione.
"""

# ╔═╡ 89bfa2db-719e-4c41-904e-7e6ba39a7f68
md"""
Chi vuole può provare a confrontare l'output dei comandi
```
@code_llvm ( sin ∘ cos )(x) 
```
e
```
@code_llvm sin(cos(.42))
```
"""

# ╔═╡ b49c1d83-53c1-4d8d-9e1d-424248688f8d
md"""
[L'operatore `\circ` in Julia](https://docs.julialang.org/en/v1/manual/functions/#Function-composition-and-piping) offre dunque una notazione naturale per [comporre funzioni dal punto di vista algoritmico](https://en.wikipedia.org/wiki/Function_composition_(computer_science)): 
"""

# ╔═╡ ded7939a-2f87-4216-83b3-9bce34a54966
let f = sin ∘ cos
	f(.42) ≈ sin(cos(.42))
end

# ╔═╡ 55140305-af51-493b-8c56-2ef13992e2e0
md"""
Come vedremo in lezioni successive, il linguaggio Julia è stato concepito con l'idea di [_composabilità_](https://en.wikipedia.org/wiki/Composability) tra i suoi concetti fondamentali, al fine di rendere il più semplice e naturale possibilite la _composizione di software_ di alto e basso livello, che è una caratteristica oggi fondamentale dei sistemi software di successo.
"""

# ╔═╡ 134727ea-e849-4579-85fb-7fc89bd7aab4
md"""
### Perché le trasformazioni lineari sono lineari?
"""

# ╔═╡ bf28c388-76bd-11eb-08a7-af2671218017
md"""
Provate a rispondere alla precedente domanda nel caso della funzione `warp`, della quale si forniscono di seguito varie implementazioni.
Per rinfrescare l'intuizione, cominciamo con un plot della funzione `warp`:
"""

# ╔═╡ d493e3b4-2c05-4438-845a-0b6fe6a9123f
let x_axis = -1:.01:1
	warped_x = (x, y) -> warp(1)([x, y])[1]
	warped_y = (x, y) -> warp(1)([x, y])[2]
	warped_point = (x, y) -> (warped_x(x, y), warped_y(x, y))
	points = [warped_point(x, 0) for x in -1:.01:1]
	scatter(points)
	scatter!([(x, 0) for x in x_axis], legend=false)
end

# ╔═╡ 2d1d64e0-9491-476e-849e-51af4e7d625b
md"""
Implementiamo ora una seconda versione della stessa funzione. Di seguito, qual'è la differenza tra `warp₂(α, x, y)` e `warp₂(α)`?
"""

# ╔═╡ 5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
begin	
	warp₂(α, x, y) = rotate₂(α*√(x^2+y^2))
	warp₂(α) = ((x, y),) -> warp₂(α, x, y)([x,y])	
end

# ╔═╡ b4a42942-5c42-45b8-badd-72b8e08481c0
md"""
Verifichiamo che la funzione risultante è la stessa di `warp`: 
"""

# ╔═╡ 01dfc571-c86e-493c-b67d-ddccfb2bf930
warp(1)([4, 2]) ≈ warp₂(1, 4, 2)([4, 2])

# ╔═╡ ad700740-7a74-11eb-3369-15e5fd89194d
md"""
## Cos'è una matrice se non una tabella di numeri?
"""

# ╔═╡ 5d656494-7a78-11eb-12e8-d17856bd8c4d
md"""
- Definizione intuitiva:
   
   > Una trasformazione lineare trasforma una griglia rettangolare in una griglia di parallelogrammi (vedere l'esempio della [Lezione 2.1](https://natema.github.io/ECMJ-it/lectures/lezione_2.1_trasformazioni_lineari.jl.html)).
"""

# ╔═╡ 1151d19f-fb0b-4f39-a29f-c5ef678f1603
md"""
- Definizione _operativa_: 

   > Una trasformazione lineare è definita dall'operazione di prodotto matriciale $v \mapsto A*v$ per una matrice fissata $A$.
"""

# ╔═╡ ea70bb58-b16c-4198-9dde-443fb226bb15
md"""
- La definizione tramite moltiplicazione e addizione:

   > 1. Il risultato non cambia se moltiplichiamo primo o dopo aver applicato la trasformazione lineare:
   >
   > $T(cv)=c \, T(v)$ ( $v$ is any vector, and $c$ any number.)
   >
   > 2. Il risultato non cambia se addizioniamo primo a dopo aver applicato la trasformazione lineare:
   >
   > $T(v_1+v_2) = T(v_1) + T(v_2).$ ($v_1,v_2$ sono due vettori qualsiasi.)
"""

# ╔═╡ 73b2aab2-2b7c-4340-a2ae-3b6895b8d0b8
md"""
- La definizione matematica:

   >  $T$ è lineare se
   >
   > $T(c_1 v_1 + c_2 v_2) = c_1 T(v_1) + c_2 T(v_2)$ per tutti i numeri $c_1,c_2$ e per tutti i vettori $v_1,v_2$.  
"""

# ╔═╡ ae5b3a32-7a84-11eb-04c0-337a74105a58
md"""
Abbiamo visto che una trasformazione lineare $T$ coincide, in pratica, con una matrice $A$; ovvero, nel caso bidimensionale avremo

$T\begin{pmatrix}\begin{pmatrix}x \\y\end{pmatrix}\end{pmatrix} = \begin{pmatrix} a & b \\ c & d \end{pmatrix}\begin{pmatrix}x \\y\end{pmatrix}.$

Come possiamo trovare i valori $a$, $b$, $c$ e $d$?
"""

# ╔═╡ 650320fe-7566-477b-ba83-a128149e3919
md"""
!!! hint "Risposta"
	Abbiamo che $T\begin{pmatrix}\begin{pmatrix}1\\ 0\end{pmatrix}\end{pmatrix} = \begin{pmatrix}a\\ c\end{pmatrix}$ e $T\begin{pmatrix}\begin{pmatrix}0\\ 1\end{pmatrix}\end{pmatrix} = \begin{pmatrix}b\\ d\end{pmatrix}$.
"""

# ╔═╡ c9f2b61e-7a84-11eb-3841-33739a226ff9
md"""
Dalle proprietà di linearità, possiamo infine vedere che 

$$T\begin{pmatrix}\begin{pmatrix}x \\ y\end{pmatrix}\end{pmatrix} = x \, T\begin{pmatrix}\begin{pmatrix}1 \\ 0\end{pmatrix}\end{pmatrix} + y \, T\begin{pmatrix}\begin{pmatrix}0 \\ 1\end{pmatrix}\end{pmatrix} = x \begin{pmatrix}a \\ c\end{pmatrix} + y \begin{pmatrix}b \\ d\end{pmatrix} = A \begin{pmatrix}x \\ y\end{pmatrix}.$$
"""

# ╔═╡ 23d8a45c-7a85-11eb-3a68-ef11e6f58cac
md"""
## Perché le matrici si moltiplicano come si moltiplicano?
"""

# ╔═╡ 4a96d516-7a85-11eb-181c-63a6b461790b
md"""
Definiamo due matrici random $2\times 2$, $A$ e $B$, e un vettore random bidimensionale $v$, e confrontiamo l'output ottenuto applicando a $v$ la composizione delle trasformazioni lineari descritte da $A$ e $B$, con l'output ottenuto applicando a $v$ la trasformazione lineare corrispondente al prodotto delle due matrici $A\cdot B$:
"""

# ╔═╡ 8206e1ee-7a8a-11eb-1f26-054f6b100076
let
	 A = randn(2,2)
	 B = randn(2,2)
	 v = rand(2)

	(lin(A) ∘ lin(B))(v), lin(A * B)(v)
end

# ╔═╡ dc7f338a-e6a3-4f9f-8f57-b66dfbcf482a
md"""
Perché le due funzioni coincidono?
"""

# ╔═╡ 0146a070-f39d-45c8-b3bb-6af59f024fd6
md"""
!!! hint "Suggerimento"
	Fare esplicitamente il conto per 

	$A = \begin{pmatrix} a & b \\ c & d \end{pmatrix}$ 
	e 
	
	$B =\begin{pmatrix} a' & b' \\ c' & d' \end{pmatrix}$

	rispetto ad un vettore _canonico_ $\begin{pmatrix}1 \\ 0\end{pmatrix}$. 
"""

# ╔═╡ 53678563-f110-4912-91c2-b52570be511d
md"""
Verifichiamo che le due trasformazioni, generate casualmente, risultano nella stessa trasformazione di un'immagine: 
"""

# ╔═╡ 350f40f7-795f-4f33-89b8-ff9ba4819e1c
test_img = load(download("https://www-sop.inria.fr/members/Emanuele.Natale/images/armadillo_zerocalcare.png"));

# ╔═╡ 313cdcbd-5b11-41c8-9fcd-5aeaca3b8d24
test_pixels = 300;

# ╔═╡ d15f9ea9-cace-4d91-9e46-8d63dedcb0ee
begin 
	P = randn(2, 2)
	Q = randn(2, 2)
	
	T₁ = lin(P) ∘ lin(Q)
	T₂ = lin(P*Q)
end

# ╔═╡ 620ee7d8-7a8f-11eb-3888-356c27a2d591
md"""
`lin(P)∘lin(Q)`
"""

# ╔═╡ 04da7710-7a91-11eb-02a1-0b6e889150a2
md"""
## Trasformazione delle coordinate
"""

# ╔═╡ 28a87dc7-9232-4b16-9460-0c3d3afba9f1
md"""
Ormai sappiamo bene che un'immagine non è altro che una griglia di pixel:
"""

# ╔═╡ 155cd218-7a91-11eb-0b4c-bd028507e925
md"""
Come possiamo _traslare_ un'immagine? 

Se per esempio vogliamo traslare l'immagine di un pixel a destra, una delle prime idee che possono venirci in mente è di **aggiungere** un unità all'indice della colonna delle coordinate di ciascun pixel. 

Una seconda possibilità, è di considerare il _sistema di coordinate_ dell'immagine, e di **sottrarre** un'unità dalle coordinate dell'origine del sistema. 
In quest'ultimo caso, si parla di una [_trasformazione delle coordinate_](https://en.wikipedia.org/wiki/List_of_common_coordinate_transformations). 
"""

# ╔═╡ fd25da12-7a92-11eb-20c0-995e7c46b3bc
md"""
### Dagli indici dell'array $(i, j)$ alle coordinate dei punti $(x, y)$
"""

# ╔═╡ 1ab2265e-7c1d-11eb-26df-39c4c7289243
md"""
Entriamo ora nel dettaglio di come la funzione `transform_xy_to_ij` che abbiamo già usato trasformi punti del piano in indici dell'array:
"""

# ╔═╡ e08fe807-553a-45f5-8878-4b7f15e35201
md"""
Un paio di test: 
"""

# ╔═╡ c1efc54a-7e9b-11eb-1e76-dbd0a66184a9
translate₂(-400,400)([1, 1])

# ╔═╡ db4bc328-76bb-11eb-28dc-eb9df8892d01
md"""
## Trasformazioni inverse
"""

# ╔═╡ 0b8ed36c-7a1e-11eb-053c-63cf9ee0b16f
md"""
L'inverso di una funzione $f$ è quella funzione, solitamente denotata con $f^{-1}$, tale che 
$f(f^{-1}(x))=x$ e $f^{-1}(f(x))=x$.

A volte non è possibile invertire $f$ per tutti i suoi possibili input $x$: per esempio, se $f(x)=x^2$, allora $f(-2)=f(2)=4$, e non è chiaro se $f^{-1}(4)$ debba essere $-2$ o $2$. Tipicamente però, è possibili invertire funzioni "non patologiche" almeno _localmente_: nell caso di $f(x)=x^2$ per esempio, la funzione è invertibile se assumiamo che $x\geq 0$:
"""

# ╔═╡ a28a2d43-f5fd-433c-9d33-e4e16a094423
let
	x_lim = 1.2
	all_range = -x_lim:.01:x_lim
	positive_range = 0:.01:x_lim
	plot(all_range, x -> x^2, label=L"$x^2$")
	plot!(positive_range, x -> sqrt(x), label=L"$\sqrt{x}$")
	plot!(positive_range, x -> x, label=L"${x}$", legend=:bottomleft)
end

# ╔═╡ 7a4e785e-7a71-11eb-07fb-cfba453a117b
md"""
## Esempi: rotazioni e _scaling_
"""

# ╔═╡ d622bdc0-b964-44a0-95a0-ed7c9fea4e8b
md"""
Consideriamo un vettore aleatorio $v$ e rotiamolo di un angolo $30^o$ e poi di $-30^o$:
"""

# ╔═╡ 9264508a-7a71-11eb-1b7c-bf6e62788115
let
	v = rand(2)
	T = rotate₂(30) ∘ rotate₂(-30)
	T(v), v, T(v) .≈ v
end

# ╔═╡ 336eae73-598f-469c-b854-a1eaf38a24bb
md"""
Ora facciamo la stessa cosa, ma anziché ruotare, ridimensioniamo (facciamo lo _scaling_, ovvero ingrandiamo e rimpiccioliamo) di un fattore $2$ e poi $.5$:
"""

# ╔═╡ e89339b2-7a71-11eb-0f97-971b2ed277d1
let	
	  v = rand(2)
	  T = scale(0.5) ∘ scale(2)
	  T(v), v, T(v) .≈ v
end

# ╔═╡ 0957fd9a-7a72-11eb-0566-e93ef32fb626
md"""
Possiamo dunque constatare che sia `rotate₂(30)` e `rotate₂(-30)`, che scale(2)` e `scale(.5)`, sono l'una la trasformazione inversa dell'altra.
"""

# ╔═╡ c7cc412c-7aa5-11eb-2df1-d3d788047238
md"""
## Risolvere equazioni tramite inversione
"""

# ╔═╡ 9acf7115-305f-4464-8c8c-d426a90880de
md"""
Abbiamo visto che l'inverso di una funzione $f$ è quella funzione $f^{-1}$ che _annulla_ l'effetto di $f$, ovvero applicandola dopo $f$ ad un valore $x$, il valore $x$ è lo stesso di partenza. 

Per esempio, se consideriamo un vettore $\mathbf y$ che si può esprimere raddoppiando un altro vettore $\mathbf x$, ovvero come $\mathbf y = 2 \mathbf x$, possiamo viceversa esprimere $\mathbf x$ come la metà di $\mathbf y$, ovvero $\frac 12 \mathbf y = \mathbf x$. 

Nel caso di una trasformazione lineare, abbiamo più in generale $\mathbf y = A \mathbf x$. Spesso (tecnicamente, quando il _determinante_ di $A$ non è zero), è possibile trovare la trasformazione lineare $B$ tale che $\mathbf x = B \mathbf y$. Per farlo, è necessario _risolvere il sistema lineare_ definito da $A$. 

Vediamo un esempio costruito a mano:
"""

# ╔═╡ bb9bf3b2-045b-486b-bd9f-67d008e1b641
let
	A = [2 1; 
		 0 -1]
	B = [1/2 1/2;
		 0 	 -1]
	
	x = rand(2)
	x, B*A*x 
end

# ╔═╡ 6ce1e9b4-17d0-4132-86de-3e66db5bb684
md"""
Quando è possibile trovare l'inversa $B$ di $A$, abbiamo $\mathbf x = B\cdot A \ \mathbf x$ per ogni $\mathbf x$, ovvero $B\cdot A = I$ dove $I$ è la matrice **identità**. In tal caso scriviamo inoltre $B= A^{-1}$. 

Per matrici $2\times 2$ è possibile scrivere una formula esplicita per la funzione inversa, ma in generale sarà necessario usare un computer per invertire sistemi lineari di dimensioni più grandi. 
"""

# ╔═╡ 4f51931c-7aac-11eb-13ba-4b8768ac376f
md"""
### Invertire trasformazioni lineari

In Julia una matrice $A$ può essere invertita utilizzando la funzione `inv`. 

Verifichiamo nel caso di una trasformazione lineare aleatoria $A$ applicata ad un vettore aleatorio $v$:
"""

# ╔═╡ 5ce799f4-7aac-11eb-0629-ebd8a404e9d3
let
	v = rand(2)
	A = randn(2,2)
    (lin(inv(A)) ∘ lin(A))(v), v
end 

# ╔═╡ 6f8454d7-2d65-4be4-9865-2d0b85b01140
md"""
Verifichiamo inoltre che l'operatore `inv` è _distributivo_, ovvero che l'inverso del prodotto di due trasformazioni lineari $A\cdot B$ è uguale al prodotto dei singoli inversi: 
"""

# ╔═╡ 9b456686-7aac-11eb-3aa5-25e6c3c86aff
let 
	 A = randn(2,2)
	 B = randn(2,2)
	 inv(A*B) ≈ inv(B) * inv(A)
end

# ╔═╡ c2b0a488-7aac-11eb-1d8b-edd6bd23d1fd
md"""
Per quanto riguarda la formula esplicita per l'inverso di una matrice $2\times 2$, eccola qui: 

``A^{-1}
=
\frac 1{ad-bc}\begin{pmatrix} d & -b \\ -c & a  \end{pmatrix} \quad
``
dove
``\ A \ =
\begin{pmatrix} a & b \\ c & d  \end{pmatrix} .
``
"""

# ╔═╡ 02d6b440-7aa7-11eb-1be0-b78dea91387f
md"""
### Invertire trasformazioni non-lineari
"""

# ╔═╡ 0be9fb1e-7aa7-11eb-0116-c3e86ab82c77
md"""
Come possiamo invece trovare l'inverso di una trasformazion $T$ non-lineare? In altre parole, data l'equazione $\mathbf y = T(\mathbf x)$, come possiamo trovare una funzione $T^{-1}$ tale che $T^{-1}(\mathbf y) = \mathbf x$? 

Si tratta di una domanda difficile in generale, a cui non si può dare una risposta univoca senza fare ulteriori assunzioni, specialmente dal punto di vista analitico. 

Dal punto di vista numerico, esistono però metodi assai generali, come il [metodo di Newton](https://en.wikipedia.org/wiki/Newton%27s_method), che discuteremo nella prossima lezione. 

In Julia troviamo già pronte varie implementazioni del metodo di Newton, per esempio nel pacchetto [NonlinearSolve.jl](https://github.com/JuliaComputing/NonlinearSolve.jl), che possiamo usare di seguito per cercare di invertire trasformazioni non-lineari. 
"""

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
# Appendice
"""

# ╔═╡ fb509fb4-9608-421d-9c40-a4375f459b3f
det_A = det(A)

# ╔═╡ 40655bcc-6d1e-4d1e-9726-41eab98d8472
img_sources = [
	"https://www-sop.inria.fr/members/Emanuele.Natale/images/armadillo_zerocalcare.png" => "armadillo",
	"https://www-sop.inria.fr/members/Emanuele.Natale/images/zerocalcare_characters.png" => "personaggi",
	"https://www-sop.inria.fr/members/Emanuele.Natale/images/zerocalcare_miniature.png" => "zero"
]

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
	black(c::RGB) = RGB(0,0,0)
	black(c::RGBA) = RGBA(0,0,0,0.75)
end

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
begin
	"""
	Converte le coordinate del sistema ``(x,y)`` in indici dell'array ``(i,j)``, 
	centra l'immagine e chiama la funzione `white` quando l'output si trova fuori dai bordi dell'immagine. 
	"""
	function transform_xy_to_ij(img::AbstractMatrix, x::Float64, y::Float64)
		rows, cols = size(img)
		m = max(cols, rows)	
		
	    # funzione che mappa $(x,y)$ in $(i,j)$
		xy_to_ij =  translate₂(rows/2, cols/2) ∘ swap ∘ flipy ∘ scale(m/2)
		
		# applica la funzione "snap to grid"
		i, j = floor.(Int, xy_to_ij((x, y))) 
	end

	"""
	Restituisce il colore del pixel dell'immagine, oppure il colore di default
	"""
	function getpixel(img, i::Int, j::Int; circular::Bool=false, r::Real=200)   
		rows, cols = size(img)
		m = max(cols,rows)
		if circular
			c = (i-rows/2)^2 + (j-cols/2)^2 ≤ r*m^2/4
		else
			c = true
		end
		
		if 1 < i ≤ rows && 1 < j ≤ cols && c
			img[i, j]
		else
			black(img[1,1])
		end
		
	end

	""" 
	Riconverte gli indici dell'array in coordinate dell'immagine
	"""
	function transform_ij_to_xy(i::Int, j::Int, pixels)
	   	ij_to_xy =  scale(2/pixels) ∘ flipy ∘ swap ∘ translate₂(-pixels/2,-pixels/2)
	   	ij_to_xy([i, j])
	end   
end

# ╔═╡ 7cfeb070-0a51-40b3-b842-0b1bd75d4bce
function transform_img(f, img) 
	[			    
		begin
			x, y = transform_ij_to_xy(i, j, test_pixels)
		 	X, Y = f([x, y])
		 	i, j = transform_xy_to_ij(img, X, Y)
		 	getpixel(img, i, j)
		end	 
		for i = 1:test_pixels, j = 1:test_pixels
	]
end

# ╔═╡ da73d9f6-7a8d-11eb-2e6f-1b819bbb0185
transform_img(T₁, test_img)

# ╔═╡ 30f522a0-7a8e-11eb-2181-8313760778ef
transform_img(T₂, test_img)

# ╔═╡ bf1954d6-7e9a-11eb-216d-010bd761e470
transform_ij_to_xy(1, 1, 400)

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n = 10)
    n = 2n+1
	rows, cols = size(img)
	result = copy(img)
	
	stroke = RGBA(1, 1, 1, 0.75)
	result[floor.(Int, LinRange(1, rows, n)), : ] .= stroke
	result[:, floor.(Int, LinRange(1, cols, n))] .= stroke
	
    result[rows÷2, :] .= RGBA(0,1,0,1)
	result[:, cols ÷2,] .= RGBA(1,0,0,1)
	return result
end

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original;n=ngrid)
else
	img_original
end;

# ╔═╡ ca28189e-7e9a-11eb-21d6-bd819f3e0d3a
[			    
	begin
		x, y = transform_ij_to_xy(i, j, pixels)
		X, Y = (translate₂(-panx,-pany))([x,y])
		X, Y = (T⁻¹∘scale(1/z)∘translate₂(-panx,-pany))([x,y])
	 	i, j = transform_xy_to_ij(img, X, Y)
	 	getpixel(img, i, j; circular=circular, r=r)
	end	 
	for i = 1:pixels, j = 1:pixels
]	

# ╔═╡ ccea7244-7f2f-11eb-1b7b-b9b8473a8c74
transform_xy_to_ij(img, 0.0, 0.0)

# ╔═╡ c2e0e032-7c4c-11eb-2b2a-27fe69c42a01
img

# ╔═╡ c662e3d8-7c4c-11eb-0dcf-f9da2bd14baf
size(img)

# ╔═╡ d0e9a1e8-7c4c-11eb-056c-aff283c49c31
img[150,356]

# ╔═╡ 0f613418-807f-436d-add6-c275429a86f9
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Soluzione", [text]))

# ╔═╡ 24f636dd-7f32-4eaa-8f67-ad13bcf548fd
md"""
**No**: considerate per esempio una [trasformazione _prospettica_](https://en.wikipedia.org/wiki/Perspective_(graphical)). 

![](https://cdn.kastatic.org/ka-perseus-images/1b351a3653c1a12f713ec24f443a95516f916136.jpg)
""" |> hint

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
NonlinearSolve = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.14.0"
ForwardDiff = "~0.10.29"
ImageIO = "~0.6.5"
ImageShow = "~0.3.6"
LaTeXStrings = "~1.3.0"
NonlinearSolve = "~0.3.16"
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
StaticArrays = "~1.4.4"
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

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "81f0cb60dc994ca17f68d9fb7c942a5ae70d9ee4"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.8"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "28bbdbf0354959db89358d1d79d421ff31ef0b5e"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.3"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "0eaf4aedad5ccc3e39481db55d72973f856dc564"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.22"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "f576084239e6bdf801007c80e27e2cc2cd963fe0"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "a985dc37e357a3b22b260a5def99f3530fb415d3"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.2"

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

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

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

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "51c8f36c81badaa0e9ec405dcbabaf345ed18c84"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.1"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "89cc49bf5819f0a10a7a3c38885e7c7ee048de57"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.29"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GPUArrays]]
deps = ["Adapt", "LLVM", "LinearAlgebra", "Printf", "Random", "Serialization", "Statistics"]
git-tree-sha1 = "c783e8883028bf26fb05ed4022c450ef44edd875"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.3.2"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "18be5268cf415b5e27f34980ed25a7d34261aa83"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.7"

[[deps.Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "303d70c961317c4c20fafaf5dbe0e6d610c38542"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.7.1+0"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

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

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "c8d47589611803a0f3b4813d9e267cd4e3dbcefb"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "4.11.1"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg", "TOML"]
git-tree-sha1 = "771bfe376249626d3ca12bcd58ba243d3f961576"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.16+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "b651f573812d6c36c22c944dd66ef3ab2283dfa1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.6"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SLEEFPirates", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "4392c19f0203df81512b6790a0a67446650bdce0"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.110"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

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

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "aeebff6a2a23506e5029fd2248a26aca98e477b3"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.16"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "e6c5f47ba51b734a4e264d7183b6750aec459fa0"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.11.1"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

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

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

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

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "0578fa5fde97f8cf19aa89f8373d92624314f547"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.9"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "7e597df97e46ffb1c8adbaddfa56908a7a20194b"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.5"

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

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "GPUArrays", "LinearAlgebra", "RecipesBase", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "6b25d6ba6361ccba58be1cf9ab710e69f6bc96f8"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.27.1"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "a9a852c7ebb08e2a40e8c0ab9830a744fa283690"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.10"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "62c2da6eb66de8bb88081d20528647140d4daa0e"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "ac399b5b163b9140f9c310dfe9e9aaa225617ff6"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.32"

[[deps.SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "8161f13168845aefff8dc193b22e3fcb4d8f91a9"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.31.5"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

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

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "5309da1cdef03e95b73cd3251ac3a39f887da53e"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "e03eacc0b8c1520e73aa84922ce44a14f024b210"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.6"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "b8d08f55b02625770c09615d96927b3a8396925e"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "ff34c2f1d80ccb4f359df43ed65d6f90cb70b323"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.31"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

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

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─972b2230-7634-11eb-028d-df7fc722ec70
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╠═d664f0f0-0c86-43e8-9f79-f285eb32bdd6
# ╟─c74b5fe6-167b-4dd3-93f1-fc25bc609931
# ╠═96766502-7a06-11eb-00cc-29849773dbcf
# ╟─e0b657ce-7a03-11eb-1f9d-f32168cb5394
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╠═85686412-7a75-11eb-3d83-9f2f8a3c5509
# ╟─0f742343-f41f-4de3-9b08-a95fef040623
# ╠═58a30e54-7a08-11eb-1c57-dfef0000255f
# ╟─313a1972-7106-46ca-9fdd-1e004b63b8e4
# ╠═ca28189e-7e9a-11eb-21d6-bd819f3e0d3a
# ╟─b52f4faa-ecc1-492b-b720-43b1c3623f9d
# ╟─ce55beee-7643-11eb-04bc-b517703facff
# ╟─bc696d68-9841-4a44-8448-c351ae7847ef
# ╟─2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╟─7f28ac40-7914-11eb-1403-b7bec34aeb94
# ╟─5d33f6ea-7e9c-11eb-2fb3-dbb7cb07c60c
# ╟─45dccdec-7912-11eb-01b4-a97e30344f39
# ╟─d2fb356e-7f32-11eb-177d-4f47d6c9e59b
# ╟─55b5fc92-7a76-11eb-3fba-854c65eb87f9
# ╠═ccea7244-7f2f-11eb-1b7b-b9b8473a8c74
# ╟─78d61e28-79f9-11eb-0605-e77d206cda84
# ╟─24f636dd-7f32-4eaa-8f67-ad13bcf548fd
# ╟─d9115c1a-7aa0-11eb-38e4-d977c5a6b75b
# ╟─e965cf5e-79fd-11eb-201d-695b54d08e54
# ╟─1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
# ╟─28ef451c-7aa1-11eb-340c-ab3a1193a3c4
# ╟─a0afe3ae-76b9-11eb-2301-cde7260ddd7f
# ╟─fc2deb7c-7aa1-11eb-019f-d3e3c80b9ff1
# ╠═d364f91a-76b9-11eb-1807-75e733940d53
# ╟─080d87e0-7aa2-11eb-18f5-2fb6a7a5bcb4
# ╠═15283aba-7aa2-11eb-389c-e9f215bd03e2
# ╟─2612d2c2-7aa2-11eb-085a-1f27b6174995
# ╟─a290d5e2-7a02-11eb-37db-41bf86b1f3b3
# ╠═b4cdd412-7a02-11eb-149a-df1888a0f465
# ╠═903ac4a8-b1f8-4858-a532-18c3ebb5b2d8
# ╟─17a6f4e2-2d0f-4b49-a99e-4f9c17d5ffea
# ╠═425c9c7c-bee0-4729-ad98-ce311ed03092
# ╟─cab5d8c1-46a6-4bdf-b23b-2325858713b3
# ╠═df873cce-fdaf-485c-9236-55badeb73d82
# ╠═9730776a-c2ad-44a6-af2d-3feb6cb91060
# ╠═5de5f6d9-f957-4901-bcf3-32313cf84106
# ╟─704a87ec-7a1e-11eb-3964-e102357a4d1f
# ╟─b93f47fd-9900-49bc-9d14-96d9344f28fc
# ╠═4b0e8742-7a70-11eb-1e78-813f6ad005f4
# ╟─36f00e34-dfa2-4057-8f87-271991d7e64d
# ╟─89bfa2db-719e-4c41-904e-7e6ba39a7f68
# ╟─b49c1d83-53c1-4d8d-9e1d-424248688f8d
# ╠═ded7939a-2f87-4216-83b3-9bce34a54966
# ╟─55140305-af51-493b-8c56-2ef13992e2e0
# ╟─134727ea-e849-4579-85fb-7fc89bd7aab4
# ╟─bf28c388-76bd-11eb-08a7-af2671218017
# ╠═d493e3b4-2c05-4438-845a-0b6fe6a9123f
# ╟─2d1d64e0-9491-476e-849e-51af4e7d625b
# ╠═5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
# ╟─b4a42942-5c42-45b8-badd-72b8e08481c0
# ╠═01dfc571-c86e-493c-b67d-ddccfb2bf930
# ╟─ad700740-7a74-11eb-3369-15e5fd89194d
# ╟─5d656494-7a78-11eb-12e8-d17856bd8c4d
# ╟─1151d19f-fb0b-4f39-a29f-c5ef678f1603
# ╟─ea70bb58-b16c-4198-9dde-443fb226bb15
# ╟─73b2aab2-2b7c-4340-a2ae-3b6895b8d0b8
# ╟─ae5b3a32-7a84-11eb-04c0-337a74105a58
# ╟─650320fe-7566-477b-ba83-a128149e3919
# ╟─c9f2b61e-7a84-11eb-3841-33739a226ff9
# ╟─23d8a45c-7a85-11eb-3a68-ef11e6f58cac
# ╟─4a96d516-7a85-11eb-181c-63a6b461790b
# ╠═8206e1ee-7a8a-11eb-1f26-054f6b100076
# ╟─dc7f338a-e6a3-4f9f-8f57-b66dfbcf482a
# ╟─0146a070-f39d-45c8-b3bb-6af59f024fd6
# ╟─53678563-f110-4912-91c2-b52570be511d
# ╠═350f40f7-795f-4f33-89b8-ff9ba4819e1c
# ╠═313cdcbd-5b11-41c8-9fcd-5aeaca3b8d24
# ╠═d15f9ea9-cace-4d91-9e46-8d63dedcb0ee
# ╠═7cfeb070-0a51-40b3-b842-0b1bd75d4bce
# ╠═da73d9f6-7a8d-11eb-2e6f-1b819bbb0185
# ╟─620ee7d8-7a8f-11eb-3888-356c27a2d591
# ╠═30f522a0-7a8e-11eb-2181-8313760778ef
# ╟─04da7710-7a91-11eb-02a1-0b6e889150a2
# ╟─28a87dc7-9232-4b16-9460-0c3d3afba9f1
# ╠═c2e0e032-7c4c-11eb-2b2a-27fe69c42a01
# ╠═c662e3d8-7c4c-11eb-0dcf-f9da2bd14baf
# ╠═d0e9a1e8-7c4c-11eb-056c-aff283c49c31
# ╟─155cd218-7a91-11eb-0b4c-bd028507e925
# ╟─fd25da12-7a92-11eb-20c0-995e7c46b3bc
# ╟─1ab2265e-7c1d-11eb-26df-39c4c7289243
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╟─e08fe807-553a-45f5-8878-4b7f15e35201
# ╠═bf1954d6-7e9a-11eb-216d-010bd761e470
# ╠═c1efc54a-7e9b-11eb-1e76-dbd0a66184a9
# ╟─db4bc328-76bb-11eb-28dc-eb9df8892d01
# ╟─0b8ed36c-7a1e-11eb-053c-63cf9ee0b16f
# ╠═a28a2d43-f5fd-433c-9d33-e4e16a094423
# ╟─7a4e785e-7a71-11eb-07fb-cfba453a117b
# ╟─d622bdc0-b964-44a0-95a0-ed7c9fea4e8b
# ╠═9264508a-7a71-11eb-1b7c-bf6e62788115
# ╟─336eae73-598f-469c-b854-a1eaf38a24bb
# ╠═e89339b2-7a71-11eb-0f97-971b2ed277d1
# ╟─0957fd9a-7a72-11eb-0566-e93ef32fb626
# ╟─c7cc412c-7aa5-11eb-2df1-d3d788047238
# ╟─9acf7115-305f-4464-8c8c-d426a90880de
# ╠═bb9bf3b2-045b-486b-bd9f-67d008e1b641
# ╟─6ce1e9b4-17d0-4132-86de-3e66db5bb684
# ╟─4f51931c-7aac-11eb-13ba-4b8768ac376f
# ╠═5ce799f4-7aac-11eb-0629-ebd8a404e9d3
# ╟─6f8454d7-2d65-4be4-9865-2d0b85b01140
# ╠═9b456686-7aac-11eb-3aa5-25e6c3c86aff
# ╟─c2b0a488-7aac-11eb-1d8b-edd6bd23d1fd
# ╟─02d6b440-7aa7-11eb-1be0-b78dea91387f
# ╟─0be9fb1e-7aa7-11eb-0116-c3e86ab82c77
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╠═40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╟─0f613418-807f-436d-add6-c275429a86f9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
