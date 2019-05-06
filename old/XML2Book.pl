
input('root','Root',xmlf,'inputModelXML.xmi').
output('xmi','XMI',book,'modelBookOut.ecore').
rdf_db::ns(children, 'http:://www.example.org/children#').
rdf_db::ns(book, 'http:://www.example.org/book#').

metamodel(xmlf,[
	class(children,['xsi::type',name]),
	class(title,['xsi::type',name,value]),
	class(chapter,['xsi::type',name]),
	class(attribute,['xsi::type',name,value]),
	role(children,children,title,"1","1",container),
	role(children,children,chapter,"1","1",container),
	role(children,chapter,attribute,"0","*",container)
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
		(e::xmlf#children)  where 
		(e@name == "book") 
		
	to
		(book::book#'Book'(title <- e@children@value
		%,
		%	chapters <- chapter
		%),
                %chapter::book#'Chapter'(title <- getTitle(g@children),
		%	nbPages <- getPages(g@children),
		%	author <-  getAuthor(g@children)
		)
		).



