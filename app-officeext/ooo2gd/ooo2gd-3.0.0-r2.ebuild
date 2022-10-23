# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFFICE_REQ_USE="java"

OFFICE_EXTENSIONS=(
	"${PN}_${PV}.oxt"
)
inherit office-ext-r1

DESCRIPTION="Extension for export to Google docs, zoho and WebDAV"
HOMEPAGE="https://code.google.com/p/ooo2gd/"
SRC_URI="https://ooo2gd.googlecode.com/files/${PN}_${PV}.oxt"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
