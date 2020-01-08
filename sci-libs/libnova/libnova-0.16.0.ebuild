# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Celestial Mechanics and Astronomical Calculation Library"
HOMEPAGE="http://libnova.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0/0.16"
KEYWORDS="amd64 hppa ppc ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default
	use doc && emake -C doc doc
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default

	if use examples; then
		emake clean
		rm examples/Makefile* || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
