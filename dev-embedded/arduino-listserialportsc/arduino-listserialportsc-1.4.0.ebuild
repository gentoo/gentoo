# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 toolchain-funcs

DESCRIPTION="Arduino helper library to list serial ports"
HOMEPAGE="https://github.com/arduino/listSerialPortsC"
SRC_URI="https://github.com/arduino/listSerialPortsC/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/libserialport-0.1.1"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/listSerialPortsC-${PV}"

src_compile() {
	CC=$(tc-getCC)
	${CC} -Wall -O2 ${CPPFLAGS} ${CFLAGS} -c -o main.o main.c
	${CC} ${CFLAGS} ${LDFLAGS} main.o -lserialport -o listSerialC

	${CC} \
		-Wall -O2 ${CPPFLAGS} ${CFLAGS} -fPIC \
		-I$(java-config-2 -o)/include \
		-I$(java-config-2 -o)/include/linux \
		-o jnilib.o -c jnilib.c

	${CC} \
		${CFLAGS} ${LDFLAGS} \
		-shared -Wl,-soname,liblistSerialsj.so \
		jnilib.o -lserialport -o liblistSerialsj.so.${PV}
}

src_install() {
	dobin listSerialC
	dolib liblistSerialsj.so.${PV}
	dosym liblistSerialsj.so.${PV} /usr/$(get_libdir)/liblistSerialsj.so
}
