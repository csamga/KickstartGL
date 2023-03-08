CC = gcc

EXEC = program

SRCS = main.c
OBJS = $(patsubst %.c,%.o,$(SRCS))

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@

run: $(EXEC)
	./$(EXEC)

clean:
	$(RM) $(EXEC)
	$(RM) *.o
