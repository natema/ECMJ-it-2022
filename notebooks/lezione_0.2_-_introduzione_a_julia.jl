### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 6d725713-d9bf-4329-9fe6-c489f0fb9942
begin 
	using PlutoUI
	PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 73de5553-fb0a-47ec-b874-8292d8b5e11c
md"""
## [Elementi di Modellizzazione Computazionale in Julia](http://www.informatica.uniroma2.it/f0?fid=220&srv=0&os=2021&cdl=0&id=ECMJ)

##### [Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/), 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)
"""

# ╔═╡ ed2aec33-7f44-4269-86e6-35056684f215
md"""

# Lezione 0.2  - Introduzione al linguaggio Julia

In questa lezione familizzieremo col linguaggio [Julia](https://en.wikipedia.org/wiki/Julia_(programming_language)). 
Il linguaggio è stato ideato con l'obiettivo di creare un moderno linguaggio di programmazione per il [calcolo scientifico](https://en.wikiversity.org/wiki/Scientific_computing), mirando ad offrire la facilità d'uso del linguaggio Python con l'efficienza del linguaggio C. 
Come vedremo, molte caratteristiche del linguaggio lo rendono molto naturale dal punto di vista *matematico*. 
"""

# ╔═╡ 3b038ee0-edeb-11ea-0977-97cc30d1c6ff
md"## Variabili

Possiamo definire variabili usando l'operatore di assegnazione *uguale* `=`, ed utilizzare tale valore in altre espressioni:
"

# ╔═╡ 3e8e0ea0-edeb-11ea-22e0-c58f7c2168ce
x = 21

# ╔═╡ 5f85240f-835c-4703-8532-7ac3c641b032
md"""
Notare che per moltiplicare una variabile per un numero, non è necessario utilizzare il simbolo `*` come in altri linguaggi: 
"""

# ╔═╡ 59b66862-edeb-11ea-2d62-71dcc79dbfab
y = 2x

# ╔═╡ 8db1444f-3878-44cd-8a53-82b96be0cad8
md"""
Se vogliamo dire a Julia di non mostrare il risultato dell'ultima operazione, possiamo terminare la riga con `;`: 
"""

# ╔═╡ 1c6ea2dd-2530-448c-a759-0568101216b6
z = 2x;

# ╔═╡ 7e46f0e8-edeb-11ea-1092-4b5e8acd9ee0
md"""
Possiamo chiedere il **tipo** di una variabile utilizzando la funzione `typeof`: 
"""

# ╔═╡ 8a695b86-edeb-11ea-08cc-17263bec09df
typeof(y)

# ╔═╡ 18e56fcf-1735-42eb-860e-6c0e73d16169
md"""
### Nota sulle celle dei Pluto notebook

Pluto prevede una singola *espressione* per cella. 
"""

# ╔═╡ 0996c16e-22b9-4d84-8c58-dec3451d85ce
a = 2^3
b = 8a

# ╔═╡ 074e658e-2ea0-41f2-8ee8-1b2270447b7e
md"""
Come suggerito da Pluto stesso, nel caso in cui vogliamo avere più di un'espressione per cella, possiamo racchiuderle in un *blocco* delimitato dalle keyword `begin` ed `end`. 
"""

# ╔═╡ b5c547c9-8400-4054-9370-b0479f74d9f1
begin
	c = 2^3
	d = 8c  
	d # equivalente a `return s`
end

# ╔═╡ 4fce2689-2986-4e5c-92fb-e5508d71df84
md"""
In alternativa, possiamo utilizzare un blocco 
```jl
let ... 
	...
end
``` 
per definire una variabile locale: 
"""

# ╔═╡ 7bbb87fc-23fd-49e5-b1ff-cdde001a10ed
let a = 7 # a è una variabile locale
	b = 24
	a*b
end

# ╔═╡ 652d09f1-a6a4-4dba-873f-ec5c54c207ef
md"""
### Notazione matematica in Julia

Il linguaggio Julia supporta l'uso di caratteri [unicode](https://en.wikipedia.org/wiki/Unicode), molti dei quali possono essere inseriti in Pluto scrivendo il corrispondente comando [LaTeX](https://en.wikipedia.org/wiki/LaTeX) seguito dal tasto `Tab`; in modo simile, possiamo anche creare pedici e apici: 
"""

# ╔═╡ 5dba6c47-bd2d-43a1-b438-895c86481453
begin
	α₁ = 7 # α₁ si ottiene digitando `\alpha`, premendo `Tab`, digitando `\_1` e premendo di nuovo `Tab`
	α₂ = 6 # α₂ si ottiene similmente, inserendo α e poi digitando `\_2` seguito da `Tab`
	α₁ * α₂
end

