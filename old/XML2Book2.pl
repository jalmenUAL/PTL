
input('xmi','XMI',xmlf,'inputModelXML.xmi').
output('xmi','XMI',book,'modelBookOut.ecore').
rdf_db::ns(xmlf, 'http:://www.example.org/xmlf#').
rdf_db::ns(book, 'http:://www.example.org/book#').


metamodel(xmlf,[
	class(children,['xsi::type',name,value])
	%,
	%role(children,children,children,"0","*",container)
	]).

metamodel(book,[
	class('Book',[title]),
	class('Chapter',[title,nbPages,author]),
	role(chapters,'Book','Chapter',"0","*",container)]
).



helper(getTitle).

getTitle(E,Y):-children_name(xmlf,E,'title'),children_value(xmlf,E,Y).

helper(getPages).

getPages(E,Y):-children_name(xmlf,E,'nbPages'),children_value(xmlf,E,Y).

helper(getAuthor).

getAuthor(E,Y):-children_name(xmlf,E,'author'),children_value(xmlf,E,Y).


rule book1 
	from
		(e::xmlf#children)  
		
	to
		(c::book#'Book'(title <- e@name)
		).



