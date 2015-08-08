# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils multilib

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/bglibs-1.104-parallel-fix.patch
	# disable tests as we want them manually
	sed -i \
		-e '/^all:/s|selftests||' \
		"${S}"/Makefile
	sed -i \
		-e '/selftests/d' \
		"${S}"/TARGETS
	#sed -i \
	#	-e 's,^libraries:,LIBS = ,g' \
	#	-e '/^LIBS =/alibs-static: $(filter %.a,$(LIBS))' \
	#	-e '/^LIBS =/alibs-shared: $(filter %.la,$(LIBS))' \
	#	-e '/^LIBS =/alibraries: libs-static libs-shared' \
	#	"${S}"/Makefile
}

src_compile() {
	echo "${D}/usr/bin" > conf-bin
	echo "${D}/usr/$(get_libdir)/bglibs" > conf-lib
	echo "${D}/usr/include/bglibs" > conf-include
	echo "${D}/usr/share/man" > conf-man
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	# Fails if we do parallel build of shared+static at the same time
	emake libs-shared || die
	emake libs-static || die
	emake || die
}

src_test() {
	einfo "Running selftests"
	emake selftests
}

src_install () {
	einstall || die "install failed"

	#make backwards compatible symlinks
	dosym /usr/lib/bglibs /usr/lib/bglibs/lib
	dosym /usr/include/bglibs /usr/lib/bglibs/include

	dodoc ANNOUNCEMENT NEWS README ChangeLog TODO VERSION
	dohtml doc/html/*
	docinto latex
	dodoc doc/latex/*
}
