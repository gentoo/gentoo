# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edos2unix

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"

# https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr.php
# Use the "source package for arm CPU" to get a tarball instead of an srpm.
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/16/21/81/74d098a47c3a616713079c9cd5904b468bb33dea/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-warnings.patch"
	"${FILESDIR}/${PN}-1.7.7-fnocommon.patch"
	"${FILESDIR}/${PN}-1.8-missing-include.patch"
)

src_prepare() {
	local f
	for f in $(find ./ -type f || die); do
		edos2unix "${f}"
	done

	eautoreconf
	default
}

src_configure() {
	econf --disable-shared

	# Makefile calls ls to generate a file list which is included in Makefile.am
	# Set the collation to C to avoid automake being called automatically
	unset LC_ALL
	export LC_COLLATE=C
}

src_install() {
	emake -C ppd DESTDIR="${D}" install
	emake -C src DESTDIR="${D}" install
	einstalldocs
}
