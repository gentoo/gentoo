# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A library to multiply test cases"
HOMEPAGE="https://pypi.org/project/ddt/ https://github.com/txels/ddt"
SRC_URI="https://github.com/datadriventests/ddt/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose
