### A Pluto.jl notebook ###
# v0.19.5

using Markdown
using InteractiveUtils

# ╔═╡ a2370118-e314-400b-b8ed-2354f4524b8f
begin 
	using PlutoUI
	PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 2c6cbae3-a506-4c7a-8ee6-a8a8241afecc
md"""
# [Elementi di Modellizzazione Computazionale in Julia (2022)](https://natema.github.io/ECMJ-it-2022/)

### [Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/)
"""

# ╔═╡ 754b5737-84ef-4ef2-972c-c4bbe275894a
md"""
La presente pagina presenta brevemente il contentuo del corso *Elementi di Modellizzazione Computazionale in Julia* presso il [Corso di Laurea Triennale in Informatica dell'Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/), e raccoglie i link alle lezioni. 
Il corso si basa largamente sul materiale del corso [*Introduction to Computational Thinking* del MIT (2021)](https://computationalthinking.mit.edu/Spring21/).

Per riportare errori o proporre miglioramenti, non esitate ad aprire un _issue_ sulla  [pagina Github del materiale](https://github.com/natema/ECMJ-it), dove potete anche  mettere una stella nel caso in cui il materiale vi piaccia. 
"""

# ╔═╡ 30549592-8213-4de9-b495-7a705d49c4b3
md"""
### Di cosa tratta il corso?

La scienza conosce la realtà attraverso la concezione di modelli che permettono di spiegare e prevedere l'osservazione del mondo reale. Il calcolo delle implicazioni di un modello scientifico è ciò che chiamiamo simulazione. I primi computer sono stati inventati espressamente al fine di eseguire simulazioni in modo veloce e affidabile, permettendo così l'indagine di modelli complessi. La disciplina matematica che studia l'uso dei computer a tal fine è oggi nota col nome di [calcolo scientifico](https://en.wikipedia.org/wiki/Computational_science). L'obiettivo di questo corso è di introdurre lo studente ad alcune idee fondamentali alla base della modellizazione computazionale, esplorandole in modo pratico e interattivo attraverso il moderno [linguaggio di programmazione Julia](https://julialang.org/).

![Wikipedia simulation image](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Atmosphere_composition_diagram-en.svg/1920px-Atmosphere_composition_diagram-en.svg.png)
"""

# ╔═╡ 458e2b2b-55bb-420c-953d-827e379d673a
md"""
## Syllabus
"""

# ╔═╡ 87386680-49f5-43fc-b573-43b2dd09be10
md"""
### Lezione 0

- 0.0. [Presentazione del corso e programma](https://natema.github.io/ECMJ-it-2022/index.html)
- 0.1. [Installazione di Julia e uso dei notebook Pluto](https://natema.github.io/ECMJ-it-2022/lectures/lezione_0.1_-_installare_julia_e_pluto.jl.html)
- 0.2. [Introduzione al linguaggio Julia](https://natema.github.io/ECMJ-it-2022/lectures/lezione_0.2_-_introduzione_a_julia.jl.html)
- 0.3 [Come produrre grafici](https://natema.github.io/ECMJ-it-2022/lectures/lezione_0.3_come_produrre_grafici.jl.html)
- 0.4 [Esercitazione 0](https://natema.github.io/ECMJ-it-2022/lectures/lezione_0.4_esercitazione.jl.html)
"""

# ╔═╡ 0ed9194c-47bd-46f8-8881-1a62e90057c5
md"""
### Lezione 1

- 1.0. [Immagini come array](https://natema.github.io/ECMJ-it-2022/lectures/lezione_1.0_immagini_come_array.jl.html)
- 1.1. [Introduzione al concetto di astrazione](https://natema.github.io/ECMJ-it-2022/lectures/lezione_1.1_introduzione_al_concetto_di_astrazione.jl.html)
- 1.2. [Esercitazione 1](https://natema.github.io/ECMJ-it-2022/lectures/lezione_1.2_esercitazione.jl.html)
"""

# ╔═╡ e828a20d-5d8e-4bde-bfb2-99f8a634182c
md"""
### Lezione 2 

- 2.0. [Trasformazione di immagini](https://natema.github.io/ECMJ-it-2022/lectures/lezione_2.0_trasformazione_di_immagini.jl.html)
- 2.1. [Trasformazioni lineari](https://natema.github.io/ECMJ-it-2022/lectures/lezione_2.1_trasformazioni_lineari.jl.html)
"""

