PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

CC = gcc
CFLAGS = -Wall -Werror

.PHONY: clean day1a

day1a: day1a.o
	$(CC) $(CFLAGS) $^ -o day1a

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -v *.o

install:
	install -d $(BINDIR)
	install -m 755 day1a $(BINDIR)/day1a
