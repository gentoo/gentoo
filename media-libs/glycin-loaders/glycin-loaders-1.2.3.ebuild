# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# crates vendored upstream
CRATES=""

RUST_MIN_VERSION=1.80.0

inherit cargo meson

MY_P=glycin-${PV/_/.}
DESCRIPTION="Loaders for glycin clients (glycin crate or libglycin)"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glycin/"
SRC_URI="
	https://download.gnome.org/sources/glycin/$(ver_cut 1-2)/${MY_P}.tar.xz
"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( LGPL-2.1+ MPL-2.0 )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD GPL-3+ ISC LGPL-3+
	MIT Unicode-3.0
	|| ( LGPL-2.1+ MPL-2.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="heif jpegxl svg test"
REQUIRED_USE="test? ( heif jpegxl )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.60:2
	>=sys-libs/libseccomp-2.5.0
	heif? ( >=media-libs/libheif-1.17.0:= )
	jpegxl? ( >=media-libs/libjxl-0.10.0:= )
	svg? (
		>=gnome-base/librsvg-2.52.0:2
		>=x11-libs/cairo-1.17.0
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=gui-libs/gtk-4.16.0:4
		>=media-libs/lcms-2.14:2
	)
"
BDEPEND="
	test? (
		sys-apps/bubblewrap
		sys-apps/dbus
	)
"

ECARGO_VENDOR=${S}/vendor

QA_FLAGS_IGNORED="usr/libexec/glycin-loaders/.*"

src_prepare() {
	default

	# https://gitlab.gnome.org/GNOME/glycin/-/issues/81
	sed -i -e '\|/fonts|d' tests/tests.rs || die
}

src_configure() {
	local formats=(
		$(usev heif glycin-heif)
		$(usev jpegxl glycin-jxl)
		$(usev svg glycin-svg)
		glycin-image-rs
	)
	local formats_s=${formats[*]}
	local emesonargs=(
		-Dprofile=$(usex debug dev release)
		-Dglycin-loaders=true
		-Dloaders="${formats_s// /,}"
		-Dtests=$(usex test true false)
		-Dlibglycin=false
	)

	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

src_test() {
	# tests write to /proc/*/uid_map
	# apparently, "addpredict /" in Portage breaks it
	local -x SANDBOX_ON=0
	meson_src_test
}
