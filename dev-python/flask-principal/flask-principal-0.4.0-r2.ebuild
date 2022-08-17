# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Identity management for flask"
HOMEPAGE="https://pythonhosted.org/Flask-Principal/ https://pypi.org/project/Flask-Principal/"
SRC_URI="
	https://github.com/mattupstate/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"
# pypi tarball is missing tests

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
