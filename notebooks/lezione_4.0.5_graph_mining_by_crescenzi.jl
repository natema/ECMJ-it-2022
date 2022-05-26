### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 5c870d0b-e0ea-4452-a296-7ec288b71e1f
begin
	using HTTP
	using Graphs
end

# ╔═╡ 04cd3776-9487-46eb-989b-ea8d1119fe2c
md"""
# [Graph Mining in Julia (2022)](https://natema.github.io/ECMJ-it/)

### [Pierluigi Crescenzi](https://www.pilucrescenzi.it/)
"""

# ╔═╡ 54ab2e42-87a8-46ed-8e3d-e21c12e2f847
md"""
### Graph mining

*Graphs* are everywhere. Mainly because they are a simple, elegant and
powerful tool to represent and analyze binary relationships, and our
life is full of binary relationships of very different types. Some
typical examples of such binary relationships are *communications* (such
as, for example, talking on the phone or sending emails or messages on
Telegram), *collaborations* (such as, for example, co-authoring a
scientific paper or co-acting in a movie), *ratings* (such as, for
example, indicating a "like" for a photo on Instagram or rating a movie
on Netflix), *membership* (such as, for example, being a member of a
university department or of a political party), *dependencies* (such as,
for example, citing a paper within another paper or including a link to
a web-page on another web-page), and *transfers* (such as making a bank
transfer or selling a car). Each instance of these relationships creates
a connection between the two agents involved, who, more often than not,
are human beings. These connections are the *arcs* of a graph, whose
*nodes* are the agents themselves.

Consider, for example, a simplification of one of the most popular
social networks, which concerns a group of families in the city of
Florence in the fifteenth century. In this case, the nodes of the graph
are the following fifteen Florentine families: Acciauioli, Albizzi,
Barbadori, Bischeri, Castellani, Ginori, Guadagni, Lamberteschi, Medici,
Pazzi, Peruzzi, Ridolfi, Salviati, Strozzi, and Tornabuoni. The binary
relationship between these families is that at least one member of a
family has married at least one member of another family. The graphical
representation of this relationship is shown in following figure, where
a label is associated with each node of the graph, formed by the first
two letters of the name of the corresponding family.

![Florence social network image](https://www.pilucrescenzi.it/gm/florence_social_network.png)

In this case, the social network includes fifteen nodes and twenty arcs: we
can already observe how the Medici family plays an important role in
this social network, being the one with the greatest number of
connections (six), much greater than the average of the connections of
each family which is equal to
$\frac{2\times 20}{15} = 40/15 \approx 2.7$ (note that the total number
of connections must be multiplied by two as each arc must be considered
from the point of view of the two nodes that the arc itself joins).
"""

# ╔═╡ ec3e9d9c-a0e7-4484-8e49-0b9221fe0c87
begin
	function read_graph(fn)
		io_fl = IOBuffer(HTTP.get("https://www.pilucrescenzi.it/gm/graphs/$fn.lg").body);
		return loadgraph(io_fl, "graph", LGFormat());
	end
end

# ╔═╡ ff4f5ff8-e771-4afd-ace9-ffbef3c0c093
md"""
The above function assumes that the text file contains one line specifying the number of nodes and the number of arcs, and the list of arcs of the graph (one line per arc with nodes separated by a comma). For instance, the text file corresponding to the previous graph might contain the following lines.

    15,20,u,graph
    1,9
    2,6
    2,7
    2,9
    3,5
    3,9
    4,7
    4,11
    4,14
    5,11
    5,14
    7,8
    7,15
    9,12
    9,13
    9,15
    10,13
    11,14
    12,14
    12,15
"""

# ╔═╡ bd510707-f1ca-4397-96cf-ce98539b572c
let
	g = read_graph("florence");
	deg = degree_centrality(g,normalize=false);
	println("Vicini dei Medici: ", deg[9])
	sum(deg)/nv(g)
end

