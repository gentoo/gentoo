# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Open Lighting Architecture, a framework for lighting control information"
HOMEPAGE="https://www.openlighting.org/ola/"
SRC_URI="https://github.com/OpenLightingProject/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples ftdi http osc tcmalloc test usb zeroconf"

RESTRICT="!test? ( test )"

RDEPEND="dev-libs/protobuf:=
	sys-apps/util-linux
	sys-libs/ncurses
	ftdi? ( dev-embedded/libftdi:1 )
	http? ( net-libs/libmicrohttpd:= )
	osc? ( media-libs/liblo )
	tcmalloc? ( dev-util/google-perftools:= )
	usb? ( virtual/libusb:1 )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? (
		dev-util/cppunit
	)"

src_prepare() {
	default
	# Upstream recommends doing this even for tarball builds
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-fatal-warnings
		--with-uucp-lock="/run"
		$(use_enable examples)
		$(use_enable ftdi libftdi)
		$(use_enable http)
		$(use_enable osc)
		$(use_enable tcmalloc)
		$(use_enable test unittests)
		$(use_enable usb libusb)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
