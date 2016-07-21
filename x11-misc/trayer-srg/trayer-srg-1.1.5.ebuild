# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="trayer fork with multi monitor support, cleaned up codebase and other fancy stuff"
HOMEPAGE="https://github.com/sargon/trayer-srg"
SRC_URI="https://github.com/sargon/${PN}/tarball/${P/-srg/} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake DEVEL=1 TARGET=${PN} CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc CHANGELOG CREDITS README TODO
}
