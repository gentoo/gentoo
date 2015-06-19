# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/uz2unpack/uz2unpack-0.1.ebuild,v 1.9 2014/03/26 09:51:50 ulm Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="UZ2 Decompressor for UT2003/UT2004"
HOMEPAGE="http://icculus.org/cgi-bin/ezmlm/ezmlm-cgi?42:mss:1013:200406:kikgppboefcimdbadcdo"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="sys-libs/zlib"

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS=-lz ${PN}
}

src_install() {
	dobin ${PN}
	dodoc README
}
