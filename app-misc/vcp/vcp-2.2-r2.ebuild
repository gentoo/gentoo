# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Copy files/directories in a curses interface"
HOMEPAGE="http://members.iinet.net.au/~lynx/vcp/"
SRC_URI="http://members.iinet.net.au/~lynx/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

DOCS=( Changelog README INSTALL )

src_prepare() {
	default
	sed -i Makefile -e '/-o vcp/s|$(CFLAGS)|& $(LDFLAGS)|' || die "sed Makefile"
}

src_compile() {
	filter-lfs-flags
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	insinto /etc
	newins "${PN}.conf.sample" "${PN}.conf"
	einstalldocs
}
