# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit check-reqs edo flag-o-matic meson multiprocessing python-any-r1 toolchain-funcs

HASH_GSTRS="052092cd2ea6e6bf4914248237ae4e499ad8cb7e"

DESCRIPTION="Various GStreamer plugins written in Rust"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/"
SRC_URI="
	https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${HASH_GSTRS}/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz"
S="${WORKDIR}/${PN}-${HASH_GSTRS}"

LICENSE="
	Apache-2.0 BSD BSD-2 CC0-1.0 ISC LGPL-2.1+ MIT
	MPL-2.0 Unicode-DFS-2016 ZLIB aws? ( openssl )"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="aws +closedcaption csound +dav1d gtk4 sodium"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/gst-plugins-base:${SLOT}
	media-libs/gstreamer:${SLOT}
	media-libs/libwebp:=
	x11-libs/cairo
	closedcaption? ( x11-libs/pango )
	csound? ( media-sound/csound[double-precision] )
	dav1d? ( media-libs/dav1d:= )
	gtk4? (
		gui-libs/gtk:4
		media-libs/graphene
		x11-libs/gdk-pixbuf:2
	)
	sodium? ( dev-libs/libsodium:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/cargo-c
	virtual/pkgconfig
	virtual/rust"

QA_FLAGS_IGNORED="usr/lib.*/gstreamer-.*/libgst.*"

# can be >20GB with debug+tests, ~5G is assuming default RUSTFLAGS
CHECKREQS_DISK_BUILD=5G

pkg_setup() {
	check-reqs_pkg_setup
	python-any-r1_pkg_setup # for cargo_wrapper.py
}

src_prepare() {
	default

	# aws is the sole ring crate consumer, and it is not portable
	if use !aws; then
		sed -i '/net\/aws/d' Cargo.toml || die
		sed -i '/gst-plugin-aws/d' meson.build || die
	fi
}

src_configure() {
	tc-export AR CC PKG_CONFIG # needed by cargo
	filter-lto # needed for ring crate and tests

	export CARGO_BUILD_JOBS=$(makeopts_jobs)
	export CARGO_PROFILE_RELEASE_DEBUG=0 # ~16GB->4.5GB build dir
	export CSOUND_LIB_DIR=${ESYSROOT}/usr/$(get_libdir)

	local EMESON_BUILDTYPE=release # cargo profile
	local emesonargs=(
		$(meson_feature closedcaption)
		$(meson_feature csound)
		$(meson_feature dav1d)
		$(meson_feature gtk4)
		-Dsodium=$(usex sodium system disabled)
	)

	meson_src_configure
}

src_test() {
	# call ctest manually for better control, some output tests fail when run
	# through meson and cargo profile is not preserved causing more rebuilds
	local ctestargs=(
		--manifest-path "${S}"/Cargo.toml
		--no-fail-fast
		--release
		--target-dir target
		--verbose
	)

	edo cargo ctest "${ctestargs[@]}"
}
