# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="A deep merge tool for Python"
HOMEPAGE="
	https://github.com/clarketm/mergedeep/
	https://pypi.org/project/mergedeep/
"
SRC_URI="
	https://github.com/clarketm/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/alabaster \
	dev-python/recommonmark
