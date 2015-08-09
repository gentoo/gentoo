# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/tarsync/tarsync-0.2.1-r1.ebuild?view=markup"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux"
IUSE=""

DEPEND=">=dev-util/diffball-0.7"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
	epatch "${FILESDIR}"/${P}-gcc5.patch
}

src_install() {
	dobin "${PN}" #make install doesn't support prefix
}
