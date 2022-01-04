# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="https://github.com/beetbox/confuse"
SRC_URI="https://github.com/beetbox/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	'dev-python/sphinx_rtd_theme'