# ╔═╡ 90d133df-33a7-4954-a66b-e153e598b8df
md"""
Possiamo assegnare più valori contemporaneamente separando i nomi delle variabili e i valori assegnati tramite virgole: 
"""

# ╔═╡ e047fcc6-33c7-480e-9f63-4c6ebbd78d30
begin
	β₁, β₂, β₃ = 0.1, 2.0, 2.1
	β₁ + β₂ + β₃
end

# ╔═╡ f594175e-c787-4b94-ac9a-48fda56c1bd5
md"""
Poiché Julia supporta caratteri unicode, espressioni come le seguenti sono valide: 
"""

# ╔═╡ cd36b4b2-0995-467b-a9b4-dce24fede0fb
begin
	🐱, 🦁 = 12, 96
	👑 = 🦁 - 🐱  
	👑
end

# ╔═╡ ac5ecd3e-4ada-4fb0-9fc5-1d3743212b21
begin 
	🧀, 🐭, 🐶 = 5, 35, 7000
	🦴 = 🧀/🐭 * 🐶 
	🦴
end

# ╔═╡ 8e2dd3be-edeb-11ea-0703-354fb31c12f5
md"## Funzioni"

# ╔═╡ 96b5a28c-edeb-11ea-11c0-597615962f54
md"""
Per funzioni semplici, possiamo definirle in *short-form* utilizzando una singola riga: 
"""

# ╔═╡ a7453572-edeb-11ea-1e27-9f710fd856a6
f(x) = 2 + x

# ╔═╡ b341db4e-edeb-11ea-078b-b71ac00089d7
md"""
Scrivendo il *nome* di una funzione, otteniamo informazioni su di essa, mentre per *chiamarla* occorre aggiungervi le parentesi tonde:
"""

# ╔═╡ 23f9afd4-eded-11ea-202a-9f0f1f91e5ad
f

# ╔═╡ cc1f6872-edeb-11ea-33e9-6976fd9b107a
f(11)

# ╔═╡ ce9667c2-edeb-11ea-2665-d789032abd11
md"""
Per funzioni più complesse, si utilizzano le *keyword* `function` e `end` con la seguente sintassi: 
"""

# ╔═╡ d73d3400-edeb-11ea-2dea-95e8c4a6563b
function g(x, y)
	z = x + y
	return z^2
end

# ╔═╡ e04ccf10-edeb-11ea-36d1-d11969e4b2f2
g(3, 13)

# ╔═╡ e297c5cc-edeb-11ea-3bdd-090f415685ab
md"""
## Cicli `for`
"""

# ╔═╡ ec751446-edeb-11ea-31ba-2372e7c71b42
md"""
Per iterare su un insieme predeterminato di valori, usiamo la keyword `for`. 
"""

# ╔═╡ fe3fa290-edeb-11ea-121e-7114e5c573c1
let s = 0
	for i in 1:10
		s += i    # equivalente a `s = s + i`
	end
	s
end

# ╔═╡ 394b0ec8-eded-11ea-31fb-27392068ef8f
md"`1:10` è un *range* che rappresenta i numeri da 1 a 10:"

# ╔═╡ 4dc00908-eded-11ea-25c5-0f7b2b7e18f9
typeof(1:10)

# ╔═╡ 6c44abb4-edec-11ea-16bd-557800b5f9d2
md"""
Sopra, abbiamo usato un blocco `let` per definire una variabile locale `s`, tuttavia tali blocchi risultano spesso più utili all'interno di una funzione che ne permette il riutilizzo, per esempio: 
"""

# ╔═╡ 683af3e2-eded-11ea-25a5-0d90bf099d98
function mysum(n)
	s = 0
	
	for i in 1:n
		s += i    
	end
	
	return s
end

# ╔═╡ 76764ea2-eded-11ea-1aa6-296f3421de1c
mysum(100)

# ╔═╡ 93a231f4-edec-11ea-3b39-299b3be2da78
md"## Struttura condizionale `if`"

# ╔═╡ 82e63a24-eded-11ea-3887-15d6bfabea4b
md"""
Possiamo calcolare se una condizione è vera o meno semplicemente scrivendola:
"""

# ╔═╡ 9b339b2a-eded-11ea-10d7-8fc9a907c892
begin
	a = 3
	a < 5
end

# ╔═╡ a16299a2-eded-11ea-2b56-93eb7a1010a7
md"""
Le condizioni hanno un valore booleano, `true` o `false`, e possono essere usate con `if` per decidere quali operazioni effettuare sulla base del loro valore: 
"""

# ╔═╡ bc6b124e-eded-11ea-0290-b3760cb81024
if a < 5
	"small"
else
	"big"
end

