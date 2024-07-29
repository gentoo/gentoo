# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 optfeature

DESCRIPTION="Build Bespoke OS Images"
HOMEPAGE="https://github.com/systemd/mkosi"
SRC_URI="https://github.com/systemd/mkosi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	app-emulation/qemu
	sys-apps/bubblewrap
	sys-apps/systemd
	|| ( sys-firmware/edk2-ovmf-bin sys-firmware/edk2-ovmf )"
BDEPEND="virtual/pandoc"

distutils_enable_tests pytest

src_compile() {
	distutils-r1_src_compile

	./tools/make-man-page.sh || die
}

src_install() {
	distutils-r1_src_install

	doman mkosi/resources/mkosi.1
}

pkg_postinst() {
	optfeature "For debian support: " dev-util/debootstrap
}
