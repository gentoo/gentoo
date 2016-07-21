# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="xDMS - Amiga DMS disk image decompressor"
HOMEPAGE="http://zakalwe.fi/~shd/foss/xdms"
SRC_URI="http://zakalwe.fi/~shd/foss/xdms/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	sed -i -e 's:COPYING::' "${S}"/Makefile.in
}

src_compile() {
	./configure --prefix=/usr --package-prefix="${D}" \
		|| die "configure failed."
	emake CC="$(tc-getCC)" || die "emake failed."
}

src_install() {
	emake install || die "emake install failed."
	prepalldocs
}
