# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

MY_PN="${PN/xorg-/xorg}"
MY_P="${MY_PN}-${PV}"

EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/proto/${MY_PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson python-any-r1

DESCRIPTION="X.Org combined protocol headers"
HOMEPAGE="https://gitlab.freedesktop.org/xorg/proto/xorgproto"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	SRC_URI="https://xorg.freedesktop.org/archive/individual/proto/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/python-libevdev[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""

python_check_deps() {
	has_version -b "dev-python/python-libevdev[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/doc/{xorgproto,${P}} || die
}
