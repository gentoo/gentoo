# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Init-hook to use the same Pylint with different virtual environments"
HOMEPAGE="
	https://pypi.org/project/pylint-venv/
	https://github.com/jgosmann/pylint-venv/
"
SRC_URI="
	https://github.com/jgosmann/pylint-venv/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pylint[${PYTHON_USEDEP}]
"