# ╔═╡ ef56052f-f631-4667-9af8-98b6f311ea4a
md"""
The main advantage of representing binary relationships through mathematical objects, such as graphs, is that, on these objects, we can use the many mathematical and computer tools, that have been developed in the field of graph theory. In other words, we can analyze mathematical properties of a graph, and we can design, analyze and develop efficient algorithms that compute these properties. The final aim will be to reach conclusions that are interesting from the point of view of the specific domain, such as, for example, the existence of patterns that perhaps were not initially foreseen.

In the next sections of this page, we will describe some examples of application of this methodology to three different fields of research: the study of archaeological sites in third century Japan, the identification of communities within movie collaboration networks, and the prediction of the emergence of new relationships in the future of a social network. In all three cases, we will show how simple graph theory concepts (such as neighborhood, connectivity, and shortest path) can be used to analyze the network, and derive possible conclusions about its agents and about their relationships. At the same time, we will show how these concepts can be easily and efficiently computed by making use of the `Graphs.jl` Julia package.
"""

# ╔═╡ ed0cc145-6a04-4dad-b55d-d3ee90d23ff6
md"""
### Interpreting the past
The exchange of valuables can be seen as a communication tool that
allows us to reproduce the communication systems spread across a
space-time dimension. This idea can be applied in particular to
reconstruct the communication systems of the past, and to identify the
participants in the systems themselves who have played a more
significant role.

As an example, let us consider a particular period in Japanese history,
called Kofun, which begins around the middle of the third century. In
this period, it began the construction of specific burials or mounds in
the shape of a "keyhole", of relatively large dimensions (about three
hundred meters in length) and containing objects of different types,
such as mirrors, bronzed tools, and weapons. In particular, nine
archaeological sites have been identified over the years, to which the
Asian continent, from which various tools and valuables were imported,
must be added. Each of these ten sites corresponds to a node of a graph:
for each pair of sites, the graph includes an arc between the two
corresponding nodes if artifacts of the same type are found at the two
sites.

![Japanese social network image](https://www.pilucrescenzi.it/gm/japan_social_network.png)

The representation of this graph shown in the above figure does not help too much to understand which site played a more important role than the others. However, if we redraw the graph as shown in the following figure, it becomes clear that the two sites
Izumo and Kinki-core are more "central" than the others.

![Japanese social network image revisited](https://www.pilucrescenzi.it/gm/japan_social_network_revisited.png)

Various measures of centrality have been analyzed (including the number of
connections we have already referred to, when talking about the social
network of the Florentine families). The *closeness* is a measure of centrality based on the concept of *distance* between two nodes of the graph. This distance indicates the minimum
number of connections that must be "crossed" to go from one node to
another. For example, in the case of the previous graph, the distance from the node with the label `KC` to the nodes with labels `KO`, `TA`, `TS`, `KI`, `SA`, and
`OW` is equal to 1, since `KC` is directly connected to these nodes. Its
distance from the node labeled `IZ` is instead 2, since at least two
connections must be crossed: for example, the one from `KC` to `KO` and,
therefore, the one from `KO` to `IZ`. Similarly, we can conclude that
the distance of `KC` to the nodes with labels `AC` and `EA` is also
equal to 2.
"""

# ╔═╡ e9960c03-b084-4cac-ae3f-c5fc2e267597
let
	g = read_graph("japan");
	dist = gdistances(g,4)
end

