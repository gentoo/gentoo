# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="Boilerplate library for logging method calls"
HOMEPAGE="https://github.com/ppolewicz/logfury https://pypi.org/project/logfury/"
SRC_URI="https://github.com/ppolewicz/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-fix-requirements-remove-dev-tests.patch"
)

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		dev-python/testfixtures[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

distutils_enable_tests setup.py
