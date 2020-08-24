# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="screen(1) frontend that is designed to be a session handler"
HOMEPAGE="https://sourceforge.net/projects/screenie/"
SRC_URI="http://pubwww.hsz-t.ch/~mgloor/data/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 sparc x86"
IUSE=""

RDEPEND="app-misc/screen"

PATCHES=( "${FILESDIR}/${PN}-CVE-2008-5371.patch" )

src_install() {
	dobin screenie
	default
}
