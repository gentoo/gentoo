# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A plugin for pytest that provides access to test session metadata"
HOMEPAGE="https://github.com/pytest-dev/pytest-metadata/"
SRC_URI="
	https://github.com/pytest-dev/pytest-metadata/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	<dev-python/pytest-8[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-6.2.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
