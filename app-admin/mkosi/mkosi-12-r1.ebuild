# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Build Bespoke OS Images"
HOMEPAGE="https://github.com/systemd/mkosi"
SRC_URI="https://github.com/systemd/mkosi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	dev-vcs/git
	sys-apps/portage
	sys-apps/systemd
	app-emulation/qemu
	sys-firmware/edk2-ovmf"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "For debian support: " dev-util/debootstrap
}
