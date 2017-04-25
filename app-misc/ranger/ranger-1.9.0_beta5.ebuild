# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ranger/ranger.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DESCRIPTION="A vim-inspired file manager for the console"
HOMEPAGE="http://ranger.nongnu.org/"
LICENSE="GPL-3"
SLOT="0"
IUSE="test"

RDEPEND="virtual/pager"
DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# use versioned doc path
	sed -i "s|share/doc/ranger|share/doc/${PF}|" setup.py doc/ranger.1 || die

	distutils-r1_src_prepare
}

python_test() {
	py.test -v || die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Ranger has many optional dependencies to support enhanced file previews."
		elog "See the README or homepage for more details."
	fi
}
