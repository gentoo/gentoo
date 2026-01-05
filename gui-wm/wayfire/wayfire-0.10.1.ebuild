# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a meson toolchain-funcs

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
	SLOT="0/0.10"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~riscv"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="X +dbus +gles3 openmp test"
RESTRICT="!test? ( test )"

# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
COMMON_DEPEND="
	dev-cpp/nlohmann_json
	dev-libs/glib:2
	dev-libs/libevdev
	dev-libs/libinput:=
	dev-libs/wayland
	dev-libs/yyjson
	>=dev-libs/wayland-protocols-1.12
	gui-libs/wf-config:${SLOT}
	gui-libs/wlroots:0.19[drm(+),libinput(+),x11-backend,X?]
	media-libs/glm
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/vulkan-loader
	virtual/libudev:=
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	dbus? ( sys-apps/dbus )
	X? ( x11-libs/libxcb:= )
"

RDEPEND="
	${COMMON_DEPEND}
	x11-misc/xkeyboard-config
"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-cpp/doctest )
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			llvm-runtimes/clang-runtime[openmp]
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-fix-musl.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	local dbusrunsession=$(usev dbus dbus-run-session)
	sed -e "s:@EPREFIX@:${EPREFIX}:g" -e "s:@DBUS_RUN_SESSION@:${dbusrunsession}:" \
		"${FILESDIR}"/wayfire-session-2 > "${T}"/wayfire-session || die
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
		"${FILESDIR}"/wayfire-session.desktop > "${T}"/wayfire-session.desktop || die
}

src_configure() {
	lto-guarantee-fat

	local emesonargs=(
		$(meson_feature test tests)
		$(meson_feature X xwayland)
		$(meson_use gles3 enable_gles32)
		$(meson_use openmp enable_openmp)
		-Duse_system_wfconfig=enabled
		-Duse_system_wlroots=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dobin "${T}"/wayfire-session

	insinto "/usr/share/wayland-sessions/"
	insopts -m644
	doins wayfire.desktop
	doins "${T}"/wayfire-session.desktop

	insinto "/usr/share/wayfire/"
	doins wayfire.ini

	insinto "/etc"
	doins "${FILESDIR}"/wayfire.env

	strip-lto-bytecode
}
