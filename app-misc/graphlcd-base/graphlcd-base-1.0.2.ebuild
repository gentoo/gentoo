# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic udev

DESCRIPTION="Contains the lowlevel lcd drivers for GraphLCD"
HOMEPAGE="https://projects.vdr-developer.org/projects/graphlcd-base"
SRC_URI="https://projects.vdr-developer.org/git/${PN}.git/snapshot/${P}.tar.bz2"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="fontconfig freetype g15 graphicsmagick imagemagick lcd_devices_ax206dpf lcd_devices_picolcd_256x64 lcd_devices_vnc"
REQUIRED_USE="?? ( graphicsmagick imagemagick )"

RDEPEND="
	dev-libs/libhid
	net-libs/libvncserver
	freetype? ( media-libs/freetype:2= )
	fontconfig? ( media-libs/fontconfig:1.0= )
	graphicsmagick? ( media-gfx/graphicsmagick:0/1.3 )
	imagemagick? ( <media-gfx/imagemagick-7 )
	lcd_devices_ax206dpf? ( virtual/libusb:0 )
	lcd_devices_picolcd_256x64? ( virtual/libusb:0 )
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

DOCS=( "HISTORY" "README" "TODO" "docs/." )

src_prepare() {
	default

	# Change '/usr/local/' to '/usr'
	# Change '/usr/lib' to '/usr/$(get_libdir)'
	sed -e "34s:/usr/local:/usr:" -e "37s:/lib:/$(get_libdir):" -i Make.config || die

	# Fix newer GCC version with the Futaba MDM166A lcd driver
	sed -e "s:0xff7f0004:(int) 0xff7f0004:" -i glcddrivers/futabaMDM166A.c || die

	tc-export CC CXX
}

src_configure() {
	# Build optional drivers
	if use lcd_devices_ax206dpf; then
		sed -e "78s:#::" -i Make.config || die
	fi
	if use lcd_devices_picolcd_256x64; then
		sed -e "81s:#::" -i Make.config || die
	fi
	if use lcd_devices_vnc; then
		sed -e "72s:1:0:" -i Make.config || die
	fi

	# Build optional features
	if ! use freetype; then
		sed -e "59s:HAVE:#HAVE:" -i Make.config || die
	fi
	if ! use fontconfig; then
		sed -e "62s:HAVE:#HAVE:" -i Make.config || die
	fi
	if use graphicsmagick; then
		sed -e "69s:#::" -i Make.config || die
	fi
	if use imagemagick; then
		sed -e "68s:#::" -i Make.config || die
	fi
}

src_install() {
	default

	udev_dorules 99-graphlcd-base.rules
}

pkg_postinst() {
	udev_reload

	optfeature "supporting the logitech g15 keyboard lcd." app-misc/g15daemon
}

pkg_postrm() {
	udev_reload
}
