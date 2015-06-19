# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/ct2n/ct2n-1.4.0-r1.ebuild,v 1.2 2013/04/27 08:16:23 scarabeus Exp $

EAPI=5

MY_P="converttexttonumber-${PV}"
OFFICE_EXTENSIONS=(
	"${MY_P}.oxt"
)
inherit office-ext-r1

DESCRIPTION="Extension for converting text to numbers"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/ct2n-convert-text-to-number-and-dates"
SRC_URI="http://extensions.libreoffice.org/extension-center/${PN}-convert-text-to-number-and-dates/releases/${PV}/${MY_P}.oxt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
