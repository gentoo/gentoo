# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux"

DEPEND=">=dev-util/diffball-0.7"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-gcc5.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin tarsync #make install doesn't support prefix
	einstalldocs
}
