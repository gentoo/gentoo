# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="ncurses(+),threads(+)"
inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="The ncurses client for canto-daemon"
HOMEPAGE="https://codezen.org/canto-ng/"
SRC_URI="https://github.com/themoken/canto-curses/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="test"
PROPERTIES="test_network"

DEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:=
"
RDEPEND="
	>=net-news/canto-daemon-0.9.1[${PYTHON_USEDEP}]
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}"/canto-curses-0.9.9-drop-pipes-import.patch
	"${FILESDIR}"/canto-curses-0.9.9-fix-ncurses-build.patch
)

python_prepare_all() {
	# https://bugs.gentoo.org/875032
	# https://github.com/themoken/canto-curses/issues/51
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags-only-I ncursesw)"

	# Respect libdir during plugins installation
	sed -i -e "s:lib/canto:$(get_libdir)/canto:" setup.py || die

	# Test fails because of lost site
	rm tests/test-config-function.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local test_file
	for test_file in tests/*; do
		"${EPYTHON}" "${test_file}" || die "Test ${test_file} failed with ${EPYTHON}"
	done
}
