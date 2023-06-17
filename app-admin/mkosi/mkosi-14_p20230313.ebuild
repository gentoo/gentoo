# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
COMMIT='33a33967819443ee03137459eec85cd5db6c4bad'

inherit distutils-r1 optfeature

DESCRIPTION="Build Bespoke OS Images"
HOMEPAGE="https://github.com/systemd/mkosi"
SRC_URI="https://github.com/systemd/mkosi/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	app-emulation/qemu
	dev-vcs/git
	sys-apps/bubblewrap
	sys-apps/portage
	sys-apps/systemd
	sys-firmware/edk2-ovmf"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "For debian support: " dev-util/debootstrap
}
