# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Convert UML diagrams produced with Dia to various source code flavours"
HOMEPAGE="http://dia2code.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libxml2:="
DEPEND="${RDEPEND}
	test? ( app-shells/bash )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-imports.patch
)

src_prepare() {
	# Script makes use of arrays
	sed -e 's:/bin/sh:/bin/bash:' -i tests/tests.sh || die
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	doman docs/dia2code.1
}
