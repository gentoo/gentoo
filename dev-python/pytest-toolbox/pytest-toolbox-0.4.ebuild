# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Numerous useful plugins for pytest"
HOMEPAGE="https://pypi.org/project/pytest-toolbox/ https://github.com/samuelcolvin/pytest-toolbox/"
SRC_URI="
	https://github.com/samuelcolvin/pytest-toolbox/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~sparc x86"

BDEPEND="
	test? (
		dev-python/pydantic[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/addopts/d' -i setup.cfg || die
	distutils-r1_src_prepare
}
