# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="create an APNG from multiple PNG files"
HOMEPAGE="https://sourceforge.net/projects/apngasm/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libpng:0=[apng]
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-string_h.patch #465780
}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) --libs libpng --libs zlib)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
