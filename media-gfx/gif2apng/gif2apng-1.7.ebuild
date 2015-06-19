# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gif2apng/gif2apng-1.7.ebuild,v 1.1 2012/02/23 07:59:30 radhermit Exp $

EAPI="4"

inherit toolchain-funcs

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

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="-lz" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
