nim-wraph2o
===

Source server is [h2o](https://github.com/h2o/h2o)
See [docs](https://h2o.examp1e.net)

##Prerequsites
	nim-lang >= 0.12.1
	nimble >=0.7
	svn
	git



##Installation

	git clone https://github.com/karantin2020/nim-wraph2o.git
	cd nim-wraph2o
	nimble buildr3
	nimble buildh2o


##Test server

###To build
	nimble testserver

###To start
	./tests/test_server

###Test it

	curl -i -XGET "127.0.0.1:8080/"
	curl -i -XGET "127.0.0.1:8080/file"
	curl -i -XGET "127.0.0.1:8080/hello"

	!!!Warning in Nim GC segfault error may be. Need to correct it
	curl -XPOST "127.0.0.1:8080/post" -d "Hello"