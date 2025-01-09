# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Bruce Guenter's Libraries Collection"
HOMEPAGE="https://untroubled.org/bglibs/"
SRC_URI="https://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	sys-apps/which
	dev-build/libtool
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"

PATCHES=(
	"${FILESDIR}/${P}-stack-buffers.patch"
	"${FILESDIR}/${P}-fix-feature-tests.patch"
	"${FILESDIR}/${P}-disable-selftests.patch"
	 )

src_configure() {
	echo "${ED}/usr/bin" > conf-bin || die
	echo "${ED}/usr/$(get_libdir)/bglibs" > conf-lib || die
	echo "${ED}/usr/include" > conf-include || die
	echo "${ED}/usr/share/man" > conf-man || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_compile() {
	# Parallel build fails, bug #343617
	MAKEOPTS+=" -j1" default

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
