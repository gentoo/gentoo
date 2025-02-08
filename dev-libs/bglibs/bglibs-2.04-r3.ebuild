# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Bruce Guenter's Libraries Collection"
HOMEPAGE="https://untroubled.org/bglibs/"
SRC_URI="https://untroubled.org/bglibs/archive/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
	"${FILESDIR}"/bglibs-2.04-stack-buffers.patch
	"${FILESDIR}"/bglibs-2.04-feature-tests.patch
	"${FILESDIR}"/bglibs-2.04-musl.patch
)

src_prepare() {
	default

	# Remove the tests from the default target so that we can run
	# them only when the user has enabled them.
	sed -i '/^all:/s|selftests||' Makefile || die
	sed -i '/selftests/d' TARGETS || die

	# The selftests.sh script collects the list of tests to run by
	# grepping for "#ifdef SELFTEST_MAIN", which is defined in each *.c
	# file to be tested. We can therefore disable individual tests by
	# clobbering that line. (This should be safe; the contents of that
	# ifdef are the test program, which we are disabling anyway.)
	#
	# This test requires network access, and currently fails even
	# if you have it (https://github.com/bruceg/bglibs/issues/5).
	sed -e 's/#ifdef SELFTEST_MAIN/#ifdef UNDEFINED/' \
		-i net/resolve_ipv4addr.c || die
}

src_configure() {
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
	echo "${ED}/usr/bin" > conf-bin || die
	echo "${ED}/usr/$(get_libdir)/bglibs" > conf-lib || die
	echo "${ED}/usr/include" > conf-include || die
	echo "${ED}/usr/share/man" > conf-man || die

	default

	# Install .so into LDPATH
	mv "${ED}"/usr/$(get_libdir)/bglibs/libbg.so.2.0.0 \
		"${ED}"/usr/$(get_libdir)/ \
		|| die
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
