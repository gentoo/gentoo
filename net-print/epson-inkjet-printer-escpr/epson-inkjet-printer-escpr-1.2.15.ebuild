# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}2-${PV}"

DESCRIPTION="Epson Inkjet Printer Driver 2 (ESC/P-R) for Linux"
HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/16/06/85/fddc1d5996d0cab4dceea35852a2e430fb124993/${MY_P}-1.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="EPSON LGPL-2.1+"
SLOT="2"
KEYWORDS="amd64"

QA_FLAGS_IGNORED="/usr/lib64/libescpr2.so.1.0.0"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	#"${FILESDIR}/gcc-no-implicit-function-declaration-${PV}.patch"
	"${FILESDIR}/gcc-no-implicit-function-declaration-$(ver_cut 1-2 ${PV}).patch"
)

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
