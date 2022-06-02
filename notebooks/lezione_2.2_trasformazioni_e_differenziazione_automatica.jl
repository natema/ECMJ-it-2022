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
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
	using ForwardDiff
	using Plots
end

# ╔═╡ c3ef3bf1-144d-4184-a4b4-f8e56750004c
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it-2022/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)
"""

# ╔═╡ 9a53f7a0-bf48-4169-ade7-51c44f823064
md"""
Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it-2022), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ f98e5845-a4f7-4b88-ab68-e65af688444b
md"""
# Lezione 2.2 - Trasformazioni e differenziazione automatica
"""

# ╔═╡ b7895bd2-7634-11eb-211e-ef876d23bd88
PlutoUI.TableOfContents(aside=true)

# ╔═╡ e6a09409-f262-453b-a434-bfd935306719
md"""
#### Inizializzazione dei pacchetti Julia

(_Quando si esegue questo notebook per la prima volta, può essere necessario un esercizio di pazienza di vari minuti..._)
"""

# ╔═╡ 58a520ca-763b-11eb-21f4-3f27aafbc498
md"""
Abbiamo visto come definire *combinazioni lineari* di immagini, in particolare 
* un'immagine può essere "scalata" moltiplicandola per una costante e 
* combinata con altre immagini sommando i colori dei rispettivi pixel. 

Una [combinazione lineare](https://en.wikipedia.org/wiki/Linear_combination), in generale, è una combinazione delle due operazioni precedenti. 

In questa lezione considereremo più in generale il concetto di [funzione](https://en.wikipedia.org/wiki/Function_(mathematics)), concentrandoci su quelle [differenziabili](https://en.wikipedia.org/wiki/Differentiable_function) al fine di introdurre l'idea di [differenziazione automatica](https://en.wikipedia.org/wiki/Automatic_differentiation). 

![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/AutomaticDifferentiationNutshell.png/1920px-AutomaticDifferentiationNutshell.png)
"""

# ╔═╡ 2cca0638-7635-11eb-3b60-db3fabe6f536
md"""
## Funzioni di una variabile (univariate)

Sin dalle scuole superiori abbiamo incontrato varie funzioni univariate, per es. 
* $f₁(x)=x^2$
* $f₂(x)=\sin(x)$
* $f₃(x)=x^\alpha$
"""

# ╔═╡ d2a89bc9-31cd-4268-a509-dcf573ad5cbc
md"""
Facendo un breve ripasso, abbiamo visto che in Julia le funzioni possono essere scritte in 3 modi: 
"""

# ╔═╡ 539aeec8-76ab-11eb-32a3-95c6672a0ea9
# In _short form_
f₁(x) = x^2 # (pedici in unicode: \_1 + <tab>)

# ╔═╡ 81a00b78-76ab-11eb-072a-6b96847c2ce4
f₁(5)

# ╔═╡ 2369fb18-76ab-11eb-1189-85309c8f925b
# In _anonymous form_
x->sin(x)

# ╔═╡ 98498f84-76ab-11eb-23cf-857c776a9163
(x->sin(x))(π/2)

# ╔═╡ c6c860a6-76ab-11eb-1dec-1b2f179a0fa9
# In _long form+
function f₃(x,α=3) # parametro di default
	return x^α  # la keyword "return" è facoltativa
end

# ╔═╡ f07fbc6c-76ab-11eb-3382-87c7d65b4078
 f₃(5)

# ╔═╡ f4fa8c1a-76ab-11eb-302d-bd410432e3cf
f₃(5,2)

# ╔═╡ b3faf4d8-76ac-11eb-0be9-7dda3d37aba0
md"""
#### Argomenti _keyword_

In Julia, possiamo definire come argomenti di una funzione degli argomenti detti "keywork", elencandoli come argomenti della funzione dopo un punto e virgola, come nel seguente esempio:
"""

# ╔═╡ 71c074f0-76ac-11eb-2164-c36381212bff
f₄(x;α) = x^α

