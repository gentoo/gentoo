# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Python Command-line Application Tools"
HOMEPAGE="https://github.com/kennethreitz-archive/clint"
SRC_URI="https://github.com/kennethreitz-archive/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE="examples"

# https://github.com/kennethreitz-archive/clint/pull/180
PATCHES=( "${FILESDIR}/${P}-disable-args-dependency.patch" )

distutils_enable_sphinx docs --no-autodoc
distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
