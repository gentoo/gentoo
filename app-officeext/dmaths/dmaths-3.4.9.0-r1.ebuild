# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/dmaths/dmaths-3.4.9.0-r1.ebuild,v 1.2 2013/04/27 08:21:49 scarabeus Exp $

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
