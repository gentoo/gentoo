# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sprop/sprop-0.1.ebuild,v 1.3 2012/12/10 19:01:15 jer Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="a simple X property utility"
HOMEPAGE="http://tools.suckless.org/sprop"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-proto/xproto
"
src_prepare() {
	sed -i \
		-e '/^CC/d' \
		-e '/^CFLAGS/s| =| +=|;s| -Os||g' \
		-e '/^LDFLAGS/s|= -s|+=|g' \
		config.mk || die

	sed -i \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die

	tc-export CC
}

src_compile() { emake sprop; }

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
