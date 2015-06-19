# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/barcode/barcode-1.3.5.0-r1.ebuild,v 1.2 2013/04/27 08:14:56 scarabeus Exp $

EAPI=5

OFFICE_EXTENSIONS=(
	"${PN}_${PV}.oxt"
)
inherit office-ext-r1

DESCRIPTION="Extension for reading barcodes"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/barcode"
SRC_URI="http://extensions.libreoffice.org/extension-center/${PN}/releases/${PV}/${PN}_${PV}.oxt"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
