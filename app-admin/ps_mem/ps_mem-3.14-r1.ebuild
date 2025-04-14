# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A utility to report core memory usage per program"
HOMEPAGE="https://github.com/pixelb/ps_mem"
SRC_URI="https://github.com/pixelb/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 sparc x86"

python_install() {
	distutils-r1_python_install --install-scripts="${EPREFIX}/usr/sbin"
}

python_install_all() {
	distutils-r1_python_install_all
	doman ${PN}.1
}
