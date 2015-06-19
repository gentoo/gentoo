# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.7.82.ebuild,v 1.1 2015/01/06 16:15:05 radhermit Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush/"
SRC_URI="system-libs? ( mirror://sourceforge/pmt/${P}-nolib.tar.xz )
	!system-libs? ( mirror://sourceforge/pmt/${P}.tar.xz )"

LICENSE="pngcrush"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+system-libs"

RDEPEND="
	system-libs? (
		>=media-libs/libpng-1.5:0=
		sys-libs/zlib:=
	)"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

pkg_setup() {
	use system-libs && S+="-nolib"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dohtml ChangeLog.html
}
