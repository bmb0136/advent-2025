PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

CC = gcc
CFLAGS = -Wall -Werror

.PHONY: clean day1

day1: day1.o
	$(CC) $(CFLAGS) $^ -o day1

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -v *.o

install:
	install -d $(BINDIR)
	install -m 755 day1 $(BINDIR)/day1