# ╔═╡ cfb21014-eded-11ea-1261-3bc30952a88e
md"""
Osserviamo che `if` restituisce il valore dell'ultima espressione valutata, in questo caso la stringa `"small"` o `"big"`. 
Inoltre, Pluto è un notebook *reattivo*, e se cambiamo la definizione di `a` sopra, l'output sarà automaticamente ri-calcolato.
"""

# ╔═╡ ffee7d80-eded-11ea-26b1-1331df204c67
md"## Array"

# ╔═╡ cae4137e-edee-11ea-14af-59a32227de1b
md"### Array 1-dimensionali (`Vector`)"

# ╔═╡ 714f4fca-edee-11ea-3410-c9ab8825d836
md"""
Possiamo costruire un *vettore* (o array 1-dimensionale), racchiudendo una lista di numeri tra parentesi quadre:
"""

# ╔═╡ 82cc2a0e-edee-11ea-11b7-fbaa5ad7b556
v = [1, 2, 3]

# ╔═╡ 85916c18-edee-11ea-0738-5f5d78875b86
typeof(v)

# ╔═╡ 881b7d0c-edee-11ea-0b4a-4bd7d5be2c77
md"""
Il numero `1` nella descrizione del tipo mostra che si tratta di un array 1-dimensionale. 

Possiamo accedere agli elementi dell'array fornendo, tra parentesi quadre, l'indice dell'elemento:
"""

# ╔═╡ a298e8ae-edee-11ea-3613-0dd4bae70c26
v[2]

# ╔═╡ a5ebddd6-edee-11ea-2234-55453ea59c5a
v[2] = 10

# ╔═╡ a9b48e54-edee-11ea-1333-a96181de0185
md"""
(Notare che Pluto non aggiorna automaticamente le celle quando modifichiamo gli elementi di un array.)
"""

# ╔═╡ 68c4ead2-edef-11ea-124a-03c2d7dd6a1b
md"""
Un modo di creare `Vector` che seguono un certo pattern è quello di usare l'**array comprehension**: 
"""

# ╔═╡ 84129294-edef-11ea-0c77-ffa2b9592a26
v2 = [i^2 for i in 1:10]

# ╔═╡ d364fa16-edee-11ea-2050-0f6cb70e1bcf
md"## Array bidimensionali (matrici)"

# ╔═╡ db99ae9a-edee-11ea-393e-9de420a545a1
md"""
Possiamo creare delle matrici elencando gli elementi tra parentesi quadre in più righe:
"""

# ╔═╡ 04f175f2-edef-11ea-0882-712548ebb7a3
M = [1 2
	 3 4]

# ╔═╡ 0a8ac112-edef-11ea-1e99-cf7c7808c4f5
typeof(M)

# ╔═╡ 1295f48a-edef-11ea-22a5-61e8a2e1d005
md"""
Il `2` nel nome del tipo ci conferma che si tratta di un array bidimensionale. 
"""

# ╔═╡ 3e1fdaa8-edef-11ea-2f03-eb41b2b9ea0f
md"""
Notare che dichiarare la matrice esplicitamente sarebbe un approccio molto inefficiente per matrici molto larghe. Per costruire quest'ultime, possiamo utilizzare delle funzioni specifiche, per esempio
"""

# ╔═╡ 48f3deca-edef-11ea-2c18-e7419c9030a0
zeros(5, 5)

# ╔═╡ a8f26af8-edef-11ea-2fc7-2b776f515aea
md"""
La funzione `zeros` crea di default una matrice le cui entrate sono di tipo `Float64`. Possiamo specificare un tipo diverso fornendolo come primo argomento:
"""

# ╔═╡ b595373e-edef-11ea-03e2-6599ef14af20
zeros(Int, 4, 5)

# ╔═╡ 4cb33c04-edef-11ea-2b35-1139c246c331
md"""
Una volta creata la matrice, possiamo cambiarne i valori iterando sui suoi elementi, per esempio tramite un ciclo `for`. 
Una pratica alternativa consiste nell'utilizzare l'array comprehension che abbiamo appena visto per gli array 1-dimensionali: 
"""

