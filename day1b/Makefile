PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

CC = gcc
CFLAGS = -Wall -Werror

.PHONY: clean day1b

day1b: day1b.o
	$(CC) $(CFLAGS) $^ -o day1b

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -v *.o

install:
	install -d $(BINDIR)
	install -m 755 day1b $(BINDIR)/day1b
