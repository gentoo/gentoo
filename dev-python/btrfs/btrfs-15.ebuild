# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_P=python-btrfs-${PV}
DESCRIPTION="Python module to inspect btrfs filesystems"
HOMEPAGE="
	https://github.com/knorrie/python-btrfs/
	https://pypi.org/project/btrfs/
"
SRC_URI="
	https://github.com/knorrie/python-btrfs/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"

python_install_all() {
	if use examples; then
		# skip symlink meant for development
		rm examples/btrfs || die
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}
