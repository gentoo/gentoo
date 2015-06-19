# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sselp/sselp-9999.ebuild,v 1.4 2013/06/11 15:46:55 jer Exp $

EAPI=5
inherit git-2 toolchain-funcs

DESCRIPTION="Simple X selection printer"
HOMEPAGE="http://tools.suckless.org/sselp"
SRC_URI=""
EGIT_REPO_URI="git://git.suckless.org/sselp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s|^CFLAGS = -std=c99 -pedantic -Wall -Os|CFLAGS += -std=c99 -pedantic -Wall|" \
		-e "s|^LDFLAGS = -s|LDFLAGS +=|" \
		-e "s|^CC = cc|CC = $(tc-getCC)|" \
		config.mk || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README
}
