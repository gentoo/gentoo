# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a meson toolchain-funcs

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
	SLOT="0/0.12"

	IUSE="vulkan"

	# vulkan support is experimental and uses a bundled fork of wlroots
	# keep it only in the live ebuild for now
	RDEPEND="vulkan? ( media-libs/vulkan-loader )"
	DEPEND="vulkan? ( dev-util/vulkan-headers )"
	COMMON_DEPEND="
		!vulkan? (
			gui-libs/wlroots:0.20[drm(+),libinput(+),x11-backend,X?]
		)
		vulkan? (
			dev-libs/libliftoff
			media-libs/lcms:2
			media-libs/libdisplay-info:=
			media-libs/mesa
			sys-auth/seatd:=
			x11-libs/libdrm
			x11-libs/xcb-util-errors
			x11-libs/xcb-util-renderutil
			x11-libs/xcb-util-wm
		)
	"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
	SLOT="0/$(ver_cut 1-2)"

	COMMON_DEPEND="gui-libs/wlroots:0.20[drm(+),libinput(+),x11-backend,X?]"
fi

LICENSE="MIT"
IUSE+=" X +dbus +gles3 nls openmp test"
RESTRICT="!test? ( test )"

# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
COMMON_DEPEND+="
	dev-cpp/nlohmann_json
	dev-libs/glib:2
	dev-libs/libevdev
	dev-libs/libinput:=
	dev-libs/wayland
	dev-libs/yyjson
	>=dev-libs/wayland-protocols-1.12
	gui-libs/wf-config:${SLOT}
	media-libs/glm
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	virtual/libudev:=
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	dbus? ( sys-apps/dbus )
	X? ( x11-libs/libxcb:= )
"

RDEPEND+="
	${COMMON_DEPEND}
	x11-misc/xkeyboard-config
"
DEPEND+="
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
	nls? (
		sys-devel/gettext
	)
"

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
		$(meson_feature nls build_locales)
		$(meson_use openmp enable_openmp)
		-Duse_system_wfconfig=enabled
	)

	if [[ ${PV} == 9999 ]]; then
		emesonargs+=(
			$(meson_feature !vulkan use_system_wlroots)
			$(meson_use vulkan vulkan_effects)
		)
	else
		emesonargs+=(
		-Duse_system_wlroots=enabled
		-Dvulkan_effects=false
		)
	fi

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