# ╔═╡ 22c1247c-678a-4c75-ad55-301f1bf0b4d7
md"""
### Lezione 3

- 2.2. [Trasformazioni e differenziazione automatica](https://natema.github.io/ECMJ-it-2022/lectures/lezione_2.2_trasformazioni_e_differenziazione_automatica.jl.html)
- 3.0 [Altre trasformazioni](https://natema.github.io/ECMJ-it-2022/lectures/lezione_3.0_altre_trasformazioni.jl.html)
"""

# ╔═╡ 046a0d16-eb6f-48da-936c-cddf015b4f2b
md"""
### Lezione 4

- 3.1. [Il metodo di Newton](https://natema.github.io/ECMJ-it-2022/lectures/lezione_3.1_il_metodo_di_newton.jl)
"""

# ╔═╡ 20469a84-0122-459e-81f1-8f43c93aea69
md"""
### Lezione 5 

- 5.0. [Graph Mining in Julia](https://github.com/piluc/GraphMining) by [Pierluigi Crescenzi](https://en.wikipedia.org/wiki/Pierluigi_Crescenzi)
"""

# ╔═╡ 25c62482-13e0-4a0c-b84c-cf70bace1bb9
md"""
### Lezione 6

- 4.0 [Programmazione dinamica](https://natema.github.io/ECMJ-it-2022/lectures/lezione_4.0_programmazione_dinamica.jl)
- 4.1 [Seam carving](https://natema.github.io/ECMJ-it-2022/lectures/lezione_4.1_seam_carving.jl)
"""

# ╔═╡ 0badf048-88a1-45f3-b5ad-b964bca9d1c0
md"""
### Lezione 7
- 4.2 [Strutture](https://natema.github.io/ECMJ-it-2022/lectures/lezione_4.2_strutture.jl)
"""

# ╔═╡ 5ebf6539-001d-4505-a6f3-6b755360b3cd
md"""
### Lezione 8
- 5.1 [Variabili aleatorie](https://natema.github.io/ECMJ-it-2022/lectures/lezione_5.1_variabili_aleatorie.jl)
"""

# ╔═╡ 5b2bdd22-b39c-4e31-9058-c97a44b541d8
md"""
### Lezione 9 
- 5.0 [Analisi delle componenti principali](https://natema.github.io/ECMJ-it-2022/lectures/lezione_5.0_pca.jl)
- 6.0. [Simulare il guasto di componenti](https://natema.github.io/ECMJ-it-2022/lectures/lezione_6.0_simulare_il_guasto_di_componenti.jl)
"""

# ╔═╡ cdcc67c2-181a-4c77-b1a2-7a24f09cbb6c
md"""
### Lezione 10 
Ultima lezione!
- 12.0. [Un primo modello climatico](https://natema.github.io/ECMJ-it-2022/lectures/lezione_12.0_un_primo_modello_climatico.jl.html)
"""

# ╔═╡ f3320888-02a0-48b5-a206-d5a712ca262e
md"""
## Come proseguire?

Gli studenti interessati a un corso più avanzato sull'utilizzo di Julia per calcolo scientifico possono consultare il [materiale del corso ECMJ 2022 al Gran Sasso Science Institute](https://natema.github.io/ECMJ-GSSI-2022/). 
"""

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

julia_version = "1.7.3"
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
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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
# ╟─2c6cbae3-a506-4c7a-8ee6-a8a8241afecc
# ╟─a2370118-e314-400b-b8ed-2354f4524b8f
# ╟─754b5737-84ef-4ef2-972c-c4bbe275894a
# ╟─30549592-8213-4de9-b495-7a705d49c4b3
# ╟─458e2b2b-55bb-420c-953d-827e379d673a
# ╟─87386680-49f5-43fc-b573-43b2dd09be10
# ╟─0ed9194c-47bd-46f8-8881-1a62e90057c5
# ╟─e828a20d-5d8e-4bde-bfb2-99f8a634182c
# ╟─22c1247c-678a-4c75-ad55-301f1bf0b4d7
# ╟─046a0d16-eb6f-48da-936c-cddf015b4f2b
# ╟─20469a84-0122-459e-81f1-8f43c93aea69
# ╟─25c62482-13e0-4a0c-b84c-cf70bace1bb9
# ╟─0badf048-88a1-45f3-b5ad-b964bca9d1c0
# ╟─5ebf6539-001d-4505-a6f3-6b755360b3cd
# ╟─5b2bdd22-b39c-4e31-9058-c97a44b541d8
# ╟─cdcc67c2-181a-4c77-b1a2-7a24f09cbb6c
# ╟─f3320888-02a0-48b5-a206-d5a712ca262e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
