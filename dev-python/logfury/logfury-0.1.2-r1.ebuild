# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Boilerplate library for logging method calls"
HOMEPAGE="https://github.com/ppolewicz/logfury https://pypi.org/project/logfury/"
SRC_URI="https://github.com/ppolewicz/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${P}-fix-requirements-remove-dev-tests.patch"
)

distutils_enable_tests nose
