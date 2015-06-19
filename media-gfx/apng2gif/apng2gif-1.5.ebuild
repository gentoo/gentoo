# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/apng2gif/apng2gif-1.5.ebuild,v 1.1 2012/02/23 07:55:16 radhermit Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="create a GIF from an APNG"
HOMEPAGE="http://sourceforge.net/projects/apng2gif/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="-lz" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
