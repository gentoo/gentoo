# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER=1.85.0

inherit cargo meson

MY_PV=${PV/_/.}
MY_P=glycin-${MY_PV}
TEST_IMAGE_COMMIT=b148bcf70847d6f126a8e83e27e1c59d2e474adf

DESCRIPTION="Loaders for glycin clients (glycin crate or libglycin)"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glycin/"
# upstream release tarballs are useless, as upstream is deliberately
# stripping glycin crate from them
SRC_URI="
	https://gitlab.gnome.org/GNOME/glycin/-/archive/${MY_PV}/${MY_P}.tar.bz2
	https://github.com/gentoo-crate-dist/glycin/releases/download/${MY_PV}/${MY_P}-crates.tar.xz
	test? (
		https://gitlab.gnome.org/sophie-h/test-images/-/archive/${TEST_IMAGE_COMMIT}/test-images-${TEST_IMAGE_COMMIT}.tar.bz2
			-> glycin-test-images-${TEST_IMAGE_COMMIT}.tar.bz2
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( LGPL-2.1+ MPL-2.0 )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ IJG ISC
	LGPL-3+ MIT Unicode-3.0
	|| ( LGPL-2.1+ MPL-2.0 )
"
SLOT="2"
KEYWORDS="amd64 arm64"
IUSE="heif jpeg2k jpegxl libs svg test"
REQUIRED_USE="test? ( heif jpegxl )"
RESTRICT="!test? ( test )"

RDEPEND="
	!>=media-libs/glycin-loaders-2:0
	>=dev-libs/glib-2.68.0:2
	>=sys-libs/libseccomp-2.5.0
	heif? ( >=media-libs/libheif-1.17.0:= )
	jpegxl? ( >=media-libs/libjxl-0.11.0:= )
	libs? (
		>=gui-libs/gtk-4.16.0:4
		media-libs/fontconfig
		>=media-libs/lcms-2.14:2
	)
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
	sys-devel/gettext
	test? (
		sys-apps/bubblewrap
		sys-apps/dbus
	)
"

QA_FLAGS_IGNORED="usr/libexec/glycin-loaders/.*"

src_unpack() {
	cargo_src_unpack

	if use test; then
		mv "test-images-${TEST_IMAGE_COMMIT}"/* \
			"${S}/tests/test-images/" || die
	fi
}

src_configure() {
	local formats=(
		$(usev heif glycin-heif)
		$(usev jpeg2k glycin-jpeg2000)
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
		-Dlibglycin=$(usex libs true false)
		-Dlibglycin-gtk4=$(usex libs true false)
		-Dvapi=false
		-Dglycin-thumbnailer=false

		# TODO: figure out why it fails
		# https://gitlab.gnome.org/GNOME/glycin/-/issues/167
		-Dtest_skip_ext=heic
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
