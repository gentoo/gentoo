# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

EGIT_REPO_URI="https://github.com/XVilka/set_opacity.git"

DESCRIPTION="Tool for set real compositing for windows through window's id, process' pid etc."
HOMEPAGE="https://github.com/XVilka/set_opacity"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXrender"
RDEPEND=${DEPEND}

KEYWORDS=""

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin set_opacity
}
