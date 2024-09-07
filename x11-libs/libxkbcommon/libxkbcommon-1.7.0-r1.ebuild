# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/xkbcommon/${PN}"
else
	SRC_URI="https://xkbcommon.org/download/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 meson-multilib ${GIT_ECLASS} python-any-r1 virtualx

DESCRIPTION="Keymap handling library for toolkits and window systems"
HOMEPAGE="https://xkbcommon.org/ https://github.com/xkbcommon/libxkbcommon/"
LICENSE="MIT"
SLOT="0"

IUSE="doc static-libs test tools wayland X"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/yacc
	doc? ( app-text/doxygen[dot] )
	test? ( ${PYTHON_DEPS} )
	tools? ( wayland? ( dev-util/wayland-scanner ) )
"
RDEPEND="
	X? ( >=x11-libs/libxcb-1.10:=[${MULTILIB_USEDEP}] )
	tools? ( wayland? ( >=dev-libs/wayland-1.2.0[${MULTILIB_USEDEP}] ) )
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	x11-misc/compose-tables
	x11-misc/xkeyboard-config
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	tools? ( wayland? ( >=dev-libs/wayland-protocols-1.12 ) )
"

PATCHES=(
	"${FILESDIR}"/libxkbcommon-1.7.0-symbol-ver.patch
)

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library="$(usex static-libs both shared)"
		-Dxkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		-Dbash-completion-path="$(get_bashcompdir)"
		$(meson_native_use_bool tools enable-tools)
		$(meson_use X enable-x11)
		$(meson_native_use_bool doc enable-docs)
		$(meson_use wayland enable-wayland)
	)
	meson_src_configure
}

multilib_src_test() {
	virtx meson_src_test
}

multilib_src_install_all() {
	if use doc; then
		mv "${ED}"/usr/share/doc/{${PN},${P}} || die
	fi
}
