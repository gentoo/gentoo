# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="https://untroubled.org/bglibs/
	https://github.com/bruceg/bglibs"
SRC_URI="https://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

BDEPEND="
	sys-devel/libtool
	doc? (
		app-doc/doxygen
		dev-tex/xcolor
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"

PATCHES=( "${FILESDIR}"/${PN}-1.106-parallel-fix.patch )

src_prepare() {
	default
	# disable tests as we want them manually
	sed -i -e '/^all:/s|selftests||' Makefile || die
	sed -i -e '/selftests/d' TARGETS || die
}

src_configure() {
	echo "${ED}/usr/bin" > conf-bin || die
	echo "${ED}/usr/$(get_libdir)/bglibs" > conf-lib || die
	echo "${ED}/usr/include/bglibs" > conf-include || die
	echo "${ED}/usr/share/man" > conf-man || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_compile() {
	default
	if use doc; then
		emake -C doc/latex pdf
	fi
}

src_test() {
	einfo "Running selftests"
	emake selftests
}

src_install () {
	default

	#make backwards compatible symlinks
	dosym ../../$(get_libdir)/bglibs /usr/$(get_libdir)/bglibs/lib
	[[ "$(get_libdir)" != "lib" ]] && dosym ../../$(get_libdir)/bglibs /usr/$(get_libdir)/bglibs/$(get_libdir)
	dosym ../../include/bglibs /usr/$(get_libdir)/bglibs/include

	#install .so in LDPATH
	mv "${ED}"/usr/$(get_libdir)/bglibs/libbg.so.1.1.1 "${ED}"/usr/$(get_libdir)/ || die
	mv "${ED}"/usr/$(get_libdir)/bglibs/libbg-sysdeps.so.1.1.1 "${ED}"/usr/$(get_libdir)/ || die
	dosym libbg.so.1.1.1 /usr/$(get_libdir)/libbg.so.1
	dosym libbg.so.1.1.1 /usr/$(get_libdir)/libbg.so
	dosym libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/libbg-sysdeps.so.1
	dosym libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/libbg-sysdeps.so

	dosym ../libbg.so.1.1.1 /usr/$(get_libdir)/bglibs/libbg.so.1.1.1
	dosym ../libbg-sysdeps.so.1.1.1 /usr/$(get_libdir)/bglibs/libbg-sysdeps.so.1.1.1

	rm "${ED}"/usr/$(get_libdir)/bglibs/libbg.la || die
	rm "${ED}"/usr/$(get_libdir)/bglibs/libbg-sysdeps.la || die

	dodoc ANNOUNCEMENT NEWS README ChangeLog TODO VERSION
	dodoc -r doc/html/
	if use doc; then
		dodoc doc/latex/refman.pdf
	fi
}
