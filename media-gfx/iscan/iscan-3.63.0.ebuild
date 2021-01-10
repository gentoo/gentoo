# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic udev xdg-utils

DESCRIPTION="EPSON Image Scan v3 for Linux"
HOMEPAGE="https://support.epson.net/linux/en/imagescanv3.php https://gitlab.com/utsushi/utsushi"
SRC_URI="https://support.epson.net/linux/src/scanner/imagescanv3/common/imagescan_${PV}.orig.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
IUSE="graphicsmagick gui test"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/boost:=
	media-gfx/sane-backends
	media-libs/tiff
	virtual/jpeg
	virtual/libusb:1
	graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
	gui? ( dev-cpp/gtkmm:2.4 )
"
# Disable opencl as during reorient.utr test it produces inconsistent results
DEPEND="${RDEPEND}
	test? (
		app-text/tesseract[png,tiff,training,-opencl]
		media-fonts/dejavu
		virtual/imagemagick-tools[png,tiff]
	)
"
RESTRICT="!test? ( test )"
S="${WORKDIR}/utsushi-0.$(ver_cut 2-3)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.61.0-ijg-libjpeg.patch
	"${FILESDIR}"/${PN}-3.61.0-imagemagick-7.patch
	"${FILESDIR}"/${PN}-3.62.0-gcc-10.patch
	"${FILESDIR}"/${PN}-3.62.0-boost-1.73.patch
	"${FILESDIR}"/${PN}-3.62.0-fix-symbols.patch
	"${FILESDIR}"/${PN}-3.62.0-tests-boost.patch
	"${FILESDIR}"/${PN}-3.62.0-tests-tesseract.patch
	"${FILESDIR}"/${PN}-3.62.0-tests-linkage.patch
	"${FILESDIR}"/${PN}-3.63.0-autoconf-2.70.patch
)

src_prepare() {
	default

	# Remove vendored libraries
	rm -r upstream/boost || die
	# Workaround for deprecation warnings:
	# https://gitlab.com/utsushi/utsushi/issues/90
	sed -e 's|=-Werror|="-Werror -Wno-error=deprecated-declarations"|g' -i configure.ac || die
	# Disable check-soname test
	sed -e '/SANE_BACKEND_SANITY_CHECKS +=/d' -i sane/Makefile.am || die
	eautoreconf
}

src_configure() {
	# Workaround for:
	# /usr/lib64/utsushi/libutsushi.so.0: undefined symbol: libcnx_usb_LTX_factory
	append-ldflags $(no-as-needed)
	# https://bugs.gentoo.org/720994
	append-ldflags -pthread
	local myconf=(
		$(use_with gui gtkmm)
		--enable-sane-config
		--enable-udev-config
		--with-boost=yes
		--with-jpeg
		--with-magick=$(usex graphicsmagick GraphicsMagick ImageMagick)
		--with-magick-pp=$(usex graphicsmagick GraphicsMagick ImageMagick)
		--with-sane
		--with-tiff
		--with-udev-confdir="$(get_udevdir)"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dodoc lib/devices.conf
	find "${ED}" -name '*.la' -delete || die
	if use gui; then
		newicon -s scalable doc/icon.svg "${PN}".svg
		make_desktop_entry utsushi "Image Scan"
	fi
}

pkg_postinst() {
	use gui && xdg_icon_cache_update
	elog "If you encounter problems with media-gfx/xsane when scanning (e.g., bad resolution),"
	elog "please try the built-in GUI and kde-misc/skanlite first before reporting bugs."
}

pkg_postrm() {
	use gui && xdg_icon_cache_update
}
