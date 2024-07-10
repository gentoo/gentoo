# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

MY_PN=xdot.py
EGIT_REPO_URI="https://github.com/jrfonseca/${MY_PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit ${GIT_ECLASS} distutils-r1 virtualx

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"

LICENSE="LGPL-2+"
SLOT="0"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-gfx/graphviz
	test? ( x11-libs/gtk+:3[X] )
"
RDEPEND="${DEPEND}"

run_test() {
	cd tests && "${EPYTHON}" ../test.py *.dot graphs/*.gv
	return "${?}"
}

python_test() {
	virtx run_test
}
