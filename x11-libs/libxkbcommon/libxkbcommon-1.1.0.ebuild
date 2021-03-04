# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/xkbcommon/${PN}"
else
	SRC_URI="https://github.com/xkbcommon/libxkbcommon/releases/download/xkbcommon-${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

PYTHON_COMPAT=( python3_{7..9} )

inherit meson multilib-minimal ${GIT_ECLASS} python-any-r1

DESCRIPTION="keymap handling library for toolkits and window systems"
HOMEPAGE="https://xkbcommon.org/ https://github.com/xkbcommon/libxkbcommon/"
LICENSE="MIT"
IUSE="X doc static-libs test"
RESTRICT="!test? ( test )"
SLOT="0"

BDEPEND="
	sys-devel/bison
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
"
RDEPEND="
	X? ( >=x11-libs/libxcb-1.10:=[${MULTILIB_USEDEP},xkb] )
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	x11-misc/compose-tables
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library="$(usex static-libs both shared)"
		-Dxkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		-Denable-wayland=false # Demo applications
		$(meson_use X enable-x11)
		$(meson_use doc enable-docs)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
