# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Python tool for building testable command-line interfaces"
HOMEPAGE="https://github.com/sdispater/cleo"
SRC_URI="https://github.com/sdispater/cleo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

BDEPEND="
	test? (
		dev-python/clikit[${PYTHON_USEDEP}]
		dev-python/crashtest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
