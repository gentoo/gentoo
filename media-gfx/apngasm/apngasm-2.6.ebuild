# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/apngasm/apngasm-2.6.ebuild,v 1.2 2012/05/05 07:00:20 jdhore Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="create an APNG from multiple PNG files"
HOMEPAGE="http://sourceforge.net/projects/apngasm/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng[apng]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S=${WORKDIR}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) --libs libpng --libs zlib)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
