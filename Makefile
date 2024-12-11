
MAIN  = main
FILES = $(MAIN).tex Makefile

AUX ?= tex-aux
OPT ?= --skip-first --change-directory -e lualatex

.PHONY: clean spellA spellT cont count $(MAIN).pdf

$(MAIN).pdf: $(FILES)
	test -d $(AUX) || mkdir $(AUX)
	cluttealtex --output-directory=$(AUX) $(OPT) "$<"

cont: $(FILES)
	touch "$(MAIN).tex"
	$(MAKE) OPT="$(OPT) --watch=inotifywait --memoize_opt=readonly"

count:
	texcount -col -inc $(MAIN).tex

clean:
	-test -d $(AUX)  && $(RM) -r $(AUX)

spellA: $(FILES)
	-aspell --home-dir=. --personal=dict.txt -l de_DE -t -c "$<"
	iconv -f ISO-8859-1 -t UTF-8 ./dict.txt > ./dict.txt2
spellT: $(FILES)
	-textidote --check de --remove tikzpicture --replace replacements.txt --dict ./dict.txt2 --output html "$<" > $(MAIN)-texidote.html