# ╔═╡ f72db3ea-2ffe-4765-a035-ebbbe399abb8
md"""
Il valore di input delle _keyword_ deve essere indicato esplicitamente, come nell'esempio seguente per la keyword $\alpha$:
"""

# ╔═╡ 87b99c8a-76ac-11eb-1c94-8f1ffe3be593
f₄(2, α=5)

# ╔═╡ 504076fc-76ac-11eb-30c3-bfa75c991cb2
md"""
Vedere la [pagina della documentazione di Julia sulle funzioni](https://docs.julialang.org/en/v1/manual/functions/) per più esempi e informazioni.
"""

# ╔═╡ 44be265b-f7c2-43ee-b4e5-e6184deeb0d6
md"""
Ricordiamoci inoltre di non esitare nel cercare di rendere le idee matematiche più concrete cercando di visualizzarle: 
"""

# ╔═╡ 02367402-9ff6-4659-9d78-4c281f898750
begin 
	points = 0:.01:2
	plot(points, f₄.(points, α=2), title="f₄(x, α)", ylabel="f₃", xlabel="x", label="α=2")
	plot!(points, f₄.(points, α=3), label="α=3")
	plot!(points, f₄.(points, α=4), label="α=4")
end

# ╔═╡ f1dd24d8-76ac-11eb-1de7-a763a1b95668
md"""
### Differenziazione automatica: caso univariato

La differenziazione automatica è una tecnica fondamentale per il machine learning ed il calcolo scientifico moderno, permettendo di stimare la derivata di funzioni in un modo fondamentalmente diverso sia dalla differenziazione simbolica che viene comunemente insegnata nei corsi di analisi matematica classici, che dalla differenziazione numerica calcolata utilizzando il metodo delle differenze finite. 

Il funzionamento esatto di tale idea esula dallo scopo di questo corso introduttivo, ma gli studenti interessati possono consultare [il materiale del corso avanzato _Parallel Computing and Scientific Machine Learning_](https://book.sciml.ai/lectures/#lecture_8_forward-mode_automatic_differentiation).
"""

# ╔═╡ d42aec08-76ad-11eb-361a-a1f2c90fd4ec
ForwardDiff.derivative(f₁, 5)

# ╔═╡ 06437040-76ae-11eb-0b1c-23a6470f41c8
ForwardDiff.derivative( x->f₃(x,3), 5)

# ╔═╡ 28cd454c-76ae-11eb-0d1e-a56995100d59
md"""
(Notate l'uso di una funzione anonima al fine di fissare il parametro $\alpha=3$; è una tecnica che torna spesso utile). 

Nel caso sia opportuno un ripasso del concetto di derivata, lo richiameremo di seguito illustrandone l'approssimazione col [metodo delle differenze finite](https://it.wikipedia.org/wiki/Metodo_delle_differenze_finite). 
"""

# ╔═╡ 632a1f8c-76ae-11eb-2088-15c3e3c0a210
begin
	md"""
	 $cₑₚₛ=$ $(@bind cₑₚₛ Slider(-6:-1, default=-1, show_value=true))
	"""
end

# ╔═╡ 8a99f186-76af-11eb-031b-f1c288993c7f
ϵ = 10.0^cₑₚₛ 

# ╔═╡ df07d542-3238-4d92-bf83-1de3e9e42984
md"""
Confrontiamo la precisione dei diversi metodi: 

- differenze finite: `(sin(1+ϵ)-sin(1))/ϵ` = $((sin(1+ϵ)-sin(1))/ϵ)
- derivata simbolica: `cos(1)` = $(cos(1))
- differenziazione automatica: `ForwardDiff.derivative(sin,1)` = $(ForwardDiff.derivative(sin,1))

(Potete controllare il sorgente della cella per verificare che le quantità riportate sono calcolate contestualmente da Julia.)
"""

# ╔═╡ f7df6cda-76b1-11eb-11e4-8d0af0349651
md"""
## Funzioni scalari multivariate

Ora vedremo come quanto visto sopra si estende a funzioni di più di un argomento (_multivariate_). 

Consideriamo per esempio la funzione $f_5(x) = 5\sin(x_1*x_2) + 2x_2/4x_3$, che possiamo implementare in Julia in un paio di modi:
"""

