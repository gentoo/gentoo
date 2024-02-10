# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/${PN}"
	GIT_ECLASS="git-r3"
else
	SRC_URI="https://gitlab.freedesktop.org/mesa/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}"/${PN}-v${PV}
fi
inherit meson-multilib multilib virtualx ${GIT_ECLASS}

DESCRIPTION="Library that allows selection of GL API and of window system at runtime"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/waffle"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc test wayland X"
RESTRICT="!test? ( test ) test" # gl_basic tests don't work when run under sandbox

RDEPEND="
	>=media-libs/mesa-23[${MULTILIB_USEDEP}]
	>=virtual/libudev-208:=[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	)
	wayland? ( >=dev-libs/wayland-1.10[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	X? ( >=x11-base/xcb-proto-1.8-r3 )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	dev-util/wayland-scanner
"
#	test? (
#		wayland? ( dev-libs/weston[headless] )
#	)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/wflinfo$(get_exeext)
)

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature X glx)
		$(meson_feature wayland)
		$(meson_feature X x11_egl)
		-Dgbm=enabled
		-Dsurfaceless_egl=enabled

		$(meson_use test build-tests)
		$(meson_native_true build-manpages)
		-Dbuild-htmldocs=false
		-Dbuild-examples=false
	)
	meson_src_configure
}

multilib_src_test() {
	if use wayland; then
		export XDG_RUNTIME_DIR="$(mktemp -p $(pwd) -d xdg-runtime-XXXXXX)"

		weston --backend=headless-backend.so --socket=wayland-6 --idle-time=0 &
		compositor=$!
		export WAYLAND_DISPLAY=wayland-6
	fi

	export MESA_SHADER_CACHE_DISABLE=true
	virtx meson_src_test

	if use wayland; then
		kill ${compositor}
	fi
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	rm -r \
		"${ED}"/usr/share/doc/${P} \
		"${ED}"/usr/share/doc/waffle1/release-notes || die
	mv "${ED}"/usr/share/doc/{waffle1,${P}} || die
	if ! use doc; then
		rm -rf \
			"${ED}"/usr/share/man/man{3,7} || die
	fi
}