# ╔═╡ dcbfd827-07fd-46ba-a1f1-666323fe8e38
md"""
The distances between all the pairs of nodes of the previous graph are summarized in the following table, in which a node is associated with each row and column, and each cell in the table includes the distance between the two nodes corresponding to
the row and the column of the cell.

|  |`AC`|`AS`|`ES`|`IZ`|`KC`|`KI`|`KO`|`OW`|`TA`|`TS`|**Farness**|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --------- |
|`AC`| 0 | 3 | 4 | 2 | 2 | 2 | 3 | 3 | 3 | 1 | 23 |
|`AS`| 3 | 0 | 3 | 2 | 1 | 1 | 2 | 2 | 2 | 2 | 18 |
|`ES`| 4 | 3 | 0 | 4 | 2 | 3 | 3 | 1 | 3 | 3 | 26 |
|`IZ`| 2 | 2 | 4 | 0 | 2 | 1 | 1 | 3 | 1 | 1 | 17 |
|`KC`| 2 | 1 | 2 | 2 | 0 | 1 | 1 | 1 | 1 | 1 | 12 |
|`KI`| 2 | 1 | 3 | 1 | 1 | 0 | 2 | 2 | 2 | 1 | 15 |
|`KO`| 3 | 2 | 3 | 1 | 1 | 2 | 0 | 2 | 1 | 2 | 17 |
|`OW`| 3 | 2 | 1 | 3 | 1 | 2 | 2 | 0 | 2 | 2 | 18 |
|`TA`| 3 | 2 | 3 | 1 | 1 | 2 | 1 | 2 | 0 | 2 | 17 |
|`TS`| 1 | 2 | 3 | 1 | 1 | 1 | 2 | 2 | 2 | 0 | 15 |

Note that the values of the cells corresponding to two equal nodes are
set equal to $0$, since the distance in this case is clearly null. We
also note that the table is "symmetric", in the sense that the distance
from a node $x$ to a node $y$ is equal to the distance from the node $y$
to the node $x$: indeed, the same path can be traversed in both
directions. The last column of the previous table shows the sums of the
distances of each node from all other nodes (in other words, the sum of
the elements of each row). This value indicates how "far" a node is to
the other nodes: the greater this value is, the further a node is to the
other nodes and, therefore, the less central. For this reason, we call
this value *farness* of a node.
"""

# ╔═╡ 8e4f9dce-8592-4f38-84ca-b27d22030899
let
	g = read_graph("japan");
	far = zeros(Int64, nv(g))
	for u in 1:nv(g)
		far[u] = sum(gdistances(g,u))
	end
	far
end

# ╔═╡ 4999db4f-e448-4f4a-a3d0-18bb00911002
md"""
The (normalized) *closeness* of a node is the inverse of its farness multiplied by the number of nodes minus one. For example, the closenees of node `KC` is equal to $\frac{1}{12}\times 9=0.75$. The greater this value is, the closer a node is to the other nodes and, therefore, the more central. 
"""

# ╔═╡ 9e8494f8-7d8c-4aa0-ad74-4f32de5fbc45
let
	g = read_graph("japan");
	closeness_centrality(g)
end

# ╔═╡ 0b4053f0-f00b-40f9-99c1-563a93c55b2c
md"""
In our case, the most central node is the one labeled `KC`, which corresponds to the Kinki-core site. Next, we have the Kibi site (with the `KI` label) and the Tsukushi site (with the `TS` label) with a closeness measure of $0.6$, which precede the Izumo site (with the `IZ` label) which has a measure of closeness approximately equal to $0.53$. This partly contradicts the idea we had, based on the graphical representation of the graph previously shown, that this last site was more central.

At this point, it is interesting to analyze the graph of archaeological
sites by referring to their geographical location. As shown in
the following figure, the Kinki-core site (labeled `KC`) is
geographically positioned quite centrally with respect to the other
sites: it is therefore not surprising that this site is also central in
the graph. However, we observe that the graph was defined by referring
only to the presence of similar artifacts in two different sites: the
analysis of the graph therefore indicates that there could be a
correlation between the latter property and the relative geographical
locations of the sites themselves. This hypothesis, however, has to face
a different situation as regards the Tsukushi site (with the label
`TS`), which is rather peripheral from a geographical point of view but,
as we have seen, is very central from the point of view of the closeness
measure. Indeed, it may surprise us that in the graph there is a direct
connection between the node labeled `KC` and the node labeled `TS`: this
is due to the fact that in one of the most important mounds of Tsukushi,
objects worked in the Kinki-core style have been found. The graph,
therefore, suggests that the interactions between the different sites
are more complex than the geographic location of the sites themselves
can suggest.

![Japanese social network image with map](https://www.pilucrescenzi.it/gm/japan_social_network_map.png)
"""

