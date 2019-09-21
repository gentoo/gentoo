# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="list window names"
HOMEPAGE="https://tools.suckless.org/x/lsw"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	sed -i config.mk \
		-e '/^CC/d' \
		-e '/^CFLAGS/{s| -Os||;s|=|+=|}' \
		-e '/^LDFLAGS/{s|=|+=|;s| -s||}' || die
	sed -i \
		-e 's|^\t@|\t|g' \
		-e '/^\techo/d' \
		Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	doman ${PN}.1
	dobin ${PN}
}
