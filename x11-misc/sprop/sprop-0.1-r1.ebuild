# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="a simple X property utility"
HOMEPAGE="https://tools.suckless.org/x/sprop"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
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

	sed -i \
		-e "s|VERSION|${PV}|g" \
		${PN}.1 || die

	default

	tc-export CC
}

src_compile() { emake sprop; }

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
