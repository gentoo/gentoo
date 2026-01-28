# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} pypy3_11 )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="
	https://github.com/beetbox/confuse/
	https://pypi.org/project/confuse/
"
SRC_URI="https://github.com/beetbox/confuse/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	'dev-python/sphinx-rtd-theme'
