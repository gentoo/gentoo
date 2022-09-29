# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="top-like program for network activity"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

RDEPEND="
	sys-libs/slang
	net-libs/libpcap"
DEPEND="${RDEPEND}"

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
	einstalldocs
}
