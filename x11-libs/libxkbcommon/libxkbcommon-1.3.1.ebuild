# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/xkbcommon/${PN}"
else
	SRC_URI="https://xkbcommon.org/download/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86"
fi

PYTHON_COMPAT=( python3_{7..10} )

inherit meson-multilib ${GIT_ECLASS} python-any-r1 virtualx

DESCRIPTION="keymap handling library for toolkits and window systems"
HOMEPAGE="https://xkbcommon.org/ https://github.com/xkbcommon/libxkbcommon/"
LICENSE="MIT"
IUSE="doc static-libs test wayland X"
RESTRICT="!test? ( test )"
SLOT="0"

BDEPEND="
	sys-devel/bison
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
	wayland? ( dev-util/wayland-scanner )
"
RDEPEND="
	X? ( >=x11-libs/libxcb-1.10:=[${MULTILIB_USEDEP},xkb] )
	wayland? ( >=dev-libs/wayland-1.2.0 )
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	x11-misc/compose-tables
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	wayland? ( >=dev-libs/wayland-protocols-1.12 )
"

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library="$(usex static-libs both shared)"
		-Dxkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		$(meson_use wayland enable-wayland)
		$(meson_use X enable-x11)
		$(meson_use doc enable-docs)
	)
	meson_src_configure
}

multilib_src_test() {
	virtx meson_src_test
}