# ╔═╡ 8c6b0236-76b4-11eb-2acf-91da23bedf0e
begin
	f₅(v) = 5sin(v[1]*v[2]) + 2*v[2]/4v[3]
	f₅(x, y, z) = 5sin(x*y) + 2*y/4z
end

# ╔═╡ a397d526-76b5-11eb-3cce-4374e33324d1
f₅(1, 2, 3), f₅([1, 2, 3])

# ╔═╡ 978fd5e2-7a9b-4979-bb81-cf126e0ae9e2
md"""
Notare che nell'esempio precedente c'è parecchio [codice duplicato](https://en.wikipedia.org/wiki/Duplicate_code): nelle due implementazioni di $f_5$ vengono ripetute le stesse operazioni. 
Scrivere codice di buona qualità richiede di [evitare di ripetersi quando non è logicamente necessario](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). 

Per esempio, quanto scritto per $f_5$ può essere riscritto come segue: 
"""

# ╔═╡ bf23ab30-76b5-11eb-1adb-3d74a52cddfd
begin
	f₆(x, y, z)  = 5sin(x*y) + 2*y/4z
	f₆( v ) = f₆(v[1], v[2], v[3])
end

# ╔═╡ d5d4ac48-76b6-11eb-1687-ed853c2db7c9
f₆(1,2,3), f₆([1,2,3])

# ╔═╡ 89b2d570-76ba-11eb-0389-813bbb33efea
md"""
Un altro trucco in Julia che permette di [aumentare la leggibilità del codice](https://en.wikipedia.org/wiki/Computer_programming#Readability_of_source_code) che utilizza vettori è di utilizzare come argomenti delle _tuple_. Così facendo, il codice funzionerà direttamente anche per vettori, mentre la sua definizione potrà far uso di espressioni più leggibili delle semplici entrate indicizzate di un vettore; illustriamo il concetto con un esempio: 
"""

# ╔═╡ a8c28578-76ba-11eb-3f3f-af35ff0b6c74
f₇((x,y,z)) = 5sin(x*y) + 2*y/4z # più leggibile di 5sin(v[1]*v[2]) + 2*v[2]/4v[3]

# ╔═╡ d9e07084-76ba-11eb-18ac-c58b1bc972ba
f₇([1,2,3]) # il codice funziona anche fornendo dei vettori come argomenti, ma non scalari (f₇(1,2,3) dà errore)

# ╔═╡ 42172fb6-76b7-11eb-0a11-b7e10c6881f5
md"""
Possiamo infine constatare come le funzioni $f_5$ e $f_6$ abbiamo due metodi in Julia, rispettivamente con una o con tre variabili:
"""

# ╔═╡ 57b0cd3c-76b7-11eb-0ece-810f3a8ede00
methods(f₆)

# ╔═╡ 0dcec07b-4622-4e9b-9c99-c2a2b04ee2db
md"""
Concludiamo nuovamente la sezione distraendoci con qualche grafico. ·

Chiamiamo la funzione `plotly()` che permette di visualizzare il grafico utilizzando la libreria Plotly:
"""

# ╔═╡ 56f88155-890e-4129-926d-90c21a1907d8
plotly()

# ╔═╡ dd3095a1-abb2-4060-9651-db200dfe1dcf
md"""
La funzione f₆ che abbiamo utilizzato richiede 3 argomenti. 
Scegliamo in modo interattivo il valore di un parametro β che fisseremo come terzo argomento di f₆, per poter variare gli altri due input della funzione e visualizzarne i valori come una superficie: 

β = $(@bind β Slider(1:10, show_value=true, default=1))
"""

# ╔═╡ 525d1b08-b8aa-4ffe-b5b3-f7ea5e343023
surface(-1:0.01:1, -1:0.01:1, (x,y)->f₆(x, y, β), c=:Blues)

# ╔═╡ 6d411cea-76b9-11eb-061b-87d472bc3bdd
md"""
### Differenziazione automatica: caso scalare multivariato
"""

# ╔═╡ bc2c6afc-76b7-11eb-0631-51f83cd73205
md"""
Vediamo adesso come le idee viste finora si generalizzano a più dimensioni. 
In molte applicazioni infatti, inclusi gli scenari tipici del il machine learning, è necessario calcolare le derivate di una funzione nella direzione corrispondente a ciascun argomento della funzione. 
Tale vettore di derivate è noto come *gradiente*. 
In Julia, la differenziazione automatica si estende naturalmente a più dimensioni:
"""

# ╔═╡ ef06cfd8-76b7-11eb-1530-1fcd7e5c5992
grad_f₅ = ForwardDiff.gradient(f₅, [1, 2, 3])

# ╔═╡ 051db7a0-76b8-11eb-14c7-531f42ef60b8
md"""
Ricordando che 
$f_5(x) = 5\sin(x_1*x_2) + 2x_2/4x_3$, possiamo verificare numericamente la risposta precedente per il valore di $\epsilon$ scelto interattivamente in precedenza: 
"""

# ╔═╡ 2705bf34-76b8-11eb-3aaa-d363085784ff
begin
	∂f₅∂x =  (f₅(1+ϵ, 2,   3  ) - f₅(1, 2, 3)) / ϵ
	∂f₅∂y =  (f₅(1,   2+ϵ, 3  ) - f₅(1, 2, 3)) / ϵ
	∂f₅∂z =  (f₅(1,   2,   3+ϵ) - f₅(1, 2, 3)) / ϵ
	∇f = [∂f₅∂x, ∂f₅∂y, ∂f₅∂z]
end

# ╔═╡ dfb9d74c-76b8-11eb-24ff-e521f1294a6f
md"""
Che voi siate già esperti in analisi multivariata oppure non abbiate mai visto questi concetti prima d'ora, vedere queste idee illustrate concretamente dal punto di vista numerico dovrebbe aiutarvi a rendere le idee di fondo più intuitive. 

#### L'algoritmo del gradiente per funzioni molto-multivariate 

Prima di proseguire, notiamo come in machine learning e altri ambiti inerenti l'ottimizzazione, si voglia minimizzare una funzione scalare di molti parametri nota come [loss function](https://en.wikipedia.org/wiki/Loss_function);
l'[algoritmo del gradiente](https://en.wikipedia.org/wiki/Gradient_descent) è di gran lunga la tecnica più diffusa e, di fatto, efficace, per minimizzare funzioni su spazi con molte dimensioni (per esempio, lo spazio dei possibili parametri di una [rete neurale artificiale](https://en.wikipedia.org/wiki/Neural_network)). 

![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Gradient_descent.svg/800px-Gradient_descent.svg.png)
È bene però non dimenticare che quando si lavora con funzioni con pochi parametri, esistono tecniche più sofisticate e che danno spesso risultati migliori. 
"""

# ╔═╡ a0afe3ae-76b9-11eb-2301-cde7260ddd7f
md"""
## Funzioni vettoriali multivariate
"""

# ╔═╡ ac1ab224-76bb-11eb-13cb-0bd44bea1042
md"""
Consideriamo ora funzioni del tipo $f:\mathbb R^n \rightarrow \mathbb R^m$, ovvero da uno spazio multidimensionale a un altro spazio multidimensionale. Tali funzioni sono spesso anche chiamate _trasformazioni_ dello spazio; tecnicamente si potrebbe chiamare trasformazione anche una funzione scalare, ma il senso del termine è di suggerire che vettori vengono trasformati in vettori. 

Una classe di trasformazioni fondamentali, in quanto _minimale_ dal punto di vista della multidimensionalità, sono dunque quelle che vanno da $\mathbb R^2$ a $\mathbb R^2$. 
Nelle lezioni precedenti ne abbiamo viste varie lavorando con immagini.
Vediamo di seguito qualche esempio: 
"""

