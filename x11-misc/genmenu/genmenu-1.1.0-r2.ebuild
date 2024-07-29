# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="menu generator for *box, WindowMaker, and Enlightenment"
HOMEPAGE="http://f00l.de/genmenu/"
SRC_URI="http://f00l.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="app-shells/bash"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2.patch
	"${FILESDIR}"/${P}-remove-openbox-support.patch
)

src_install() {
	dobin genmenu
	einstalldocs
}
