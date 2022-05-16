### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 788930f0-f646-4266-9bd9-768c3956ea99
begin 
	using PlutoUI
	PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 2c6cbae3-a506-4c7a-8ee6-a8a8241afecc
md"""
## Elementi di Modellizzazione Computazionale in Julia

### 2022, [Università degli Studi di Roma "Tor Vergata"](http://www.informatica.uniroma2.it/)

"""

# ╔═╡ ffa5b3a9-b6f2-4423-a143-7476dd6b93b3
md"""

#### Link utili: 

- [Elenco dei notebooks delle lezioni](https://www-sop.inria.fr/members/Emanuele.Natale/docs/MScourse/lezione_0_-_syllabus.jl.html)
- [Pagina ufficiale del corso](http://www.informatica.uniroma2.it/f0?fid=220&srv=0&os=2021&cdl=0&id=ECMJ)
- [Pagina del docente, Emanuele Natale](https://www-sop.inria.fr/members/Emanuele.Natale/)

# Lezione 0.1  - Installazione del linguaggio Julia e all'uso dei notebook Pluto

In questa lezione vedremo come installare Julia e lanciare un Pluto notebook.
"""

# ╔═╡ ebdcb75a-731f-4c8a-9fec-a632c54925c9
md"""
### Come installare Julia

Si **consiglia** di scaricare l'ultima versione dei [binaries dalla pagina ufficiale](https://julialang.org/downloads) (*current stable*). 
Si **sconsiglia** di utilizzare eventuali versioni fornite dal sistema operativo in uso (per es. usando i package manager di *Ubuntu* o *Fedora*), in quanto tali versioni potrebbero non essere aggiornate e differire dalla versione ufficiale che, essendo basata su [**LLVM**](https://en.wikipedia.org/wiki/LLVM), permette di massimizzare la [riproducibilità](https://en.wikipedia.org/wiki/Reproducibility). 

![Julia official logo](https://julialang.org/assets/infra/logo.svg)

Una volta scaricato e estratto l'archivio, dovremmo poter lanciare da terminale il file `julia` nella sottocartella `/bin`, il quale dovrebbe aprire una sessione interativa, ovvero la "REPL" di Julia ([read–eval–print loop](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)).  
A questo punto, se scriviamo `1+1` e premiamo `Enter`, `Julia` dovrebbe fornirci il risultato corretto: 
```jl
julia> 1+1
2
```
"""

# ╔═╡ cefe624d-ff5c-4c14-9ef9-348318f98de4
md"""
### Usare i Pluto notebook: perché e come

Vedremo ora come installare l'ambiente di programmazione interattivo [Pluto](https://github.com/fonsp/Pluto.jl/blob/main/README.md). 
Pluto è progettato per permettere di sperimentare rapidamente e in modo interattivo in Julia, ed è lo strumento di cui faremo uso in questo corso, essendo molto efficace a livello didattico. 
A seguito di questo corso introduttivo, per programmare seriamente in Julia, lo studente è incoraggiato ad usare [Visual Studio Code, l'IDE ufficiale per Julia](https://code.visualstudio.com/docs/languages/julia). 

![Pluto Notebook logo](https://raw.githubusercontent.com/gist/fonsp/9a36c183e2cad7c8fc30290ec95eb104/raw/ca3a38a61f95cd58d79d00b663a3c114d21e284e/cute.svg)

#### Installare e lanciare Pluto

Nella REPL, scriviamo  
(i commenti in Julia sono preceduti da `#`)
```jl
julia> # premere `]`
pkg> add Pluto, PlutoUI # attendiamo che termini l'installazione
pkg> # premere `Esc` per uscire dal package mode
julia> using Pluto
julia> Pluto.run() 
```

A seguito dell'ultimo comando, la finestra iniziale di Pluto dovrebbe aprirsi automaticamente nel browser. 
Possiamo ora anche lanciare direttamente Pluto dando il seguente comando da terminale:
```jl
$ julia -e "using Pluto; Pluto.run()"
```

#### Come aprire in Pluto i notebook delle lezioni

Una volta aperta la pagina di una lezione nel browser, cliccare in alto a destro su **Edit or run this notebook** e seguire le istruzioni nella sezione **On your computer**.  
"""

# ╔═╡ 2ff42d48-d747-4ee4-952b-c7002ad1d2ac
md"""
## Conclusione

In questa lezione abbiamo visto 
- come lanciare la REPL Julia, 
- come installare il pacchetto Pluto e lanciare un Pluto notebook, e 
- come caricare un altro notebook Pluto nel proprio computer.

Nella [prossima lezione](https://www-sop.inria.fr/members/Emanuele.Natale/docs/MScourse/lezione_0.0_-_syllabus.jl.html), cominceremo a familiarizzare con Julia attraverso la manipolazione di immagini. 
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
# ╟─2c6cbae3-a506-4c7a-8ee6-a8a8241afecc
# ╟─788930f0-f646-4266-9bd9-768c3956ea99
# ╟─ffa5b3a9-b6f2-4423-a143-7476dd6b93b3
# ╟─ebdcb75a-731f-4c8a-9fec-a632c54925c9
# ╟─cefe624d-ff5c-4c14-9ef9-348318f98de4
# ╟─2ff42d48-d747-4ee4-952b-c7002ad1d2ac
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
