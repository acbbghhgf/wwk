pwd=${shell pwd}
out_dir=.
core_dir=$(pwd)/core
os_dir=$(pwd)/os

obj_src_dir=$(pwd)/core $(pwd)/os
obj_org_src=${shell find $(obj_src_dir) -name "*.c"} ../third/sqlite/sqlite3.c
obj_src=${filter-out %wtk_select.c,$(obj_org_src)}
objs=${patsubst %.c,%.o,${obj_src}}
target=libwtk.a

CC=gcc
CFLAGS=-Wall -Werror -g -O3
LDFLAGS=
CFLAGS+= -D USE_TCP_NODELAY -D USE_TCP_QUICKACK -DUSE_SQL

all: $(target)
	echo $(target)

$(target): $(objs)
	$(AR) rcs $@ $^

pre: $(core_dir) $(os_dir)

../third/sqlite/sqlite3.o: ../third/sqlite/sqlite3.c
	${CC} -I. -g -O3 -Wall -funroll-loops -c -o $@ $<;

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< -I .. $(LDFLAGS)

clean:
	-rm $(objs)
