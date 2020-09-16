# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Japanese dictionary for ChaSen"
HOMEPAGE="http://sourceforge.jp/projects/ipadic/"
SRC_URI="mirror://sourceforge.jp/${PN}/24435/${P}.tar.gz"

LICENSE="ipadic"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND=">=app-text/chasen-2.3.1"

PATCHES=( "${FILESDIR}"/${PF}-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	insinto /etc
	doins chasenrc
}
