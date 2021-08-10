# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Easy to use command-line interface for python modules"
HOMEPAGE="https://github.com/ponty/entrypoint2"
SRC_URI="https://github.com/ponty/entrypoint2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? (
	dev-python/easyprocess[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
