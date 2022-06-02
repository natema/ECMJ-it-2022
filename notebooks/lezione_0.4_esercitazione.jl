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

# ╔═╡ 851c03a4-e7a4-11ea-1652-d59b7a6599f0
# configurazione di un package environment
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.Registry.update()
end

# ╔═╡ d6ee91ea-e750-11ea-1260-31ebf3ec6a9b
# aggiungiamo il package _Compose.jl_ all'environment corrente
begin
	Pkg.add("Compose")
	# chiamiamo il package utilizzando `using` in modo da poterne usare le funzioni direttamente nel codice
	using Compose
end

# ╔═╡ 5acd58e0-e856-11ea-2d3d-8329889fe16f
# riaggiungiamo anche il pacchetto _PlutoUI_
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ 42448984-e662-4b53-b425-2ad71e3b31b9
md"""
## [Elementi di Modellizzazione Computazionale in Julia](https://natema.github.io/ECMJ-it-2022/)

#### 

[Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)
"""

# ╔═╡ 5294d5d4-9987-4963-9cc3-f733e7488a4e
md"""
Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it-2022), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ 46d0df32-75e8-4dae-9324-86e8bddcaea5
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 2eedd484-82cc-43a8-a64d-45dce70cd6d3
md"""
# Esercitazione 0.4: Primi passi

## Esercizio 0

Calcolare il quadrato di un numero è facile: basta moltiplicare il numero per se stesso. 

#### Algoritmo: Quadrato
####

Input: $x$

Output: $x^2$

1. Moltiplicare `x` per `x`
"""

# ╔═╡ e02f7ea6-7024-11eb-3672-fd59a6cff79b
function basic_square(x)
	return 1 # Questo è sbagliato, scrivere un'implementazione corretta. 
end

# ╔═╡ 6acef56c-7025-11eb-2524-819c30a75d39
let result = basic_square(5)
	if !(result isa Number)
		md"""
!!! warning "Not a number"
    `basic_square` non restituisce un numero: potresti aver dimenticato di restituire il valore finale. 
		"""
	elseif abs(result - 5*5) < 0.01
		md"""
!!! Corretto
    La soluzione è corretta.
		"""
	else
		md"""
!!! warning "Soluzione errata"
    La soluzione proposta contiene degli errori. 
		"""
	end
end

# ╔═╡ 339c2d5c-e6ce-11ea-32f9-714b3628909c
md"## Esercizio 1 - _Radice quadrata tramite metodo di Newton_

Come abbiamo appena visto, calcolare il quadrato di un numero è semplice. 
Ma come calcolarne la radice?

#### Algoritmo: Radice
####

Input: $x$

Output: $\sqrt{x}$

1. Indovinare un valore `a`
1. Dividere `x` per `a`
1. Porre `a =` the average of `x/a` and `a`. (La radice deve trovarsi tra questi due numeri... Perché?)
1. Ripetere finché `x/a` è approssimativamente uguale a `a`. 
Restituire `a` come radice quadrata.

In generale, non si arriverà mai al punto in cui `x/a` è _esattamente_ uguale ad `a`. Dunque, se il nostro algoritmo venisse eseguito finché `x/a == a`, non terminerebbe.

Pertanto, l'algoritmo prende in input un `error_margin`, che viene usato per decidere se `x/a` ed `a` sono sufficientemente simili da poter terminare l'algoritmo.
"

# ╔═╡ 56866718-e6ce-11ea-0804-d108af4e5653
md"### Esercizio 1.1

Al passo 3 dell'algoritmo sopra, si pone la *guess* `a` uguale alla media tra `a` e `x/a`.
Dimostrare la correttezza di questo passo, argomentando perché la radice quadrata deve necessariamente trovarsi tra `x/a` ed `a`. 

"

# ╔═╡ d62f223c-e754-11ea-2470-e72a605a9d7e
md"### Esercizio 1.2
Scrivere una funzione `newton_sqrt(x)` che implementa l'algoritmo precedente:
"

# ╔═╡ 4896bf0c-e754-11ea-19dc-1380bb356ab6
function newton_sqrt(x, error_margin=0.01, a=x / 2) # a=x/2 è il valore di default per `a`
	error # scrivere qui il proprio codice
end

# ╔═╡ 7a01a508-e78a-11ea-11da-999d38785348
newton_sqrt(2)

# ╔═╡ 682db9f8-e7b1-11ea-3949-6b683ca8b47b
let
	result = newton_sqrt(2, 0.01)
	if !(result isa Number)
		md"""
!!! warning "Not a number"
    `newton_sqrt` non restituisce un numero. È possibile che ci si sia dimenticati di restituire il valore finale. 
		"""
	elseif abs(result - sqrt(2)) < 0.01
		md"""