# ╔═╡ 494bf477-e2d2-43a2-ae17-d41489ae9875
md"""
### Understanding the present

The *Internet Movie DataBase* (for short, *IMDB*) is a service available
on the World Wide Web, which allows us to access information of various
kinds relating to films, actors, directors, screenwriters and, in
general, to all the staff of a film production. Created in the
early nineties, it has developed mainly thanks to the collaboration of
its users, who, once registered, can contribute to the archive with new
information that is monitored before being made public. In addition to
being an online social network, in which members can interact, not only
by updating information but, for example, by also providing film
ratings, IMDB has the advantage of making all the data collected
publicly available and providing, therefore, a very rich data-set for a
researcher, who wishes to carry out an analysis of social networks. As
of mid-2018, IMDB included information relating to nearly nine million
people and nearly five million movies.

Starting from this data-set, we can, for example, create one of the
largest collaboration networks currently known. A *collaboration
network* is a particular type of social network, in which the
relationship between two participants in the network itself consists in
having collaborated in the realization of some artifact (be it a book, a
film, or a software). In the case of IMDB, the corresponding
collaboration network includes, as participants, all the actors
registered in the data-set: two actors are linked together if they have
acted together in at least one movie. For example, Marcello Mastroianni
and Sofia Loren are linked together having acted together in several
films, including the beautiful *A special day* by Ettore Scola. On the
contrary, Marcello Mastroianni is not connected to Christian De Sica, as
the two actors have never acted together in the same film. We note that
in the definition we have just provided of the IMDB collaboration
network, we are not taking into account the number of collaborations
that took place between two actors: this information, on the other hand,
could obviously be interesting if our research were to take into account
in some way the "strength" of existing relationships.

Let us now see how the collaboration network between actors can be used
to deduce information about the actors themselves, which was not
explicitly included in the IMDB data-set. For this purpose, let us
consider a tiny part of the entire IMDB collaboration network, made up
of just the following ten American actors: Ben Affleck, Jennifer
Aniston, Roseanne Barr, George Clooney, Stacey Dash, Scarlett Johansson,
Randy Quaid, Jon Voight, Reese Witherspoon, and James Woods. Based on
the IMDB data-set, we can state that:

-   Ben Affleck collaborated with Jennifer Aniston and with Scarlett
    Johansson in *He's Just Not That Into You* (2009), and with Jon
    Voight in *Pearl Harbor* (2001);

-   Jennifer Aniston collaborated with George Clooney in *Waiting for
    Woody* (1998) and with Scarlett Johansson in *He's Just Not That
    Into You* (2009);

-   Roseanne Barr collaborated with Randy Quaid in *Home on the Range*
    (2004);

-   George Clooney collaborated with Scarlett Johansson in *Hail,
    Caesar!* (2016);

-   Stacey Dash collaborated with Randy Quaid in *Moving* (1988), and
    with Jon Voight in *Roe v. Wade* (2020);

-   Scarlett Johansson collaborated with Reese Witherspoon in *Sing 2*
    (2021);

-   Randy Quaid collaborated with James Woods in *Curse of the Starving
    Class* (1994);

-   Jon Voight collaborated with Reese Witherspoon in *Four Christmases*
    (2008), and with James Woods in *An American Carol* (2008).

On the ground of this information, we can build the corresponding
collaboration network between these ten actors shown in
the following figure, in which each of the actors is represented by a
node with a label equal to the initials of his first and last name.

![IMDB social network image](https://www.pilucrescenzi.it/gm/imdb_social_network.png)

Also in this case, the random visualization of the graph does not help to
steal from the graph itself new information that can be useful for
understanding the social mechanisms on which the graph was formed (in
addition to those related to co-participation in a movie). However, we can redraw the collaboration network of the ten actors as shown in the following figure.

![IMDB social network image revisited](https://www.pilucrescenzi.it/gm/imdb_social_network_revisited.png)

In this visualization it is evident that there are two communities
formed by five and four nodes, respectively, and shown in the figure
with white and black color, respectively. The nodes of one community are
not connected to any of the nodes of the other community: if it were not
for the node in gray, the two communities would be totally detached from
each other. Can we interpret the existence of these two communities from
a more sociological point of view? In other words, is there any
sociological reason that justifies the appearance of these two
communities?

The answer to this question might be positive. Indeed, according to two
Wikipedia pages, all the actors included in the
community whose nodes are colored in white have endorsed Joe Biden's
campaign for President of the United States in the 2020 U.S.
presidential election, while all the actors included in the community
whose nodes are colored in black and the actor corresponding to the node
colored in gray have publicly indicated support for Donald Trump in the
2020 U.S. presidential election. With the exception of Jon Voight (who
corresponds to the gray node), this analysis seems to indicate that, in
this set of actors, the democrats prefer to work together with the
democrats and the republicans together with the republicans.

The search for communities within a graph is one of the problems most
often faced in the field of the analysis of large graphs. Indeed, when a
graph includes thousands if not millions of nodes, no visualization will
ever be able to highlight the existence of such communities. Their
identification must therefore be carried out by an automatic method
which, among other things, has to be also very fast. Many methods for
identifying such communities have been proposed over the years. Let us now see, in a
more intuitive way, a simplification of one of these methods applied to
the collaboration network of the ten actors, which will allow us to
identify exactly the two communities of democratic and republican
actors.

The idea is to identify among all the nodes the one which is needed more
than the others for the (indirect) connection between all the pairs of
the other nodes. Informally, a node $a$ is needed to link two nodes $b$
and $c$, if after removing $a$ from the graph, there is no way to reach
$c$ starting from $b$ and the other way around. For example, the node
with label `RQ` of the collaboration network of the ten American actors
is necessary for the connection between the node with the label `JV` and
the one with the label `RB`: if we delete the node `RQ` from the graph,
there is no way to reach `RB` from `JV`.
"""

