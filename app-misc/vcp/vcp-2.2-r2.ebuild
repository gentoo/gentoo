# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Copy files/directories in a curses interface"
HOMEPAGE="http://members.iinet.net.au/~lynx/vcp/"
SRC_URI="http://members.iinet.net.au/~lynx/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

DOCS=( Changelog README INSTALL )
PATCHES=(
	"${FILESDIR}"/${PN}-2.2-tinfo.patch
)

src_compile() {
	filter-lfs-flags
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	insinto /etc
	newins "${PN}.conf.sample" "${PN}.conf"
	einstalldocs
}