# ╔═╡ d364f91a-76b9-11eb-1807-75e733940d53
begin
	# identità
	idy((x,y)) = [x,y]
	# una trasformazione lineare
	lin1((x,y)) =  [ 2x + 3y, -5x+4x ]
	# scaling di $x$
	scalex(α) = ((x,y),) -> (α*x, y)
	# scaling di $y$
	scaley(α) = ((x,y),) -> (x,   α*y)
	# rotazione di angolo θ
	rot(θ) = ((x,y),) -> [cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y]
	# inclinazione dell'asse $y$
	shear(α) = ((x,y),) -> [x+α*y,y]
	# trasformazione lineare generale
	genlin(a,b,c,d) = ((x,y),) -> [ a*x + b*y ; c*x + d*y ]
end

# ╔═╡ 77a4492c-cc79-4ace-b259-b9ee17737b1f
md"""
Proviamo a sperimentare con alcune di esse:
"""

# ╔═╡ f25c6308-76b9-11eb-3563-1f0ef4cdf86a
rot(π/2)([4,5])

# ╔═╡ db4bc328-76bb-11eb-28dc-eb9df8892d01
md"""
Come avrete probabilmente notato, tutte le trasformazioni proposte sono un caso particolare dell'ultima, `genlin`, che può essere rappresentata in forma matriciale: 

`` \operatorname{genlin}((x, y)^T) = \begin{pmatrix} a & b \\ c & d \end{pmatrix}
\begin{pmatrix} x \\ y \end{pmatrix}``
"""

# ╔═╡ f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
md"""
#### Matriciale o non matriciale? 

Esistono funzioni che, al contrario, non possono essere rappresentate in forma matriciale. Una domanda interessante per coloro che non hanno solide basi in algebra lineare: cosa contraddistingue tali funzioni?

Dopo aver provato a dare una risposta, vediamo un esempio: 
"""

# ╔═╡ 78176284-76bc-11eb-3045-f584127f58b9
begin
	# la funzione `warp`
	function warp(α)
		((x,y),)  -> begin
			r = √(x^2+y^2)
			θ=α*r
			rot(θ)([x,y])
		end
	end
	# trasfromazioni in cordinate polari e viceversa
	rθ((x, y)) = (norm(x), atan(y, x)) 
	xy((r,θ)) = ( r*cos(θ), r*sin(θ))
end

# ╔═╡ bf28c388-76bd-11eb-08a7-af2671218017
md"""
Vediamo che `warp` opera una deformazione che consiste in una rotazione per un angolo che dipende dal punto stesso in cui viene applicata:
"""

# ╔═╡ 5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
begin	
	warp₂(α,x,y) = rot(α*√(x^2+y^2))
	warp₂(α) = ((x,y),) -> warp₂(α,x,y)([x,y])	
end

# ╔═╡ 852592d6-76bd-11eb-1265-5f200e39113d
warp(1)([5,6])

# ╔═╡ 8e36f4a2-76bd-11eb-2fda-9d1424752812
warp₂(1.0)([5.0,6.0])

# ╔═╡ 09ed6d38-76be-11eb-255b-3fbf76c21097
md"""
### Differenziazione automatica di trasformazioni
"""

# ╔═╡ 46a36183-f2f9-46cf-8bd9-999e083a6cbf
md"""
Ricordiamo che data una funzione $f = (f_1, ..., f_m)^T$ con $f_i: \mathbb R^n \rightarrow  \mathbb R$, il suo [Jacobiano](https://en.wikipedia.org/wiki/Jacobian_matrix_and_determinant) $\mathbf J_f$ è la matrice le cui righe sono i gradienti delle $f_i$, ovvero $\mathbf J_f = (\nabla f_1, ..., \nabla f_m)^T$. 

Calcoliamo il Jacobiano della funzione `warp`: 
"""

# ╔═╡ 9786e2be-76be-11eb-3755-b5669c37aa64
ForwardDiff.jacobian(warp(3.0), [4,5])

# ╔═╡ 963694d6-76be-11eb-1b27-d5d063964d24
md"""
Verifichiamo l'output precedente, come fatto in precedenza, con un'approssimazione numerica diretta: 
"""

