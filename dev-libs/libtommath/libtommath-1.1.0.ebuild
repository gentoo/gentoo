# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Optimized and portable routines for integer theoretic applications"
HOMEPAGE="http://www.libtom.net/"
SRC_URI="https://github.com/libtom/libtommath/releases/download/v${PV}/ltm-${PV}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples static-libs"

src_prepare() {
	default
	# need libtool for cross compilation. Bug #376643
	cat <<-EOF > configure.ac
	AC_INIT(libtommath, 0)
	AM_INIT_AUTOMAKE
	LT_INIT
	AC_CONFIG_FILES(Makefile)
	AC_OUTPUT
	EOF
	touch NEWS README AUTHORS ChangeLog Makefile.am
	eautoreconf
	export LIBTOOL="${S}"/libtool
}

src_configure() {
	econf $(use_enable static-libs static)
}

_emake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		-f makefile.shared \
		IGNORE_SPEED=1 \
		LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		INCPATH="${EPREFIX}/usr/include" \
		"$@"
}

src_compile() {
	_emake
}

src_test() {
	_emake test_standalone
	./test || die
}

src_install() {
	_emake DESTDIR="${D}" install
	# We only link against -lc, so drop the .la file.
	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi

	dodoc changes.txt

	use doc && dodoc *.pdf

	if use examples ; then
		docinto demo
		dodoc demo/*.c
	fi
}
