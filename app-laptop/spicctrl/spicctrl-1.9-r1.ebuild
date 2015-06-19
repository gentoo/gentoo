# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/spicctrl/spicctrl-1.9-r1.ebuild,v 1.2 2012/11/20 20:44:22 ago Exp $

EAPI=4

inherit base toolchain-funcs

DESCRIPTION="tool for the sonypi-Device (found in Sony Vaio Notebooks)"
HOMEPAGE="http://www.popies.net/sonypi/"
SRC_URI="http://www.popies.net/sonypi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin spicctrl
}
