# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/08/70/14/e33b7a89e843b3ac97dcab773f03fbac7769f147/epson-inkjet-printer-escpr-1.6.33-1lsb3.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/1.6.5-warnings.patch" )

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
