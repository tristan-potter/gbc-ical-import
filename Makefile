
.PHONY: run pack

run:
	./src/main.rb

pack:
	rbwasm pack ruby.wasm
