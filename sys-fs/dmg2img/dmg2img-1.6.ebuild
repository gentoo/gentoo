# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dmg2img/dmg2img-1.6.ebuild,v 1.2 2009/09/07 19:10:30 dirtyepic Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Converts Apple DMG files to standard HFS+ images"
HOMEPAGE="http://vu1tur.eu.org/tools"
#SRC_URI="http://vu1tur.eu.org/tools/download.pl?${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/openssl
	app-arch/bzip2
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-apps/sed"

src_prepare() {
	sed -i -e 's:-s:$(LDFLAGS):g' Makefile || die "sed failed"
}

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dosbin dmg2img vfdecrypt || die "dosbin failed"
	dodoc README
}
