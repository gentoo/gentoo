# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib gnome2-utils

DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"
SRC_URI="https://github.com/AOMediaCodec/libavif/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc64 x86"
IUSE="+aom dav1d examples extras gdk-pixbuf rav1e svt-av1"

DEPEND="media-libs/libpng[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0[${MULTILIB_USEDEP}] )
	dav1d? ( media-libs/dav1d[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}] )
	rav1e? ( media-video/rav1e[capi] )
	svt-av1? ( >=media-libs/svt-av1-0.8.6 )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="|| ( aom dav1d )"

PATCHES=(
	"${FILESDIR}/${P}-pkg-config.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_CODEC_AOM=$(usex aom ON OFF)
		-DAVIF_CODEC_DAV1D=$(usex dav1d ON OFF)
		-DAVIF_CODEC_LIBGAV1=OFF

		# Use system libraries.
		-DAVIF_LOCAL_ZLIBPNG=OFF
		-DAVIF_LOCAL_JPEG=OFF

		-DAVIF_BUILD_GDK_PIXBUF=$(usex gdk-pixbuf ON OFF)

		-DAVIF_ENABLE_WERROR=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=$(usex rav1e ON OFF)
			-DAVIF_CODEC_SVT=$(usex svt-av1 ON OFF)

			-DAVIF_BUILD_EXAMPLES=$(usex examples ON OFF)
			-DAVIF_BUILD_APPS=$(usex extras ON OFF)
			-DAVIF_BUILD_TESTS=$(usex extras ON OFF)
		)
	else
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=OFF
			-DAVIF_CODEC_SVT=OFF

			-DAVIF_BUILD_EXAMPLES=OFF
			-DAVIF_BUILD_APPS=OFF
			-DAVIF_BUILD_TESTS=OFF
		)

		if ! use aom ; then
			if use rav1e || use svt-av1 ; then
				ewarn "libavif on ${MULTILIB_ABI_FLAG} will work in read-only mode."
				ewarn "Support for rav1e and/or svt-av1 is is not available on ${MULTILIB_ABI_FLAG}"
				ewarn "Enable aom flag for full support on ${MULTILIB_ABI_FLAG}"
			fi
		fi
	fi

	cmake_src_configure
}

pkg_preinst() {
	if use gdk-pixbuf ; then
		gnome2_gdk_pixbuf_savelist
	fi
}

pkg_postinst() {
	if ! use aom && ! use rav1e && ! use svt-av1 ; then
		ewarn "No AV1 encoder is set,"
		ewarn "libavif will work in read-only mode."
		ewarn "Enable aom, rav1e or svt-av1 flag if you want to save .AVIF files."
	fi

	if use gdk-pixbuf ; then
		# causes segfault if set, see bug 375615
		unset __GL_NO_DSO_FINALIZER
		multilib_foreach_abi gnome2_gdk_pixbuf_update
	fi
}

pkg_postrm() {
	if use gdk-pixbuf ; then
		# causes segfault if set, see bug 375615
		unset __GL_NO_DSO_FINALIZER
		multilib_foreach_abi gnome2_gdk_pixbuf_update
	fi
}
