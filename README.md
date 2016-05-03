nim-wraph2o
===

Source server is [h2o](https://github.com/h2o/h2o)
See [docs](https://h2o.examp1e.net)

##Prerequsites
	nim-lang >= 0.12.1
	nimble >=0.7
	svn
	git
	libuv (not in default, but you can choose it)
	zlib
	nim-multitool (https://github.com/karantin2020/nim-multitool)
	nim-cstd (https://github.com/karantin2020/nim-cstd)


##Installation

	git clone https://github.com/karantin2020/nim-wraph2o.git
	cd nim-wraph2o
	nimble buildr3
	nimble buildh2o


##Test server

###To build
	nimble testserver

###To start
	cd ./tests/
	./test_server -c examples/h2o/h2o.conf

###Test it

	curl -i -XGET "127.0.0.1:8080/"
	curl -i -XGET "127.0.0.1:8080/file"
	curl -i -XGET "127.0.0.1:8080/hello"
	curl -i -XGET "127.0.0.1:8080/form/123"

	