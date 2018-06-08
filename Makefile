PYTHON?=python3
D3_VERSION=v4.2.5
REVEAL_JS_VERSION=3.6.0
REVEAL_JS_TARBALL=$(REVEAL_JS_VERSION).tar.gz

deps:  directories revealjs d3js

directories:
	mkdir -p depdir

./depdir/d3.zip: | directories
	wget https://github.com/d3/d3/releases/download/$(D3_VERSION)/d3.zip -P ./depdir/

./depdir/$(REVEAL_JS_TARBALL): | directories
	wget https://github.com/hakimel/reveal.js/archive/$(REVEAL_JS_TARBALL) -P ./depdir/


revealjs: | ./depdir/$(REVEAL_JS_TARBALL)
	tar -xvzf ./depdir/$(REVEAL_JS_TARBALL)
	mv reveal.js-$(REVEAL_JS_VERSION) revealjs 

d3js: | ./depdir/d3.zip
	unzip ./depdir/d3.zip -d d3


clean: clean-dirs

clean-dirs:
	rm -fr depdir
	rm -fr revealjs
	rm -fr d3
	rm -fr *~
	rm -fr *gz

presentation:
	$(PYTHON) -m http.server
