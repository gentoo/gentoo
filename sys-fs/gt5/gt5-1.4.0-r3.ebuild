# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A diff-capable 'du-browser'"
HOMEPAGE="https://gt5.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="|| (
	www-client/links
	www-client/elinks
	www-client/lynx
)"

PATCHES=(
	"${FILESDIR}/${P}-bash-shabang.patch"
	"${FILESDIR}/${P}-empty-dirs.patch"
)

src_install() {
		dobin gt5
		doman gt5.1
		dodoc Changelog README
}
