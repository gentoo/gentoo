# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV="${PV}-2"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Ethernet/PPP IP Packet Monitor"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://p5n.pp.ru/~sergej/dl/2023/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0.1-append_ldflags.patch
	"${FILESDIR}"/${PN}-1.3.0.1-do-not-call.patch
	"${FILESDIR}"/${PN}-1.3.0.1-includes.patch
	"${FILESDIR}"/${PN}-1.3.0.1-tinfo.patch
	"${FILESDIR}"/${PN}-1.3.0.1-fno-common.patch
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-clang16_part2.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${PN}-1.3.0.1-gcc15.patch
)

src_prepare() {
	default

	eautoreconf

	append-flags -fno-strict-aliasing #861203
}

src_install() {
	dosbin netresolv netwatch
	doman netwatch.1
	einstalldocs

	docinto html
	dodoc NetwatchKeyCommands.html
}
