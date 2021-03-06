TARGET_LIB = libtri.a
OBJS = streams/streams.o triArchive.o triTexman.o triCamera.o triVAlloc.o triMemory.o triRefcount.o triImage.o rle.o triGraphics.o tri3d.o triLog.o triModel.o triInput.o triVMath_vfpu.o triTimer.o triWav.o triAt3.o triAudioLib.o triError.o triConsole.o triFont.o triHeap.o triNet.o triParticle.o

INCDIR =
CFLAGS = -O3 -G0 -Wall -D__PSP__
CXXFLAGS = $(CFLAGS) -fno-exceptions -fno-rtti
ASFLAGS = $(CFLAGS)

LIBDIR =
LDFLAGS = -lpspgum -lpspgu -lpsprtc -lm -lz

ifeq ($(DEBUG),1)
	CFLAGS += -g -DDEBUG -D_DEBUG -D_DEBUG_LOG -D_DEBUG_MEMORY
endif

ifeq ($(PNG),1)
	CFLAGS += -DTRI_SUPPORT_PNG
	LDFLAGS += -lpng
endif

ifeq ($(FT),1)
	PSPBIN = $(shell psp-config --psp-prefix)

	CFLAGS += -DTRI_SUPPORT_FT $(shell $(PSPBIN)/bin/freetype-config --cflags)
	LDFLAGS += -lfreetype $(shell $(PSPBIN)/bin/freetype-config --libs)
endif

PSPSDK = $(shell psp-config --pspsdk-path)
PSPDIR = $(shell psp-config --psp-prefix)
include $(PSPSDK)/lib/build.mak

release: clean install

install: $(TARGET_LIB)
	install -m 755 -t $(PSPDIR)/lib $<
	install -m 644 -t $(PSPDIR)/include/openTri *.h
	install -m 644 -t $(PSPDIR)/include/streams streams/*.h
	install -m 644 -t $(PSPDIR)/include/streams streams/*.inc
	doxygen doxygen.ini
	install -t $(PSPDIR)/share/doc/openTri/html doc/html/*

.PHONY: install
