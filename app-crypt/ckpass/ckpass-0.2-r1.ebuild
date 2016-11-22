# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="ncurses based password database client compatible with KeePass 1.x databases"
HOMEPAGE="http://ckpass.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libkpass-6"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}
