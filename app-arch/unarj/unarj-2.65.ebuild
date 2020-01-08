# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://www.arjsoftware.com/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="arj"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-CAN-2004-0947.patch
	"${FILESDIR}"/${P}-sanitation.patch
	"${FILESDIR}"/${P}-gentoo-fbsd.patch
	"${FILESDIR}"/${PN}-2.65-Wformat-security.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin unarj
	dodoc unarj.txt technote.txt
}
