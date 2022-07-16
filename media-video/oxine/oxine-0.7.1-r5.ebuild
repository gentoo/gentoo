# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="OSD frontend for Xine"
HOMEPAGE="http://oxine.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="curl debug dvb exif joystick jpeg lirc nls png v4l X"

DEPEND="
	dev-libs/libcdio
	media-libs/xine-lib[v4l?,X,imagemagick]
	virtual/libcrypt:=
	curl? ( net-misc/curl )
	dvb? ( media-libs/xine-lib[v4l] )
	joystick? ( media-libs/libjsw )
	jpeg? (
		media-libs/netpbm[jpeg,zlib(+)]
		media-video/mjpegtools
		virtual/imagemagick-tools[jpeg]
	)
	lirc? ( app-misc/lirc )
	nls? (
		virtual/libintl
		sys-devel/gettext
	)
	png? (
		media-libs/netpbm[png,zlib(+)]
		media-video/mjpegtools
		virtual/imagemagick-tools[png]
	)
	X? (
		x11-libs/libXext
		x11-libs/libX11
	)
"
RDEPEND="
	${DEPEND}
	sys-apps/util-linux
"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( doc/README.html )

src_configure() {
	# Fix underlinking by falling back to
	# GNU89 inline semantics, bug #590946
	append-cflags -std=gnu89

	local myeconfargs=(
		--disable-hal
		--disable-rpath
		--disable-extractor
		$(use_with curl)
		$(use_enable debug)
		$(use_enable dvb)
		$(use_enable exif)
		$(use_enable joystick)
		$(use_enable lirc)
		$(use_enable nls)
		$(use_enable v4l)
		$(use_with X x)
	)

	# Note on images: Image support will be automatically disabled if
	# netpbm, imagemagick or mjpegtools is not installed, regardless
	# of what the USE flags are set to.
	# If one of the image USE flags is unset, disable image support
	if ! use png || ! use jpeg; then
		myeconfargs+=( --disable-images )
	fi

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc doc/keymapping.pdf
}