# ╔═╡ 5f818d41-b085-4cb5-a5c7-130aa1d5ac2a
let
	g = read_graph("imdb");
	println("Distance between RB and JV: ", gdistances(g, 3)[8])
	rem_vertex!(g, 7)
	println("Distance between RB and JV: ", gdistances(g, 3)[7])
end

# ╔═╡ 0e2d5f70-ed82-4c70-a842-60d9c005ff19
md"""
In the case of the ten-actor collaboration network, each white node must go through the gray node if it wants to reach a black node: therefore, the gray node is needed to connect $5 \times 4 = 20$ pairs of nodes (i.e. all pairs
formed by any of the five white nodes and by any of the four black
nodes). The black node labeled `RQ` is needed to connect any other node
to the black node labeled `RB`: therefore, this node is needed to
connect $8 \times 1 = 8$ pairs of nodes (that is, all pairs formed by
any of the eight nodes with labels other than `RQ` and `RB` and the node
with label `RB`). All other nodes in the collaboration network are not
needed for any pair of nodes: for example, the node labeled `JA` is not
needed to connect the node labeled `GC` to the node labeled `BA`, as
this connection can still be obtained by passing through the node
labeled `SJ`.
"""

# ╔═╡ 3c50f3f0-0335-4ec7-8a24-317fe072f4f2
let
	g = read_graph("imdb");
	println("Distance between GC and BA: ", gdistances(g, 1)[4])
	rem_vertex!(g, 2)
	println("Distance between GC and BA: ", gdistances(g, 1)[4])
end

