# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs eutils multilib

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.106-parallel-fix.patch
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
	emake || die
}

src_test() {
	einfo "Running selftests"
	emake selftests
}

src_install () {
	einstall || die "install failed"

	#make backwards compatible symlinks
	dosym /usr/$(get_libdir)/bglibs /usr/$(get_libdir)/bglibs/lib
	[ "$(get_libdir)" != "lib" ] && dosym /usr/$(get_libdir)/bglibs /usr/$(get_libdir)/bglibs/$(get_libdir)
	dosym /usr/include/bglibs /usr/$(get_libdir)/bglibs/include

	#install .so in LDPATH
	mv "${D}"/usr/$(get_libdir)/bglibs/libbg.so.1.1.1 "${D}"/usr/$(get_libdir)/
	mv "${D}"/usr/$(get_libdir)/bglibs/libbg-sysdeps.so.1.1.1 "${D}"/usr/$(get_libdir)/
	dosym libbg.so.1.1.1 /usr/$(get_libdir)/libbg.so.1
	dosym libbg.so.1.1.1 /usr/$(get_libdir)/libbg.so
	dosym libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/libbg-sysdeps.so.1
	dosym libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/libbg-sysdeps.so

	dosym ../libbg.so.1.1.1 /usr/$(get_libdir)/bglibs/libbg.so.1.1.1
	dosym ../libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/bglibs/libbg-sysdeps.so.1.1.1

	rm "${D}"/usr/$(get_libdir)/bglibs/libbg.la
	rm "${D}"/usr/$(get_libdir)/bglibs/libbg-sysdeps.la

	dodoc ANNOUNCEMENT NEWS README ChangeLog TODO VERSION
	dohtml doc/html/*
	docinto latex
	dodoc doc/latex/*
}
