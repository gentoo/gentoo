# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Knocker is an easy to use security port scanner written in C"
HOMEPAGE="http://knocker.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-fency.patch
	"${FILESDIR}"/${P}-free.patch
	"${FILESDIR}"/${P}-knocker_user_is_root.patch
	"${FILESDIR}"/${P}-fno-common.patch
)
DOCS=( AUTHORS BUGS ChangeLog NEWS README TO-DO )

src_configure() {
	tc-export CC
	default
}