# ╔═╡ 16ec50d6-ccc4-4fab-b245-e2384491b411
md"""
We call *articulation point* a node that is needed for at least one pair
of nodes. If we observe the two nodes with labels
`JV` and `RQ`, respectively, we see how these nodes play the same role
in the graphs as a joint of our human body, which has the task of
holding together different bone segments. Similarly, an articulation
point holds two components of the graph together: the `JV` node holds
the white and black communities together, while the `RQ` node holds the
`RB` node together with the rest of the graph. An articulation point, if
eliminated from the graph, makes it impossible to connect those pairs of
nodes that needed it to be connected, possibly highlighting those
communities of nodes that, on the contrary, are less dependent on the
removed node. Among all the articulation points, we consider the one
most "necessary", that is the one that holds together the greatest
number of pairs of nodes: in the case of the actor graph, it is the gray node. If we remove this node from the graph, the graph itself is broken into the two communities
shown in the figure, namely the one with the white nodes and the one
with the black nodes.
"""

# ╔═╡ 9865f419-3564-480f-8c76-87b7476e4ba3
let
	function product(cc)
		not_reachable = 0
		for c1 in 1:length(cc)
			for c2 in (c1+1):length(cc)
				not_reachable = not_reachable + length(cc[c1])*length(cc[c2])
			end
		end
		return not_reachable
	end
	g = read_graph("japan");
	to_be_removed = 0
	max_not_reachable = 0
	for a in articulation(g)
		g_prime = read_graph("japan");
		not_reachable_with_a = product(connected_components(g_prime))
		rem_vertex!(g_prime, a)
		not_reachable_without_a = product(connected_components(g_prime))
		if (not_reachable_without_a-not_reachable_with_a>max_not_reachable)
			to_be_removed = a
			max_not_reachable = not_reachable_without_a-not_reachable_with_a
		end
	end
	rem_vertex!(g, to_be_removed)
	println("Communities after removing node $to_be_removed: ", connected_components(g))
end

# ╔═╡ f0925f82-68c7-4fc2-b7a8-6db0019aa0bc
md"""
Despite its simplicity, this example shows how it is possible to divide
a graph into two or more groups with an interesting "semantics", by
analyzing only the structure of the graph itself and without making use
of any additional information. In reality, things are more difficult
than we have described above, and the methods used to identify
communities are, generally, more complicated. Moreover, the validation
of these methods is not always easy to carry out, as the very notion of
community can often be ambiguous and difficult to quantify through a
classification of the type white/black (i.e. democrat/republican), as we
did in the example of the collaboration network of the ten American
actors.
"""

# ╔═╡ 27c54e23-cbd1-4bcd-8e8d-670168d53e4e
md"""
### Imagining the future

The last example we consider in this introductory chapter refers to one of the best known social networks. It is a social network associated with a university karate club, which has become a very popular example of a two-community structure in the field of complex network analysis. The social network includes 34 members of a karate club, linked together in case there was a documented interaction between two members outside the club itself: in total, the graph includes 78 arcs. Due to a conflict that arose between two members of the club (in particular, between the administrator and the teacher), the club itself split into two clubs: half of the original club members created a new club after finding a new teacher, while the remaining half of the members remained in the original club. A graphical representation of this social network is shown in the following figure.

![Karate social network image](https://www.pilucrescenzi.it/gm/karate_social_network.png)

In the next figure we show a small part of this graph consisting of the node corresponding to the teacher and some of his connections (this part corresponds to a ``zoom'' of the rightmost part of the graphic representation of the entire social network).

![Karate social subnetwork image](https://www.pilucrescenzi.it/gm/karate_social_subnetwork.png)

The question we ask about the graph shown in the above figure consists in predicting what future
interactions will take place between network participants: in other
words, predicting which new connections will form from those already
existing. For example, node 2 and node 4 are both connected to node 1:
based on the principle that "my friends' friends are my friends", we can
assume that in the future the two nodes will interact directly by
creating a new arc between them. Obviously, the same is true for nodes 2
and 7, 3 and 5, 3 and 7, 4 and 7, and 5 and 7 (as they are both
connected to node 1), for nodes 1 and 6 and 3 and 6 (as they are both
connected to node 4), and for nodes 2 and 6 (as they are both connected
to node 5). But of all these potential new arcs which ones are most
likely to be created in the near future? Obviously an exact answer is
impossible, as no one knows the future of a network of social relations.
However, we will now see a simple technique that is quite
effective in carrying out this task, based on the analysis of the "neighborhood"
of a node.

The *neighborhood* of a node consists of all the nodes directly
connected to it. For example, the neighborhood of node 1 of the above graph consists of nodes 2, 3, 4, 5 and 7.
"""

