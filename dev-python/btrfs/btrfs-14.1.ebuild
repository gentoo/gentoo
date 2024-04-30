# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python module to inspect btrfs filesystems"
HOMEPAGE="https://github.com/knorrie/python-btrfs"
SRC_URI="https://github.com/knorrie/python-${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

S="${WORKDIR}/python-${P}"

python_install_all() {
	if use examples; then
		# skip symlink meant for development
		rm examples/btrfs
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}
