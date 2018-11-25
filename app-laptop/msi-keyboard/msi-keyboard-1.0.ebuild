# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Control backlight of MSI laptop keyboards"
HOMEPAGE="https://github.com/makkarpov/msi-keyboard"
SRC_URI="https://github.com/makkarpov/msi-keyboard/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-libs/hidapi"

src_install()
{
	udev_dorules 99-msi-keyboard.rules
	dobin msi-keyboard
}
