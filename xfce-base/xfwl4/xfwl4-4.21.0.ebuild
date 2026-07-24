# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.92.0"

declare -A GIT_CRATES=(
	[smithay-drm-extras]='https://github.com/smithay/smithay;4645e03d6bd9377aa368de20e91d69951450392d;smithay-%commit%/smithay-drm-extras'
	[smithay]='https://github.com/smithay/smithay;4645e03d6bd9377aa368de20e91d69951450392d;smithay-%commit%'
)

inherit cargo meson

DESCRIPTION="Xfce's [experimental] Wayland Compositor"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfwl4/start
	https://gitlab.xfce.org/xfce/xfwl4
"
SRC_URI="
	https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz
	https://github.com/gentoo-crate-dist/xfwl4/releases/download/${P}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC LGPL-2.1 MIT
	MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
IUSE="debug"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/libxfce4ui-4.21.4:=
	>=xfce-base/xfconf-4.21.2:=

	>=dev-libs/libinput-1.28.0
	>=media-libs/libdisplay-info-0.3.0:=
	>=media-libs/mesa-25.0.0[opengl]
	>=sys-auth/seatd-0.9.0
	>=virtual/libudev-257:=
	>=x11-libs/libdrm-2.4.0
	>=x11-libs/libxkbcommon-0.8.0
	>=x11-libs/pixman-0.44.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

# Rust
QA_FLAGS_IGNORED="usr/bin/xfwl4"

src_configure() {
	local emesonargs=(
		# leave these all at defaults for now, deps are unconditional anyway
		# -Dbackends=...
		-Degl=true
		-Dxwayland=true
		$(meson_use debug debug-rendering)
		-Duse-system-gettext=true
	)
	use debug && EMESON_BUILDTYPE=debug

	meson_src_configure
}
