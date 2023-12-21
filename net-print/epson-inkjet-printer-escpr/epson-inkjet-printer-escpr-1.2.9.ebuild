# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="2"
MY_P="${PN}${SLOT}-${PV}"

DESCRIPTION="Epson Inkjet Printer Driver 2 (ESC/P-R) for Linux"
HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/15/33/96/607198a4f064daa9e7931913eaf27f3a58125f2b/${MY_P}-1.tar.gz"
LICENSE="EPSON LGPL-2.1+"
KEYWORDS="~amd64"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--with-cupsfilterdir="${EPREFIX}/usr/libexec/cups/filter"
		--with-cupsppddir="${EPREFIX}/usr/share/ppd"
}

src_install() {
	default

	find "${ED}/usr/lib64" -name "*.la" -delete \
		|| die "Removal of libtool files (.la) has failed."
}
