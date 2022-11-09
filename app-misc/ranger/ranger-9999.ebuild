# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 xdg

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ranger/ranger.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DESCRIPTION="A vim-inspired file manager for the console"
HOMEPAGE="https://ranger.github.io/"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="virtual/pager"

distutils_enable_tests pytest

src_prepare() {
	# use versioned doc path
	sed -i "s|share/doc/ranger|share/doc/${PF}|" setup.py doc/ranger.1 || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Ranger has many optional dependencies to support enhanced file previews."
		elog "See the README or homepage for more details."
	fi
}
