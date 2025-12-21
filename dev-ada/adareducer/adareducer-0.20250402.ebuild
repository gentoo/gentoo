# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

CommitId=eb523bc674ac0df1c1e41c1871ffece9c8468214
DESCRIPTION="Ada Reducer"
HOMEPAGE="https://github.com/AdaCore/adareducer"
SRC_URI="https://github.com/AdaCore/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ada/libadalang[${PYTHON_SINGLE_USEDEP}"]
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ada/e3-testsuite )"

src_prepare() {
	cd ada_reducer
	mv types.py typesA.py || die
	sed -i \
		-e "s:ada_reducer.types:ada_reducer.typesA:" \
		-e "s:\\o/:\\\\o/:" \
		engine.py \
		delete_empty_units.py \
		hollow_body.py \
		remove_statement.py \
		remove_subprograms.py \
		remove_generic_nodes.py \
		remove_trivias.py \
		remove_imports.py \
		|| die
	cd -
	distutils-r1_src_prepare
}

src_test() {
	${EPYTHON} testsuite/testsuite.py || die
}
