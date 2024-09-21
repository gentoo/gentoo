# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_PN=asahi-installer

DESCRIPTION="Asahi FW extraction script"
HOMEPAGE="https://asahilinux.org"
SRC_URI="https://github.com/AsahiLinux/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

DEPEND=">=sys-apps/asahi-scripts-20230606"
RDEPEND="${DEPEND}
	app-arch/lzfse
	sys-kernel/linux-firmware
"

src_install() {
	distutils-r1_src_install
	keepdir /lib/firmware/vendor/
}

pkg_postinst() {
	elog "Asahi vendor firmware update script"
	elog "Please run 'asahi-fwupdate' after each update of this package."
}
