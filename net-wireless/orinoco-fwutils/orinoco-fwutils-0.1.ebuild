# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="ORiNOCO IEEE 802.11 wireless LAN firmware utilities"
HOMEPAGE="http://www.nongnu.org/orinoco/"
SRC_URI="mirror://sourceforge/orinoco/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""
RDEPEND="app-arch/unzip
		dev-lang/perl
		net-misc/wget
		sys-apps/coreutils
		sys-apps/sed"

src_unpack() {
	unpack ${A}

	# fix paths
	for file in "${S}"/get_*; do
		sed -i \
			-e "s:parse_:/usr/bin/parse_:g" \
			-e "s:\./::g" \
		${file}
	done
}

src_install() {
	dobin get_* parse_*

	dodoc README
}

pkg_postinst() {
	einfo
	einfo "After fetching the firmware using these tools you must place it in"
	einfo "/lib/firmware/ for the kernel driver to be able to load it."
	einfo
}
