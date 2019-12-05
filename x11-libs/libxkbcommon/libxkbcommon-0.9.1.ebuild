# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/xkbcommon/${PN}"
else
	SRC_URI="https://xkbcommon.org/download/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86"
fi

inherit meson multilib-minimal ${GIT_ECLASS}

DESCRIPTION="keymap handling library for toolkits and window systems"
HOMEPAGE="https://xkbcommon.org/ https://github.com/xkbcommon/libxkbcommon/"
LICENSE="MIT"
IUSE="X doc test"
RESTRICT="!test? ( test )"
SLOT="0"

BDEPEND="
	sys-devel/bison
	doc? ( app-doc/doxygen )"
RDEPEND="X? ( >=x11-libs/libxcb-1.10:=[${MULTILIB_USEDEP},xkb] )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

multilib_src_configure() {
	local emesonargs=(
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
