# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/set_opacity/set_opacity-1.0.ebuild,v 1.3 2012/02/14 21:41:19 ulm Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Tool for set real compositing for windows through window's id, process' pid etc."
HOMEPAGE="https://gitorious.org/x11-tools/set_opacity"
SRC_URI="https://gitorious.org/x11-tools/set_opacity/archive-tarball/${PV} -> ${P}.tar.gz"

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
