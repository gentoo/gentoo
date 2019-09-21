# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/waffle-gl/${PN}.git"
	GIT_ECLASS="git-r3"
else
	SRC_URI="https://people.freedesktop.org/~chadversary/${PN}/files/release/${P}/${P}.tar.xz"
	KEYWORDS="amd64 arm ~ppc ~ppc64 x86"
fi
inherit cmake-multilib ${GIT_ECLASS}

DESCRIPTION="Library that allows selection of GL API and of window system at runtime"
HOMEPAGE="https://people.freedesktop.org/~chadversary/waffle/"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc egl gbm test wayland"

RDEPEND="
	>=media-libs/mesa-9.1.6[egl?,gbm?,${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	gbm? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.8-r3[${MULTILIB_USEDEP}]
	doc? (
		dev-libs/libxslt
		app-text/docbook-xml-dtd:4.2
	)
"

src_configure() {
	local mycmakeargs=(
		-Dwaffle_has_glx=ON
		-Dwaffle_build_examples=OFF
		-Dwaffle_build_manpages=$(usex doc )
		-Dwaffle_has_x11_egl=$(usex egl)
		-Dwaffle_has_gbm=$(usex gbm)
		-Dwaffle_build_tests=$(usex test)
		-Dwaffle_has_wayland=$(usex wayland)
	)

	cmake-multilib_src_configure
}

src_test() {
	emake -C "${CMAKE_BUILD_DIR}" check
}