# ╔═╡ 6348edce-edef-11ea-1ab4-019514eb414f
[i + j for i in 1:5, j in 1:6]

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─73de5553-fb0a-47ec-b874-8292d8b5e11c
# ╟─6d725713-d9bf-4329-9fe6-c489f0fb9942
# ╟─ed2aec33-7f44-4269-86e6-35056684f215
# ╟─3b038ee0-edeb-11ea-0977-97cc30d1c6ff
# ╠═3e8e0ea0-edeb-11ea-22e0-c58f7c2168ce
# ╟─5f85240f-835c-4703-8532-7ac3c641b032
# ╠═59b66862-edeb-11ea-2d62-71dcc79dbfab
# ╟─8db1444f-3878-44cd-8a53-82b96be0cad8
# ╠═1c6ea2dd-2530-448c-a759-0568101216b6
# ╟─7e46f0e8-edeb-11ea-1092-4b5e8acd9ee0
# ╠═8a695b86-edeb-11ea-08cc-17263bec09df
# ╟─18e56fcf-1735-42eb-860e-6c0e73d16169
# ╠═0996c16e-22b9-4d84-8c58-dec3451d85ce
# ╟─074e658e-2ea0-41f2-8ee8-1b2270447b7e
# ╠═b5c547c9-8400-4054-9370-b0479f74d9f1
# ╟─4fce2689-2986-4e5c-92fb-e5508d71df84
# ╠═7bbb87fc-23fd-49e5-b1ff-cdde001a10ed
# ╟─652d09f1-a6a4-4dba-873f-ec5c54c207ef
# ╠═5dba6c47-bd2d-43a1-b438-895c86481453
# ╟─90d133df-33a7-4954-a66b-e153e598b8df
# ╠═e047fcc6-33c7-480e-9f63-4c6ebbd78d30
# ╟─f594175e-c787-4b94-ac9a-48fda56c1bd5
# ╠═cd36b4b2-0995-467b-a9b4-dce24fede0fb
# ╠═ac5ecd3e-4ada-4fb0-9fc5-1d3743212b21
# ╟─8e2dd3be-edeb-11ea-0703-354fb31c12f5
# ╟─96b5a28c-edeb-11ea-11c0-597615962f54
# ╠═a7453572-edeb-11ea-1e27-9f710fd856a6
# ╟─b341db4e-edeb-11ea-078b-b71ac00089d7
# ╠═23f9afd4-eded-11ea-202a-9f0f1f91e5ad
# ╠═cc1f6872-edeb-11ea-33e9-6976fd9b107a
# ╟─ce9667c2-edeb-11ea-2665-d789032abd11
# ╠═d73d3400-edeb-11ea-2dea-95e8c4a6563b
# ╠═e04ccf10-edeb-11ea-36d1-d11969e4b2f2
# ╟─e297c5cc-edeb-11ea-3bdd-090f415685ab
# ╟─ec751446-edeb-11ea-31ba-2372e7c71b42
# ╠═fe3fa290-edeb-11ea-121e-7114e5c573c1
# ╟─394b0ec8-eded-11ea-31fb-27392068ef8f
# ╠═4dc00908-eded-11ea-25c5-0f7b2b7e18f9
# ╟─6c44abb4-edec-11ea-16bd-557800b5f9d2
# ╠═683af3e2-eded-11ea-25a5-0d90bf099d98
# ╠═76764ea2-eded-11ea-1aa6-296f3421de1c
# ╟─93a231f4-edec-11ea-3b39-299b3be2da78
# ╟─82e63a24-eded-11ea-3887-15d6bfabea4b
# ╠═9b339b2a-eded-11ea-10d7-8fc9a907c892
# ╟─a16299a2-eded-11ea-2b56-93eb7a1010a7
# ╠═bc6b124e-eded-11ea-0290-b3760cb81024
# ╟─cfb21014-eded-11ea-1261-3bc30952a88e
# ╟─ffee7d80-eded-11ea-26b1-1331df204c67
# ╟─cae4137e-edee-11ea-14af-59a32227de1b
# ╟─714f4fca-edee-11ea-3410-c9ab8825d836
# ╠═82cc2a0e-edee-11ea-11b7-fbaa5ad7b556
# ╠═85916c18-edee-11ea-0738-5f5d78875b86
# ╟─881b7d0c-edee-11ea-0b4a-4bd7d5be2c77
# ╠═a298e8ae-edee-11ea-3613-0dd4bae70c26
# ╠═a5ebddd6-edee-11ea-2234-55453ea59c5a
# ╟─a9b48e54-edee-11ea-1333-a96181de0185
# ╟─68c4ead2-edef-11ea-124a-03c2d7dd6a1b
# ╠═84129294-edef-11ea-0c77-ffa2b9592a26
# ╟─d364fa16-edee-11ea-2050-0f6cb70e1bcf
# ╟─db99ae9a-edee-11ea-393e-9de420a545a1
# ╠═04f175f2-edef-11ea-0882-712548ebb7a3
# ╠═0a8ac112-edef-11ea-1e99-cf7c7808c4f5
# ╟─1295f48a-edef-11ea-22a5-61e8a2e1d005
# ╟─3e1fdaa8-edef-11ea-2f03-eb41b2b9ea0f
# ╠═48f3deca-edef-11ea-2c18-e7419c9030a0
# ╟─a8f26af8-edef-11ea-2fc7-2b776f515aea
# ╠═b595373e-edef-11ea-03e2-6599ef14af20
# ╟─4cb33c04-edef-11ea-2b35-1139c246c331
# ╠═6348edce-edef-11ea-1ab4-019514eb414f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
