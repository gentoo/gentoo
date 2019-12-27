# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="EPSON Image Scan v3 for Linux"
HOMEPAGE="http://support.epson.net/linux/en/imagescanv3.php"

SRC_URI="http://support.epson.net/linux/src/scanner/imagescanv3/common/imagescan_${PV}.orig.tar.gz"

LICENSE="GPL-3+"

SLOT="0"

IUSE="graphicsmagick gui imagemagick"

KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/boost:=
	media-gfx/sane-backends
	media-libs/tiff
	virtual/libusb:1
	virtual/jpeg
	gui? ( dev-cpp/gtkmm:= )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:= )
		graphicsmagick? ( media-gfx/graphicsmagick:= )
	)
"
RDEPEND=${DEPEND}

S="${WORKDIR}/utsushi-0.$(ver_cut 2-3)"

src_configure() {
	econf \
		$(use_with gui gtkmm) \
		--with-jpeg \
		$(use_with imagemagick magick) \
		$(use_with imagemagick magick-pp) \
		--with-tiff \
		--with-sane \
		--with-boost=yes
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	elog "If you encounter problems with media-gfx/xsane when scanning (e.g., bad resolution),"
	elog "please try the built-in GUI and kde-misc/skanlite first before reporting bugs."
}
