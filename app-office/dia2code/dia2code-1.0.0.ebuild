# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Convert UML diagrams produced with Dia to various source code flavours"
HOMEPAGE="http://dia2code.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${DEPEND}"
DEPEND="
	dev-libs/libxml2
	test? ( app-shells/bash )
"

src_prepare() {
	# Script makes use of arrays
	sed -e 's:/bin/sh:/bin/bash:' \
		-i tests/tests.sh || die
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	doman docs/dia2code.1
}
