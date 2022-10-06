# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

MY_PN=xdot.py
EGIT_REPO_URI="https://github.com/jrfonseca/${MY_PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	SRC_URI=""
else
	KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~sparc x86"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit ${GIT_ECLASS} distutils-r1 virtualx

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"

LICENSE="LGPL-2+"
SLOT="0"
PATCHES=( "${FILESDIR}/backport-2ace1a1-issue-92.patch" )

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-gfx/graphviz
	test? ( x11-libs/gtk+:3 )
"
RDEPEND="${DEPEND}"

run_test() {
	cd tests && "${EPYTHON}" ../test.py *.dot graphs/*.gv
	return "${?}"
}

python_test() {
	virtx run_test
}
