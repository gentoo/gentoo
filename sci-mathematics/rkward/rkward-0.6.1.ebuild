# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_DOC_DIRS="doc"
KDE_HANDBOOK="optional"
KDE_LINGUAS="ca cs da de el es fr it lt pl tr zh_CN"

inherit kde4-base

DESCRIPTION="IDE for the R-project"
HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="mirror://sourceforge/rkward/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-lang/R
	$(add_kdebase_dep katepart)"
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
