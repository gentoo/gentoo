# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Tool for set real compositing for windows through window's id, process' pid etc."
HOMEPAGE="https://github.com/XVilka/set_opacity"
SRC_URI="https://github.com/XVilka/set_opacity/archive-tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXrender"
RDEPEND=${DEPEND}

S="${WORKDIR}/x11-tools-set_opacity"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin set_opacity
}
