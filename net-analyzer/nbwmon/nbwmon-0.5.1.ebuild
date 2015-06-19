# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nbwmon/nbwmon-0.5.1.ebuild,v 1.2 2014/10/30 15:26:02 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="ncurses bandwidth monitor"
HOMEPAGE="http://causes.host.funtoo.org/?p=nbwmon https://github.com/causes-/nbwmon"
SRC_URI="https://github.com/causes-/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.3-tinfo.patch
	tc-export CC PKG_CONFIG
}
