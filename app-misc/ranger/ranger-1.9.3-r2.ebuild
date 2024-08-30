# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="ncurses"
inherit distutils-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ranger/ranger.git"
else
	SRC_URI="https://github.com/ranger/ranger/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv x86"
fi

DESCRIPTION="Vim-inspired file manager for the console"
HOMEPAGE="https://ranger.github.io/"

LICENSE="GPL-3"
SLOT="0"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-color-crash-fix.patch
)

src_prepare() {
	distutils-r1_src_prepare

	sed -i "s|share/doc/ranger|share/doc/${PF}|" setup.py doc/ranger.1 || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "${PN^} has many optional dependencies to support enhanced file previews."
		elog "See ${EROOT}/usr/share/doc/${PF}/README.md* for more details."
	fi
}
