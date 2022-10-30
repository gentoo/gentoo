# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bruce Guenter's Libraries Collection"
HOMEPAGE="https://untroubled.org/bglibs/"
SRC_URI="https://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ~ppc64 ~sparc x86"
IUSE="doc"

BDEPEND="
	sys-apps/which
	sys-devel/libtool
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"

src_prepare() {
	default
	# disable tests as we want them manually
	sed -i '/^all:/s|selftests||' Makefile || die
	sed -i '/selftests/d' TARGETS || die
}

src_configure() {
	echo "${ED}/usr/bin" > conf-bin || die
	echo "${ED}/usr/$(get_libdir)/bglibs" > conf-lib || die
	echo "${ED}/usr/include" > conf-include || die
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

src_install() {
	default

	# Install .so into LDPATH
	mv "${ED}"/usr/$(get_libdir)/bglibs/libbg.so.2.0.0 "${ED}"/usr/$(get_libdir)/ || die
	dosym libbg.so.2.0.0 /usr/$(get_libdir)/libbg.so.2
	dosym libbg.so.2.0.0 /usr/$(get_libdir)/libbg.so
	dosym ../libbg.so.2.0.0 /usr/$(get_libdir)/bglibs/libbg.so.2.0.0

	rm "${ED}"/usr/$(get_libdir)/bglibs/libbg.la || die

	dodoc ANNOUNCEMENT NEWS README ChangeLog TODO VERSION
	dodoc -r doc/html/
	if use doc; then
		dodoc doc/latex/refman.pdf
	fi
}