!!! Corretto
    gg!
		"""
	else
		md"""
!!! warning "Sbagliato"
    Bisogna lavorci di più. 
		"""
	end
end

# ╔═╡ 088cc652-e7a8-11ea-0ca7-f744f6f3afdd
md"""
!!! hint
    `abs(r - s)` è la distanza tra `r` e `s`
"""

# ╔═╡ c18dce7a-e7a7-11ea-0a1a-f944d46754e5
md"""
!!! hint
    Se siete bloccati, sentitevi liberire di barare: in fin dei conti gli esercizi sono falcoltativi 🙃

    Julia ha una funzione `sqrt`
"""

# ╔═╡ 5e24d95c-e6ce-11ea-24be-bb19e1e14657
md"## Esercizio 2 - _Il triangolo di Sierpinski_

![](https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/SierpinskiTriangle.svg/1024px-SierpinskiTriangle.svg.png)

Il [triangolo di Sierpinski](https://it.wikipedia.org/wiki/Triangolo_di_Sierpi%C5%84ski) può essere informalmente descritto ricorsivamente come segue: 
- Il triangolo di Sierpinski di ordine $0$ è un triangolo equilatero. 
- Il triangolo di Sierpinski di ordine $N$ è ottenuto come unione di 3 triangoli di Sierpinski di ordine $N-1$.
"

# ╔═╡ 6b8883f6-e7b3-11ea-155e-6f62117e123b
md"""
Julia offre un vasto [ecosistema di package](https://juliahub.com/ui/Home).
Un package contiene un insieme coerente di funzioni che possono essere usate come *black box* per un certo scopo. 

Per disegnare un triangolo di Sierpinski, utilizzeremo il package [_Compose.jl_](https://giovineitalia.github.io/Compose.jl/latest/tutorial). 
Anzitutto, creiamo un [*package environment*](https://pkgdocs.julialang.org/v1/environments/) al quale aggiungere _Compose.jl_. 
(In alternativa, possiamo saltare il prossimo passaggio e installare _Compose.jl_ direttamente nell'environment di default.)
"""

# ╔═╡ dbc4da6a-e7b4-11ea-3b70-6f2abfcab992
md"""
Possiamo ora implementare la costruzione del triangolo di Sierpinski. 
Seguendo la precedente descrizione informale, la nostra funzione `sierpinski` è _ricorsiva_, ovvero chiama se stessa. 
"""

# ╔═╡ e824e297-fa6e-40db-9ce2-f1f24e0658ac
complexity = 4

# ╔═╡ 1eb79812-e7b5-11ea-1c10-63b24803dd8a
if complexity == 3 
	md"""
	Possiamo provare a cambiare il valore di **`complexity` a `5`** nella cella sopra.
	"""
else
	md"""
 	Bene, il valore di **`complexity` è stato cambiato**. Come possiamo vedere, tutte le celle legate a tale valore sono automaticamente aggiornate. 
	"""
end

# ╔═╡ d7e8202c-e7b5-11ea-30d3-adcd6867d5f5
md"### Esercizio 2.1

Come si può vedere dal seguente esempio (che fa uso dell'operatore di broadcasting e dei *range*), l'area totale coperta dai triangoli diminuisce all'aumentare dell'ordine."

# ╔═╡ f22222b4-e7b5-11ea-0ea0-8fa368d2a014
md"""
Si provi ora a scrivere una funzione che calcola l'_area di `sierpinski(n)`_, come frazione di quella del triangolo `sierpinski(0)`, ovvero:
```
area_sierpinski(0) = 1.0
area_sierpinski(1) = 0.??
...
```
"""

# ╔═╡ ca8d2f72-e7b6-11ea-1893-f1e6d0a20dc7
function area_sierpinski(n)
	return 1.0 # scrivere qui il proprio codice
end

# ╔═╡ 71c78614-e7bc-11ea-0959-c7a91a10d481
if area_sierpinski(0) == 1.0 && area_sierpinski(1) == 3 / 4
	md"""
!!! correct
    La soluzione è corretta.
	"""
else
	md"""
!!! warning "Sbagliato"
    La soluzione proposta contiene degli errori. 
	"""
end

# ╔═╡ c1ecad86-e7bc-11ea-1201-23ee380181a1
md"""
!!! hint
    Si può scrivere `area_sierpinksi(n)` come funzione di `area_sierpinski(n-1)`?
"""

# ╔═╡ c21096c0-e856-11ea-3dc5-a5b0cbf29335
@bind n Slider(0:6, show_value=true)

# ╔═╡ 5e3cde14-3503-4858-ba67-8deb12cf6b37
md"""
#### Proviamo ora a definire uno *slider* interattivo

Il triangolo di Sierpinski di ordine $(n) ha area $(area_sierpinski(n)). 
"""

# ╔═╡ dfdeab34-e751-11ea-0f90-2fa9bbdccb1e
triangle() = compose(context(), polygon([(1, 1), (0, 1), (1 / 2, 0)]))

# ╔═╡ b923d394-e750-11ea-1971-595e09ab35b5
# Non importa in quale ordine si definiscono gli elementi costitutivi (funzioni) del programma. Il modo migliore per organizzare il codice è quello che ne favorisce la comprensione.

function place_in_3_corners(t)
	# Usa la libreria Compose per collocare 3 copie di `t` nei 3 angoli di un triangolo. La funzione va usata come una black box, altrimenti si può consultare la documentazione di Compose https://giovineitalia.github.io/Compose.jl/latest/tutorial/#Compose-is-declarative-1
	compose(context(),
			(context(1 / 4,   0, 1 / 2, 1 / 2), t),
			(context(0, 1 / 2, 1 / 2, 1 / 2), t),
			(context(1 / 2, 1 / 2, 1 / 2, 1 / 2), t))
end

# ╔═╡ e2848b9a-e703-11ea-24f9-b9131434a84b
function sierpinski(n)
	if n == 0
		triangle()
	else
		t = sierpinski(n - 1) # costruisci ricorsivamente un triangolo di Sierpinski più piccolo
		place_in_3_corners(t) # posiziona il precedente triangolo nei tre angoli di un triangolo
	end
end

# ╔═╡ 1f19d981-2b57-4ade-87ba-c2232dc7b223
sierpinski(complexity)

# ╔═╡ df0a4068-e7b2-11ea-2475-81b237d492b3
sierpinski.(0:6) 

# ╔═╡ 8f492e37-171b-4e00-a7f8-c3c72d917edf
sierpinski(n)

# ╔═╡ Cell order:
# ╟─42448984-e662-4b53-b425-2ad71e3b31b9
# ╟─5294d5d4-9987-4963-9cc3-f733e7488a4e
# ╟─46d0df32-75e8-4dae-9324-86e8bddcaea5
# ╟─2eedd484-82cc-43a8-a64d-45dce70cd6d3
# ╠═e02f7ea6-7024-11eb-3672-fd59a6cff79b
# ╟─6acef56c-7025-11eb-2524-819c30a75d39
# ╟─339c2d5c-e6ce-11ea-32f9-714b3628909c
# ╟─56866718-e6ce-11ea-0804-d108af4e5653
# ╟─d62f223c-e754-11ea-2470-e72a605a9d7e
# ╠═4896bf0c-e754-11ea-19dc-1380bb356ab6
# ╠═7a01a508-e78a-11ea-11da-999d38785348
# ╟─682db9f8-e7b1-11ea-3949-6b683ca8b47b
# ╟─088cc652-e7a8-11ea-0ca7-f744f6f3afdd
# ╟─c18dce7a-e7a7-11ea-0a1a-f944d46754e5
# ╟─5e24d95c-e6ce-11ea-24be-bb19e1e14657
# ╟─6b8883f6-e7b3-11ea-155e-6f62117e123b
# ╠═851c03a4-e7a4-11ea-1652-d59b7a6599f0
# ╠═d6ee91ea-e750-11ea-1260-31ebf3ec6a9b
# ╠═5acd58e0-e856-11ea-2d3d-8329889fe16f
# ╟─dbc4da6a-e7b4-11ea-3b70-6f2abfcab992
# ╠═e2848b9a-e703-11ea-24f9-b9131434a84b
# ╠═e824e297-fa6e-40db-9ce2-f1f24e0658ac
# ╠═1f19d981-2b57-4ade-87ba-c2232dc7b223
# ╟─1eb79812-e7b5-11ea-1c10-63b24803dd8a
# ╟─d7e8202c-e7b5-11ea-30d3-adcd6867d5f5
# ╠═df0a4068-e7b2-11ea-2475-81b237d492b3
# ╟─f22222b4-e7b5-11ea-0ea0-8fa368d2a014
# ╠═ca8d2f72-e7b6-11ea-1893-f1e6d0a20dc7
# ╟─71c78614-e7bc-11ea-0959-c7a91a10d481
# ╟─c1ecad86-e7bc-11ea-1201-23ee380181a1
# ╟─5e3cde14-3503-4858-ba67-8deb12cf6b37
# ╠═c21096c0-e856-11ea-3dc5-a5b0cbf29335
# ╠═8f492e37-171b-4e00-a7f8-c3c72d917edf
# ╟─dfdeab34-e751-11ea-0f90-2fa9bbdccb1e
# ╟─b923d394-e750-11ea-1971-595e09ab35b5
