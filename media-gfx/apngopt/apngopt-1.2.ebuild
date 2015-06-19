# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/apngopt/apngopt-1.2.ebuild,v 1.1 2012/10/03 09:55:32 radhermit Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="optimize APNG images"
HOMEPAGE="http://sourceforge.net/projects/apng/"
SRC_URI="mirror://sourceforge/apng/APNG_Optimizer/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S=${WORKDIR}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) --libs zlib)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
