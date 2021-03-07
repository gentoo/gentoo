# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="https://github.com/beetbox/confuse"
SRC_URI="https://github.com/beetbox/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/pyproject2setuppy[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests nose
distutils_enable_sphinx docs \
	'dev-python/sphinx_rtd_theme'
