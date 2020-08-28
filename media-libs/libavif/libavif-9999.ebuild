# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils

DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AOMediaCodec/libavif.git"
else
	SRC_URI="https://github.com/AOMediaCodec/libavif/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="dav1d gdk-pixbuf +libaom rav1e"

REQUIRED_USE="|| ( dav1d libaom )"

DEPEND="media-libs/libpng
	virtual/jpeg
	dav1d? ( media-libs/dav1d )
	libaom? ( >=media-libs/libaom-2.0.0:= )
	rav1e? ( media-video/rav1e:=[capi] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DAVIF_BUILD_APPS=ON
		-DAVIF_CODEC_AOM=$(usex libaom)
		-DAVIF_CODEC_DAV1D=$(usex dav1d)
		-DAVIF_CODEC_RAV1E=$(usex rav1e)
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_BUILD_GDK_PIXBUF=$(usex gdk-pixbuf)
	)
	cmake_src_configure
}

pkg_preinst() {
	if use gdk-pixbuf ; then
		gnome2_gdk_pixbuf_savelist
	fi
}

pkg_postinst() {
	if ! use libaom && ! use rav1e ; then
		ewarn "libaom and rav1e flags are not set,"
		ewarn "libavif will work in read-only mode."
		ewarn "Enable libaom or rav1e flag if you want to save .AVIF files."
	fi

	if use gdk-pixbuf ; then
		gnome2_gdk_pixbuf_update
	fi
}

pkg_postrm() {
	if use gdk-pixbuf ; then
		gnome2_gdk_pixbuf_update
	fi
}
