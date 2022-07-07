# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="PyMacaroons is a Python implementation of Macaroons."
HOMEPAGE="
	https://github.com/ecordell/pymacaroons
	https://pypi.org/project/pymacaroons/
"
SRC_URI="https://github.com/ecordell/pymacaroons/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests are incompatible with dev-python/hypothesis::gentoo. This package needs
# <2.0.0, because needed hypothesis.specifiers module was removed in 2.0.0.
RESTRICT="test"

RDEPEND="
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
