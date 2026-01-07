# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

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
	|| ( sys-firmware/edk2-bin sys-firmware/edk2 )"
BDEPEND="virtual/pandoc"

distutils_enable_tests pytest

src_compile() {
	distutils-r1_src_compile

	./tools/make-man-page.sh || die
}

src_install() {
	distutils-r1_src_install

	doman mkosi/resources/man/*.{1,7}
}

pkg_postinst() {
	optfeature "debian support" dev-util/debootstrap
}
