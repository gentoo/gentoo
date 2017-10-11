# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils java-pkg-2 toolchain-funcs

DESCRIPTION="List serial ports with vid/pid/iserial fields"
HOMEPAGE="https://github.com/arduino/listSerialPortsC"
SRC_URI="https://github.com/arduino/listSerialPortsC/archive/${PV}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""

DEPEND=">=dev-libs/libserialport-0.1.1"

S="${WORKDIR}/listSerialPortsC-${PV}"

src_prepare() {
	# Unbundle
	rm -rf libserialport win32_jni
}

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
