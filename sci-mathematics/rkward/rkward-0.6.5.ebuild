# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_DOC_DIRS="doc"
KDE_HANDBOOK="optional"
WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="IDE for the R-project"
HOMEPAGE="https://rkward.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep katepart)
	dev-lang/R
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

src_configure() {
	# to have it compatible with R which had a bad R_HOME
	unset R_HOME
	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install
	# avoid file collision with kate
	rm "${ED}"/usr/share/apps/katepart/syntax/r.xml || die
}
