
input('root','Root',xmlf,'inputModelXML.xmi').
output('xmi','XMI',book,'modelBookOut.ecore').
rdf_db::ns(children, 'http:://www.example.org/children#').
rdf_db::ns(book, 'http:://www.example.org/book#').

metamodel(xmlf,[
	class(children,['xsi:type',name,value]),
	role(children,children,children,"0","*",container)
	]).

metamodel(book,[
	class('Book',[title]),
	class('Chapter',[title,nbPages,author]),
	role(chapters,'Book','Chapter',"0","*",container)
]).



helper(getTitle).

getTitle(E,Y):- 
	children_name(xmlf,E,'title'),children_value(xmlf,E,Y).

helper(getPages).

getPages(E,Y):- 
	children_name(xmlf,E,'nbPages'),children_value(xmlf,E,Y).

helper(getAuthor).

getAuthor(E,Y):- 
	children_name(xmlf,E,'author'),children_value(xmlf,E,Y).


rule book 
	from
		(e::xmlf#children,l::xmlf#children,f::xmlf#children,g::xmlf#children,h::xmlf#children,k::xmlf#children)  where 
		(e@name == "book" and (e@children == l and (e@children==f and (f@name=="chapter" and (l@name=="title" and (f@children==g and (g@name=="title" and (f@children==h and (h@name=="nbPages" and (f@children==k and k@name=="author"))))))))))
		
	to
		(book::book#'Book'(title <- l@value,
		chapters <- resolveTemp((f,g,h,k),chapter)
		)  
		).

rule chapter from (e::xmlf#children,f::xmlf#children,g::xmlf#children,
h::xmlf#children) 
where (e@name=="chapter" and (e@children == f and (e@children == g
		and e@children == h)))
		to (chapter::book#'Chapter'(title<-getTitle(f),
		nbPages <- getPages(g),
		author <- getAuthor(h)
		)).

