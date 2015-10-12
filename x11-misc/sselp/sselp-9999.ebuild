# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
