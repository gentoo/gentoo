# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base toolchain-funcs

DESCRIPTION="Utilities for Intersil Prism2/2.5/3 based IEEE 802.11b wireless LAN products"
HOMEPAGE="http://hostap.epitest.fi/"
SRC_URI="http://hostap.epitest.fi/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin hostap_{crypt_conf,diag,fw_load,io_debug,rid}
	dosbin prism2_{param,srec}
	dosbin split_combined_hex

	dodoc README
}
