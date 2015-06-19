# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gif2apng/gif2apng-1.8.ebuild,v 1.1 2013/09/16 15:27:51 radhermit Exp $

EAPI="5"

inherit toolchain-funcs eutils

DESCRIPTION="create an APNG from a GIF"
HOMEPAGE="http://sourceforge.net/projects/gif2apng/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