# ╔═╡ b78ef2fe-76be-11eb-1f55-3d0874b298e8
begin
	# notare che le due righe seguenti creano dei vettori
	∂w∂x = (warp(3.0)([4+ϵ, 5  ]) -   warp(3.0)([4,5]))/ϵ 
	∂w∂y = (warp(3.0)([4  , 5+ϵ]) - warp(3.0)([4,5]))/ϵ 
	[∂w∂x ∂w∂y]
end

# ╔═╡ ad728ee6-7639-11eb-0b23-c37f1366fb4e
md"""
## Che cos'è una matrice?

Probabilmente sapete come moltiplicare un vettore per una matrice. 
Una matrice può superficialmente essere vista come una tabella di numeri; 
tuttavia, tale array rettangolare può essere interpretato in modo più profondo come una trasformazione lineare generale. 
"""

# ╔═╡ 40655bcc-6d1e-4d1e-9726-41eab98d8472
img_sources = [
	"https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/armadillo_zerocalcare.png" => "armadillo",
	"https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/zerocalcare_characters.png" => "personaggi",
	"https://raw.githubusercontent.com/natema/ECMJ-it/main/imgs/zerocalcare_miniature.png" => "zero"
]

# ╔═╡ c0c90fec-0e55-4be3-8ea2-88b8705ee258
md"""
#### Selezionate un'immagine: $(@bind img_source Select(img_sources))
"""

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img_original = load(download(img_source));

# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
md"""
Scegliete α = $(@bind α Slider(.1:.1:3, show_value=true, default = 1))
"""

# ╔═╡ 005ca75a-7622-11eb-2ba4-9f450e71df1f
let range = -1.5:.1:1.5
md"""
La seguente è una matrice _scrubbable_ (che potremmo tradurre con _scorrevole_): potete cambiare il valore delle singole entrate cliccandoci e trascinando il mouse:
	
``(``	
 $(@bind a Scrubbable( range; default=1.0))
 $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
$(@bind c Scrubbable(range; default=0.0 ))
$(@bind d Scrubbable(range; default=1.0))
``)``

Di sotto riportiamo l'immagine trasformata, basandoci su quanto visto nella lezione precedente (che riportiamo dopo l'immagine). 

	Per resettare il valore della matrice a quello dell'identità, ricaricare la cella.
"""
end

# ╔═╡ ed3caab2-76bf-11eb-2544-21e8181adef5
T = genlin(a,b,c,d) # sostituite altre trasformazioni qui per sperimentare
# T = warp(α)

# ╔═╡ 488d732c-7631-11eb-38c3-e9a9165d5606
md"""
Zoom centrale =	$(@bind f Slider(.1:.1:3, show_value=true, default=1))
"""

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
md"""
Zoomare verso l'alto a sinistra = $(@bind z Slider(.1:.1:3, show_value=true, default=1))
"""

# ╔═╡ 60532aa0-740c-11eb-0402-af8ff117f042
md"Mostra la griglia: $(@bind show_grid CheckBox(default=true))"

# ╔═╡ 3e132708-e7af-4fb7-b828-882c5123bdac
md"""
La trasformazione che è stata selezionata interattivamente nella matrice scorrevole è
"""

# ╔═╡ f085296d-48b1-4db6-bb87-db863bb54049
A = [
	a b
	c d
	]

# ╔═╡ d1757b2c-7400-11eb-1406-d937294d5388
md"Il cui determinante è $\mathrm{det}(A)$ = $a ``\cdot`` $d - $c ``\cdot`` $b =  $(det(A))"

