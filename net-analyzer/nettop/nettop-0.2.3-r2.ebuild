# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="top-like program for network activity"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~arm ppc x86"

DEPEND="
	sys-libs/slang
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc411.patch
	"${FILESDIR}"/${P}-offbyone.patch
)

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dosbin nettop
	dodoc ChangeLog README THANKS
}
