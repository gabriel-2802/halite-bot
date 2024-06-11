JAVA=java
HALITE=./halite
DIM ?= 40 40
MY_BOT=BotV2
BOT_1=bots/DBotv4_linux_x64
BOT_2=bots/starkbot_linux_x64
BROWSER=google-chrome
FILE ?= ""

CLASS_DIR=classes
SRC_DIR=src

.PHONY: all build clean move_classes fight-random fight-1 fight-2 fight-bots vis custom

all: build move_classes

build:
	$(MAKE) -C src build

move_classes:
	@mkdir -p $(CLASS_DIR)
	mv src/*.class $(CLASS_DIR)

clean:
	$(MAKE) -C src clean
	rm -rf $(CLASS_DIR) *.log *.hlt *.replay
	rm -rf replays/*

# asks for a seed
fight:
	@read SEED; \
	$(HALITE) -d "$(DIM)" -s $$SEED "$(JAVA) -cp $(CLASS_DIR) $(MY_BOT)" "$(BOT_2)" "$(BOT_2)" "$(BOT_2)"

fight-1:
	$(HALITE) -d "$(DIM)" -n 1 -s 42 "$(JAVA) -cp $(CLASS_DIR) $(MY_BOT)" "$(BOT_1)"

fight-2:
	$(HALITE) -d "$(DIM)" -n 1 -s 42 "$(JAVA) -cp $(CLASS_DIR) $(MY_BOT)" "$(BOT_2)"

fight-bots:
	$(HALITE) -d "$(DIM)" -n 1 -s 42 "$(BOT_1)" "$(BOT_2)"

# shows the latest replay file
vis:
	@FILE=$$(ls -t *.hlt | head -1); \
	if [ -z "$$FILE" ]; then \
		echo "No .hlt file found."; \
	else \
		echo "Using file: $$FILE"; \
		python3 vis.py $(BROWSER) $$FILE; \
	fi

# shows a specific replay file
custom:
	@echo "Enter file name:"
	@read FILE; \
	python3 vis.py $(BROWSER) $$FILE