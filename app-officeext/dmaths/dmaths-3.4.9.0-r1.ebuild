# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFFICE_EXTENSIONS=(
	"${PN}addon.oxt"
)
inherit office-ext-r1

DESCRIPTION="Mathematics Formula Editor Extension"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/dmaths"
SRC_URI="https://extensions.libreoffice.org/extension-center/${PN}/releases/${PV}/${PN}addon.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
