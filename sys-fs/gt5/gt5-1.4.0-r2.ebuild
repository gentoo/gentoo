# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a diff-capable 'du-browser'"
HOMEPAGE="http://gt5.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

KEYWORDS="amd64 ~sparc x86"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="|| ( www-client/links
		www-client/elinks
		www-client/lynx )"

PATCHES=(
	"${FILESDIR}/${P}-bash-shabang.patch"
	"${FILESDIR}/${P}-empty-dirs.patch"
)

src_install() {
		dobin gt5
		doman gt5.1
		dodoc Changelog README
}
