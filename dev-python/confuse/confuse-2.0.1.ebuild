# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 pypi

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="
	https://github.com/beetbox/confuse/
	https://pypi.org/project/confuse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	'dev-python/sphinx-rtd-theme'
