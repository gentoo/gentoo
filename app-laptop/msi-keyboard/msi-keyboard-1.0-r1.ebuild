# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="Control backlight of MSI laptop keyboards"
HOMEPAGE="https://github.com/makkarpov/msi-keyboard"
SRC_URI="https://github.com/makkarpov/msi-keyboard/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/hidapi"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-r1-makefile.patch
	"${FILESDIR}"/${P}-gcc12.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	udev_dorules 99-msi-keyboard.rules
	dobin msi-keyboard
}

pkg_prerm() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
