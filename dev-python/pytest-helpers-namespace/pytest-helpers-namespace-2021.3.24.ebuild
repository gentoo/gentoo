# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Provides a helpers pytest namespace"
HOMEPAGE="https://github.com/saltstack/pytest-helpers-namespace"
SRC_URI="
	https://github.com/saltstack/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-forked[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-remove-extra-dep.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "s/@PV@/${PV}/" -i setup.cfg || die
}

python_test() {
	distutils_install_for_testing
	epytest --forked
}
