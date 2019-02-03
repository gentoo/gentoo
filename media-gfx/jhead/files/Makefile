#--------------------------------
# jhead makefile for Unix
# this make file also creates libjhead for meshlab
#--------------------------------
OBJ=.
SRC=.
AR = ar cqs
LFLAGS = -shared -Wl,-soname,libjhead.so.1

objs = $(OBJ)/jhead.o $(OBJ)/jpgfile.o $(OBJ)/jpgqguess.o $(OBJ)/paths.o \
	$(OBJ)/exif.o $(OBJ)/iptc.o $(OBJ)/gpsinfo.o $(OBJ)/makernote.o 

TARGET        = libjhead.so.1.0.0
TARGET0       = libjhead.so
TARGET1       = libjhead.so.1
TARGET2       = libjhead.so.1.0

all: jhead $(TARGET) 

$(OBJ)/%.o:$(SRC)/%.c
	${CC} -fPIC $(CFLAGS) -c $< -o $@

jhead: $(objs) jhead.h
	${CC} ${LDFLAGS} -o jhead $(objs) -lm

clean:
	rm -f $(objs) jhead ${TARGET} ${TARGETA} ${TARGET0} ${TARGETD} \
	 ${TARGET1} ${TARGET2}
 
install:
	cp jhead ${DESTDIR}/usr/bin/
	cp ${TARGET} ${DESTDIR}/usr/lib/
	cp jhead ${DESTDIR}/usr/bin/
	cp ${TARGET0} ${DESTDIR}/usr/lib/
	cp ${TARGET1} ${DESTDIR}/usr/lib/
	cp ${TARGET2} ${DESTDIR}/usr/lib/

$(TARGET):  $(objs) jhead
	${CC} $(LDFLAGS) $(LFLAGS) -o $(TARGET) $(objs) 
	ln -s ${TARGET} ${TARGET0}
	ln -s ${TARGET} ${TARGET1}
	ln -s ${TARGET} ${TARGET2}

	
