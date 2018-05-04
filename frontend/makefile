./public/mdl:
	wget "https://code.getmdl.io/1.3.0/mdl.zip"
	mkdir -p ./src/lib/mdl
	unzip -d ./src/lib/mdl ./mdl.zip
	rm ./mdl.zip
	rm ./src/lib/mdl/package.json

clean:
	rm -rf ./src/lib/mdl

all: 	./public/mdl
