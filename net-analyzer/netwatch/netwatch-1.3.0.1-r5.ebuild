# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Ethernet/PPP IP Packet Monitor"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${PN}-$(ver_rs 3 -).tgz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-append_ldflags.patch
	"${FILESDIR}"/${P}-open.patch
	"${FILESDIR}"/${P}-fix-fortify.patch
	"${FILESDIR}"/${P}-do-not-call.patch
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-lto-mismatch.patch
	"${FILESDIR}"/${P}-clang16.patch
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
