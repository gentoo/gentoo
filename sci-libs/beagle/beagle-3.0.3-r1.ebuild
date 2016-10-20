# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Open BEAGLE, a versatile EC/GA/GP framework"
SRC_URI="mirror://sourceforge/beagle/${P}.tar.gz"
HOMEPAGE="http://beagle.gel.ulaval.ca/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND="
	sys-libs/zlib
	!app-misc/beagle
	!dev-libs/libbeagle"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.3-gcc43.patch"
	"${FILESDIR}/${PN}-3.0.3-gcc47.patch"
	"${FILESDIR}/${PN}-3.0.3-fix-c++14.patch"
)

src_prepare() {
	default
	sed -e "s:@LIBS@:@LIBS@ -lpthread:" \
		-i PACC/Threading/Makefile.in || die
}

src_configure() {
	econf \
		--enable-optimization \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && emake doc
}

src_install () {
	use doc && local HTML_DOCS=( refman/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