# ╔═╡ fb509fb4-9608-421d-9c40-a4375f459b3f
det_A = det(A)

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
## Appendice
"""

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
end

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
function trygetpixel(img::AbstractMatrix, x::Float64, y::Float64)
	rows, cols = size(img)

	f = t -> (t + 1.0)/2.
	
	i = floor(Int, rows *  f(-y) / z)
	j = floor(Int, cols *  f(x * (rows / cols))  / z)
 
	if 1 < i ≤ rows && 1 < j ≤ cols
		img[i,j]
	else
		white(img[1,1])
	end
end

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n=16)
	
	sep_i = size(img, 1) ÷ n
	sep_j = size(img, 2) ÷ n
	
	result = copy(img)
	
	stroke = RGBA(1, 1, 1, 0.75)
	result[1:sep_i:end, :] .= stroke
	result[:, 1:sep_j:end] .= stroke
	# un'altro pixel di spessore
	result[2:sep_i:end, :] .= stroke
	result[:, 2:sep_j:end] .= stroke
	# linee orizzontali e verticali centrali
	result[sep_i*(n÷2) .+ [1,2],  :] .= RGBA(0,1,0,1)
	result[:, sep_j*(n÷2) .+ [1,2],] .= RGBA(1,0,0,1)
	
	return result
end

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original)
else
	img_original
end;

# ╔═╡ 8e0505be-359b-4459-9de3-f87ec7b60c23
[
	if det_A == 0
		RGB(1.0, 1.0, 1.0)
	else
		in_x, in_y =  T([out_x, out_y])
		trygetpixel(img, in_x, in_y)
	end
	for out_y in LinRange(f, -f, 500),
		out_x in LinRange(-f, f, 500)
]

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.9.6"
Colors = "~0.12.8"
FileIO = "~1.11.1"
ForwardDiff = "~0.10.19"
HypertextLiteral = "~0.9.0"
ImageIO = "~0.5.8"
ImageShow = "~0.3.2"
Plots = "~1.29.0"
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

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4ce9393e871aca86cc457d9f66976c3da6902ea7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.4.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

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

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

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
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

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
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

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

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "3c041d2ac0a52a12a27af2782b34900d9c3ee68c"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.1"

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

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

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
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

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

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "2c1cf4df419938ece72de17f368a021ee162762e"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.0"

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
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "4d4c9c69972c6f4db99a70d71c5cc074dd2abbf1"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.3"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "595155739d361589b3d074386f77c107a8ada6f7"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.2"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "13c826abd23931d909e4c5538643d9691f62a617"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.8"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "e439b5a4e8676da8a29da0b7d2b498f2db6dbce3"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.2"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

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
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

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
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

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

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

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

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

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

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

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
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

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

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

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
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

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
# ╟─c3ef3bf1-144d-4184-a4b4-f8e56750004c
# ╟─9a53f7a0-bf48-4169-ade7-51c44f823064
# ╟─f98e5845-a4f7-4b88-ab68-e65af688444b
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╟─e6a09409-f262-453b-a434-bfd935306719
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─58a520ca-763b-11eb-21f4-3f27aafbc498
# ╟─2cca0638-7635-11eb-3b60-db3fabe6f536
# ╟─d2a89bc9-31cd-4268-a509-dcf573ad5cbc
# ╠═539aeec8-76ab-11eb-32a3-95c6672a0ea9
# ╠═81a00b78-76ab-11eb-072a-6b96847c2ce4
# ╠═2369fb18-76ab-11eb-1189-85309c8f925b
# ╠═98498f84-76ab-11eb-23cf-857c776a9163
# ╠═c6c860a6-76ab-11eb-1dec-1b2f179a0fa9
# ╠═f07fbc6c-76ab-11eb-3382-87c7d65b4078
# ╠═f4fa8c1a-76ab-11eb-302d-bd410432e3cf
# ╟─b3faf4d8-76ac-11eb-0be9-7dda3d37aba0
# ╠═71c074f0-76ac-11eb-2164-c36381212bff
# ╟─f72db3ea-2ffe-4765-a035-ebbbe399abb8
# ╠═87b99c8a-76ac-11eb-1c94-8f1ffe3be593
# ╟─504076fc-76ac-11eb-30c3-bfa75c991cb2
# ╟─44be265b-f7c2-43ee-b4e5-e6184deeb0d6
# ╠═02367402-9ff6-4659-9d78-4c281f898750
# ╟─f1dd24d8-76ac-11eb-1de7-a763a1b95668
# ╠═d42aec08-76ad-11eb-361a-a1f2c90fd4ec
# ╠═06437040-76ae-11eb-0b1c-23a6470f41c8
# ╟─28cd454c-76ae-11eb-0d1e-a56995100d59
# ╟─632a1f8c-76ae-11eb-2088-15c3e3c0a210
# ╠═8a99f186-76af-11eb-031b-f1c288993c7f
# ╟─df07d542-3238-4d92-bf83-1de3e9e42984
# ╟─f7df6cda-76b1-11eb-11e4-8d0af0349651
# ╠═8c6b0236-76b4-11eb-2acf-91da23bedf0e
# ╠═a397d526-76b5-11eb-3cce-4374e33324d1
# ╟─978fd5e2-7a9b-4979-bb81-cf126e0ae9e2
# ╠═bf23ab30-76b5-11eb-1adb-3d74a52cddfd
# ╠═d5d4ac48-76b6-11eb-1687-ed853c2db7c9
# ╟─89b2d570-76ba-11eb-0389-813bbb33efea
# ╠═a8c28578-76ba-11eb-3f3f-af35ff0b6c74
# ╠═d9e07084-76ba-11eb-18ac-c58b1bc972ba
# ╟─42172fb6-76b7-11eb-0a11-b7e10c6881f5
# ╠═57b0cd3c-76b7-11eb-0ece-810f3a8ede00
# ╟─0dcec07b-4622-4e9b-9c99-c2a2b04ee2db
# ╠═56f88155-890e-4129-926d-90c21a1907d8
# ╟─dd3095a1-abb2-4060-9651-db200dfe1dcf
# ╠═525d1b08-b8aa-4ffe-b5b3-f7ea5e343023
# ╟─6d411cea-76b9-11eb-061b-87d472bc3bdd
# ╟─bc2c6afc-76b7-11eb-0631-51f83cd73205
# ╠═ef06cfd8-76b7-11eb-1530-1fcd7e5c5992
# ╟─051db7a0-76b8-11eb-14c7-531f42ef60b8
# ╠═2705bf34-76b8-11eb-3aaa-d363085784ff
# ╟─dfb9d74c-76b8-11eb-24ff-e521f1294a6f
# ╟─a0afe3ae-76b9-11eb-2301-cde7260ddd7f
# ╟─ac1ab224-76bb-11eb-13cb-0bd44bea1042
# ╠═d364f91a-76b9-11eb-1807-75e733940d53
# ╟─77a4492c-cc79-4ace-b259-b9ee17737b1f
# ╠═f25c6308-76b9-11eb-3563-1f0ef4cdf86a
# ╟─db4bc328-76bb-11eb-28dc-eb9df8892d01
# ╟─f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
# ╠═78176284-76bc-11eb-3045-f584127f58b9
# ╟─bf28c388-76bd-11eb-08a7-af2671218017
# ╠═5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
# ╠═852592d6-76bd-11eb-1265-5f200e39113d
# ╠═8e36f4a2-76bd-11eb-2fda-9d1424752812
# ╟─09ed6d38-76be-11eb-255b-3fbf76c21097
# ╟─46a36183-f2f9-46cf-8bd9-999e083a6cbf
# ╠═9786e2be-76be-11eb-3755-b5669c37aa64
# ╟─963694d6-76be-11eb-1b27-d5d063964d24
# ╠═b78ef2fe-76be-11eb-1f55-3d0874b298e8
# ╟─ad728ee6-7639-11eb-0b23-c37f1366fb4e
# ╟─40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╟─c0c90fec-0e55-4be3-8ea2-88b8705ee258
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╟─ce55beee-7643-11eb-04bc-b517703facff
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╠═ed3caab2-76bf-11eb-2544-21e8181adef5
# ╠═8e0505be-359b-4459-9de3-f87ec7b60c23
# ╟─488d732c-7631-11eb-38c3-e9a9165d5606
# ╟─2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╟─60532aa0-740c-11eb-0402-af8ff117f042
# ╟─3e132708-e7af-4fb7-b828-882c5123bdac
# ╠═f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
