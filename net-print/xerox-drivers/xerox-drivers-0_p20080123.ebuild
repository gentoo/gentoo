# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

MY_PN="LinuxCupsPrinterPkg"

DESCRIPTION="PPD files of XEROX printers (CopyCentre, DocuPrint, Phaser, WorkCentre) for CUPS printing system"
HOMEPAGE="http://www.support.xerox.com/go/getfile.asp?objid=61334&prodID=6180"
SRC_URI="http://download.support.xerox.com/pub/drivers/DocuColor_2006/drivers/unix/en/${MY_PN}.tar.gz"

LICENSE="Xerox"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="bindist fetch"

DEPEND=""
RDEPEND="net-print/cups"

S="${WORKDIR}/${MY_PN}"

# Suppressing warnings from the incorrect upstream tarball

src_unpack() {
	unpack ${A} 2> /dev/null
}

src_install() {
	dodoc Readme.txt || die "missing Readme.txt"
	insinto /usr/share/cups/model
	doins *.ppd || die "missing ppd files"
}