# ╔═╡ 97410a16-91a7-40c4-88d9-8635d432873d
let
	g = read_graph("karate");
	println("Neighborhood of node 1: ", all_neighbors(g, 1))
end

# ╔═╡ a10b9fff-3b05-4c68-a57e-3c517815856e
md"""
In the
following table, we show in the second column, for each node of this
graph, its neighborhood. The following columns show the elements in
common between the neighborhood of the node $i$ corresponding to the row
and the neighborhood of the nodes different from $i$ which are not in
the neighborhood of node $i$ (for simplicity, we have indicated with
$\cap_j$ the elements in common with the neighborhood of node $j$, which
is not in the neighborhood of node $i$).

|Node|Neighborhood|$\cap_1$|$\cap_2$|$\cap_3$|$\cap_4$|$\cap_5$|   $\cap_6$|$\cap_7$|
|---|---|---|---|---|---|---|---|---|
| 1 | {2,3,4,5,7} |  |  |  |  |  | {4,5} |  |                                                                    
| 2 | {1,3,5} |  |  |  | {1,3,5} |  | {5} | {1} |
| 3 | {1,2,4} |  |  |  |  | {1,2,4} | {4} | {1} |
| 4 | {1,3,5,6} |  | {1,3,5} |  |  |  |  | {1} |
| 5 | {1,2,4,6} |  |  | {1,2,4} |  |  |  | {1} |
| 6 | {4,5} | {4,5} | {5} | {4} |  |  |  | {} |
| 7 | {1} |  | {1} | {1} | {1} | {1} | {} |  |

The last seven columns of the previous table suggest a way of giving each of the connections that do not yet exist in the social network a ``probability'' that such a connection will be generated in the near future. Intuitively, the probability that an arc is created between the node $i$ and the node $j$ will be greater if greater is the cardinality of the set in the table in correspondence of the row labeled $i$ and the column labeled $\cap_j$. Therefore, of all the possible candidate connections to be generated, the one between node $2$ and node $4$ and the one between node $3$ and node $5$ are more probable, since their neighborhood intersection contains three elements.

In conclusion, we can predict that in the near future node $2$ will interact with node $4$ or that node $3$ will interact with node $5$. Unfortunately, we do not have the data to verify the correctness of this prediction and, in general, verifying forecasts for the development of a social network is not an easy task, due to the lack of sufficient data to carry out this verification. However, there are situations and techniques that allow us to measure the ``goodness'' of a forecast.
"""

# ╔═╡ 89e484f3-41c4-48dd-a322-8421afa5a307
let
	g = read_graph("florence");
	pair_to_be_linked = []
	max_intersection = 0
	for u in 1:nv(g)
		nsu = Set(all_neighbors(g, u))
		for v in (u+1):nv(g)
			if !in(nsu, v)
				nsv = Set(all_neighbors(g, v))
				inter = intersect(nsu, nsv)
				if (length(inter) > max_intersection)
					max_intersection = length(inter)
					pair_to_be_linked = [Pair(u,v)]
				elseif (length(inter) == max_intersection)
					push!(pair_to_be_linked, Pair(u,v))
				end
			end
		end
	end
	println("Nodes likely to be linked: ", pair_to_be_linked)
end

