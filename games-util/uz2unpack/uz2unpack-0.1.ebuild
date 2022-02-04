# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="UZ2 Decompressor for UT2003/UT2004"
HOMEPAGE="http://icculus.org/cgi-bin/ezmlm/ezmlm-cgi?42:mss:1013:200406:kikgppboefcimdbadcdo"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS=-lz ${PN}
}

src_install() {
	dobin ${PN}
	dodoc README
}
