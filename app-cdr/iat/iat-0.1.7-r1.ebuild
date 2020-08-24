# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="BIN, MDF, PDI, CDI, NRG, and B5I converters"
HOMEPAGE="https://www.berlios.de/software/iso9660-analyzer-tool"
SRC_URI="https://download.sourceforge.net/iat.berlios/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

src_configure() {
	econf  \
		--includedir="${EPREFIX}/usr/include/${PN}"
}
