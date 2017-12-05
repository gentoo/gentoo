# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
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
