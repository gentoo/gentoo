# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Python library for communicating with Pocket Science Lab"
HOMEPAGE="https://pslab.io"
SRC_URI="https://github.com/fossasia/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyqtgraph[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.1-sys_version.patch
	"${FILESDIR}"/${PN}-1.0.1-no_install_udev_rules.patch
)

distutils_enable_sphinx docs
