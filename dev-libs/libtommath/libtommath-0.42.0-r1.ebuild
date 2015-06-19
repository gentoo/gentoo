# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtommath/libtommath-0.42.0-r1.ebuild,v 1.21 2015/04/18 13:03:10 swegener Exp $

EAPI=4

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="highly optimized and portable routines for integer based number theoretic applications"
HOMEPAGE="https://github.com/libtom/libtommath"
SRC_URI="https://github.com/libtom/libtommath/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples static-libs"

DEPEND="sys-devel/libtool"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

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
	export LT="${S}"/libtool
}

src_configure() {
	econf $(use_enable static-libs static)
}

_emake() {
	emake CC="$(tc-getCC)" -f makefile.shared \
		IGNORE_SPEED=1 \
		LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		INCPATH="${EPREFIX}/usr/include" \
		"$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${ED}" install
	# We only link against -lc, so drop the .la file.
	find "${ED}" -name '*.la' -delete

	dodoc changes.txt

	use doc && dodoc *.pdf

	if use examples ; then
		docinto demo
		dodoc demo/*.c
	fi
}
