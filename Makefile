SHELL := /bin/bash
VOLUMES = $(shell ls -d v*)

all: static


clean:
	rm -rf output

npm: clean
	npm install
	mkdir -p output/beta/js
	mkdir -p output/beta/css
	cp node_modules/mdbootstrap/js/*.* output/beta/js/
	cp node_modules/mdbootstrap/css/*.* output/beta/css/

webpage: npm
	python src/gen_webpage.py

volumes: webpage
	for file in $(VOLUMES); do \
		python src/gen_volume.py $${file:1};\
	done


static: volumes
	cp -r static/img/ output/
	cp -r static/img/ output/beta/
	cp -r static/css/ output/beta/
	cp -r static/img/ output/beta/



test:
	py.test -vv src/tests/test.py

develop:
	livereload -p 8001 output/

update:
	git submodule foreach git pull origin main
	git pull origin main
	git submodule foreach git pull origin main
