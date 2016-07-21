# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="An alternative to the FLAC reference encoder"
HOMEPAGE="http://flake-enc.sourceforge.net"
SRC_URI="mirror://sourceforge/flake-enc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

src_compile() {
	local myconf

	if ! use debug; then
		myconf="${myconf} --disable-debug"
	fi

	./configure --cc="$(tc-getCC)" --prefix="${D}"/usr \
		--disable-opts --disable-strip ${myconf} || die "configure failed."

	emake -j1 || die "emake failed."
}

src_install() {
	emake install || die "emake install failed."
	dodoc Changelog README
}
