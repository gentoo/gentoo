# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/moe/moe-1.6.ebuild,v 1.4 2014/12/06 08:21:12 jer Exp $

EAPI=5

inherit eutils toolchain-funcs unpacker

DESCRIPTION="A powerful and user-friendly console text editor"
HOMEPAGE="http://www.gnu.org/software/moe/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-libs/ncurses
"
DEPEND="
	$(unpacker_src_uri_depends)
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	tc-export CXX PKG_CONFIG
	sed -i \
		-e "/^CXXFLAGS=/d" \
		-e "/^LDFLAGS=/d" \
		-e  "/^CXX=/d" \
		configure || die "sed on configure failed"

	epatch_user

	epatch "${FILESDIR}/${P}-tinfo.patch"
}
