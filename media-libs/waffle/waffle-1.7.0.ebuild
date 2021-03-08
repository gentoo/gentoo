# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/${PN}"
	GIT_ECLASS="git-r3"
else
	SRC_URI="https://gitlab.freedesktop.org/mesa/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 x86"
	S="${WORKDIR}"/${PN}-v${PV}
fi
inherit meson multilib-minimal ${GIT_ECLASS}

DESCRIPTION="Library that allows selection of GL API and of window system at runtime"
HOMEPAGE="http://www.waffle-gl.org/ https://gitlab.freedesktop.org/mesa/waffle"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc +egl +gbm wayland X"
RESTRICT="test" # gl_basic tests don't work when run from portage

RDEPEND="
	>=media-libs/mesa-9.1.6[egl?,gbm?,${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	gbm? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.10[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.8-r3[${MULTILIB_USEDEP}]
"
BDEPEND="
	dev-libs/libxslt
	app-text/docbook-xml-dtd:4.2
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/wflinfo$(get_exeext)
)

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature X glx)
		$(meson_feature wayland)
		$(meson_feature X x11_egl)
		$(meson_feature gbm)
		$(meson_feature egl surfaceless_egl)
		-Dbuild-manpages=$(multilib_is_native_abi && echo true || echo false)
		-Dbuild-tests=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	! use doc && rm -rf \
		"${D}"/usr/share/doc/waffle1 \
		"${D}"/usr/share/man/man{3,7}
}
