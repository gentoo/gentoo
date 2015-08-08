# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OFFICE_EXTENSIONS=(
	"${PN}addon.oxt"
)
inherit office-ext-r1

DESCRIPTION="Mathematics Formula Editor Extension"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/dmaths"
SRC_URI="http://extensions.libreoffice.org/extension-center/${PN}/releases/${PV}/${PN}addon.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
