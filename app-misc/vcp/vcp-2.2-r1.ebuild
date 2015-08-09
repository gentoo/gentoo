# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="copy files/directories in a curses interface"
HOMEPAGE="http://members.iinet.net.au/~lynx/vcp/"
SRC_URI="http://members.iinet.net.au/~lynx/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i Makefile -e '/-o vcp/s|$(CFLAGS)|& $(LDFLAGS)|' || die "sed Makefile"
}

src_compile() {
	filter-lfs-flags
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin vcp || die "dobin failed"
	doman vcp.1 || die "doman failed"
	insinto /etc
	newins vcp.conf.sample vcp.conf || die "newins failed"
	dodoc Changelog README INSTALL || die "dodoc failed"
}