# ╔═╡ ebd9a153-8938-4e97-b51f-20cea6280a5e
md"""
### Efficiency of graph mining

Let us consider the DBLP collaboration network. Computing the degrees of all nodes requires linear time in the number of arcs.
"""

# ╔═╡ 0bd2822d-f6a3-46da-a642-3e214391fd0c
let
	g = read_graph("dblp");
	println("Number of nodes: ", nv(g));
	println("Number of nodes: ", ne(g));
	@time degree_centrality(g);
end

# ╔═╡ 24cf0d65-1007-4519-acd7-ebbb29c12cfc
md"""
Computing measures as the closeness centrality, instead, requires a tiem proportional to the number of nodes times the number of edges.
"""

# ╔═╡ b611760c-2310-48cb-beaf-899157271d6d
# uncomment the following block to exercute the cell but beware: it takes a long time...
#let
#   g = read_graph("dblp");
#   println("Number of nodes: ", nv(g));
#   println("Number of nodes: ", ne(g));
#   @time closeness_centrality(g);
#end

# ╔═╡ 94dc2065-92b3-453c-8733-e3a45d540770
md"""
The main objectives of current research in graph mining is to make the computation of these measures sufficiently efficient, by either giving up on exact values or by focusing on properties of real-world graphs.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"

[compat]
Graphs = "~1.7.0"
HTTP = "~0.9.17"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

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
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "4888af84657011a65afc7a564918d281612f983a"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.0"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

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

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

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

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

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

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

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
# ╟─04cd3776-9487-46eb-989b-ea8d1119fe2c
# ╠═5c870d0b-e0ea-4452-a296-7ec288b71e1f
# ╟─54ab2e42-87a8-46ed-8e3d-e21c12e2f847
# ╠═ec3e9d9c-a0e7-4484-8e49-0b9221fe0c87
# ╟─ff4f5ff8-e771-4afd-ace9-ffbef3c0c093
# ╠═bd510707-f1ca-4397-96cf-ce98539b572c
# ╟─ef56052f-f631-4667-9af8-98b6f311ea4a
# ╟─ed0cc145-6a04-4dad-b55d-d3ee90d23ff6
# ╠═e9960c03-b084-4cac-ae3f-c5fc2e267597
# ╟─dcbfd827-07fd-46ba-a1f1-666323fe8e38
# ╠═8e4f9dce-8592-4f38-84ca-b27d22030899
# ╟─4999db4f-e448-4f4a-a3d0-18bb00911002
# ╠═9e8494f8-7d8c-4aa0-ad74-4f32de5fbc45
# ╟─0b4053f0-f00b-40f9-99c1-563a93c55b2c
# ╟─494bf477-e2d2-43a2-ae17-d41489ae9875
# ╠═5f818d41-b085-4cb5-a5c7-130aa1d5ac2a
# ╟─0e2d5f70-ed82-4c70-a842-60d9c005ff19
# ╠═3c50f3f0-0335-4ec7-8a24-317fe072f4f2
# ╟─16ec50d6-ccc4-4fab-b245-e2384491b411
# ╠═9865f419-3564-480f-8c76-87b7476e4ba3
# ╟─f0925f82-68c7-4fc2-b7a8-6db0019aa0bc
# ╟─27c54e23-cbd1-4bcd-8e8d-670168d53e4e
# ╠═97410a16-91a7-40c4-88d9-8635d432873d
# ╟─a10b9fff-3b05-4c68-a57e-3c517815856e
# ╠═89e484f3-41c4-48dd-a322-8421afa5a307
# ╟─ebd9a153-8938-4e97-b51f-20cea6280a5e
# ╠═0bd2822d-f6a3-46da-a642-3e214391fd0c
# ╟─24cf0d65-1007-4519-acd7-ebbb29c12cfc
# ╠═b611760c-2310-48cb-beaf-899157271d6d
# ╟─94dc2065-92b3-453c-8733-e3a45d540770
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
