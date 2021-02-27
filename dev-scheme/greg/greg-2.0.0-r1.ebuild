# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Testing-Framework for guile"
HOMEPAGE="http://gna.org/projects/greg/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"

RDEPEND=">=dev-scheme/guile-1.8"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-guile2.patch
)

src_prepare() {
	default
	eautoreconf
}

src_test() {
	cd test || die
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${BUILD_DIR}/src/.libs"
	export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:${BUILD_DIR}/src/"
	guile -s "${S}"/src/greg || die
}
