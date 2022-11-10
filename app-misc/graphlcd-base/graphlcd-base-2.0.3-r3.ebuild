# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs udev

DESCRIPTION="Contains the lowlevel lcd drivers for GraphLCD"
HOMEPAGE="https://projects.vdr-developer.org/projects/graphlcd-base"
SRC_URI="https://projects.vdr-developer.org/git/${PN}.git/snapshot/${P}.tar.bz2"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="fontconfig freetype graphicsmagick imagemagick lcd_devices_ax206dpf lcd_devices_picolcd_256x64 lcd_devices_vnc"
REQUIRED_USE="?? ( graphicsmagick imagemagick )"

RDEPEND="
	dev-libs/libhid
	net-libs/libvncserver
	freetype? ( media-libs/freetype:2= )
	fontconfig? ( media-libs/fontconfig:1.0= )
	graphicsmagick? ( media-gfx/graphicsmagick:0/1.3[cxx] )
	imagemagick? ( media-gfx/imagemagick:= )
	lcd_devices_ax206dpf? ( virtual/libusb:0 )
	lcd_devices_picolcd_256x64? ( virtual/libusb:0 )
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

DOCS=( "HISTORY" "README" "TODO" "docs/." )

PATCHES=(
	"${FILESDIR}/${PN}-2.0.3-clang.patch"
	"${FILESDIR}/${PN}-2.0.3-cpp.patch"
	"${FILESDIR}/${PN}-2.0.3-imagemagick7.patch"
	"${FILESDIR}/${PN}-2.0.3-musl.patch"
)

src_prepare() {
	default

	# Change '/usr/local/' to '/usr'
	# Change '/usr/lib' to '/usr/$(get_libdir)'
	sed -e "22s:/usr/local:/usr:" -e "25s:/lib:/$(get_libdir):" -i Make.config || die

	# Fix newer GCC version with the Futaba MDM166A lcd driver
	sed -e "s:0xff7f0004:(int) 0xff7f0004:" -i glcddrivers/futabaMDM166A.cpp || die

	tc-export CC CXX
}

src_configure() {
	# Build optional drivers
	if use lcd_devices_ax206dpf; then
		sed -e "66s:#::" -i Make.config || die
	fi
	if use lcd_devices_picolcd_256x64; then
		sed -e "69s:#::" -i Make.config || die
	fi
	if ! use lcd_devices_vnc; then
		sed -e "60s:1:0:" -i Make.config || die
	fi

	# Build optional features
	if ! use freetype; then
		sed -e "47s:HAVE:#HAVE:" -i Make.config || die
	fi
	if ! use fontconfig; then
		sed -e "50s:HAVE:#HAVE:" -i Make.config || die
	fi
	if use graphicsmagick; then
		sed -e "57s:#::" -i Make.config || die
	fi
	if use imagemagick; then
		sed -e "56s:#::" -i Make.config || die
	fi
}

src_install() {
	emake DESTDIR="${D}" UDEVRULESDIR="$(get_udevdir)/rules.d" install

	einstalldocs
}

pkg_postinst() {
	udev_reload

	optfeature "supporting the logitech g15 keyboard lcd." app-misc/g15daemon
}

pkg_postrm() {
	udev_reload
}
