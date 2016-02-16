# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

MY_PN="Csdp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A C Library for Semidefinite Programming"
HOMEPAGE="http://projects.coin-or.org/Csdp/"
SRC_URI="http://www.coin-or.org/download/source/${MY_PN}/${MY_P}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/blas
	virtual/lapack"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e "s@CFLAGS=-O3@CFLAGS=${CFLAGS}@" \
		-e 's@\($(CC) $(CFLAGS).*\) -o@\1 ${LDFLAGS} -o@' \
		-i "${S}"/example/Makefile \
		"${S}"/lib/Makefile \
		"${S}"/solver/Makefile \
		"${S}"/theta/Makefile \
		|| die "Could not set our flags in Makefiles"
	sed -e "s@-lblas@$($(tc-getPKG_CONFIG) --libs blas)@g" \
		-e "s@-llapack@$($(tc-getPKG_CONFIG) --libs lapack)@g" \
		-i "${S}"/example/Makefile \
		"${S}"/solver/Makefile \
		"${S}"/theta/Makefile \
		|| die "Could not set blas and lapack library locations in Makefiles"
	sed -e 's@install:@install:\n\tmkdir -p ${DESTDIR}usr/bin@' \
		-e 's@/usr/local@${DESTDIR}usr@g' \
		-e 's@; make@; make -j 1@g' \
		-i "${S}"/Makefile \
		|| die 'Could not change /usr/local to ${DESTDIR} in Makefile'
}

src_test() {
	emake unitTest
}
