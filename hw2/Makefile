JAVAC = javac
PKG = hw2
MAIN = Assignment2
SRC = $(wildcard *.java)

default: 
	$(JAVAC) -d . $(SRC)
	java $(PKG).$(MAIN)

clean:
	rm -rf $(PKG)