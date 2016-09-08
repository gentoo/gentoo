# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Testing-Framework for guile"
HOMEPAGE="http://gna.org/projects/greg/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="static-libs"

RDEPEND=">=dev-scheme/guile-1.8"
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-guile2.patch
	)

src_test() {
	cd test || die
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${BUILD_DIR}/src/.libs"
	export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:${BUILD_DIR}/src/"
	guile -s "${S}"/src/greg || die
}
