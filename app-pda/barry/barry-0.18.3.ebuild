# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bash-completion-r1 desktop epatch flag-o-matic gnome2-utils ltprune udev

DESCRIPTION="Sync, backup, program management, and charging for BlackBerry devices"
HOMEPAGE="http://www.netdirect.ca/software/packages/barry/"
SRC_URI="mirror://sourceforge/barry/${P}.tar.bz2"

LICENSE="CC-BY-SA-3.0 GPL-2" #See logo/README for CCPL
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc gui nls static-libs"

RDEPEND=">=dev-cpp/libxmlpp-2.6:2.6
	dev-libs/glib:2
	>=dev-libs/libtar-1.2.11-r2
	>=media-libs/libsdl-1.2
	>=sys-fs/fuse-2.5:=
	sys-libs/zlib
	virtual/libusb:1
	boost? ( >=dev-libs/boost-1.33 )
	gui? (
		dev-cpp/glibmm:2
		dev-cpp/gtkmm:2.4
		dev-cpp/libglademm:2.4
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.6 )
	nls? ( >=sys-devel/gettext-0.18.1.1 )"

DOCS=( AUTHORS ChangeLog KnownBugs NEWS README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.18.4-shared_ptr.patch

	append-cxxflags -std=c++11

	sed -i -e 's:plugdev:usb:g' "${S}"/udev/99-blackberry-perms.rules || die
	sed -i -e '/Icon/s:=.*:=barry:' "${S}"/menu/*.desktop || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable boost) \
		$(use_enable gui) \
		--disable-desktop \
		--disable-rpath
}

src_compile() {
	default

	if use doc; then
		cd "${S}"
		doxygen || die
	fi
}

src_install() {
	default

	# docs
	rm -rf "${S}"/doc/www/*.{php,sh}
	find "${S}"/doc/www/doxygen/html -name "*.map" -size 0 -exec rm -f {} +
	use doc && dohtml "${S}"/doc/www/doxygen/html/*
	rm -rf "${S}"/doc/www
	dodoc -r "${S}"/doc/*

	# Skipping different (old Fedora) rules 69-blackberry.rules in purpose
	udev_dorules "${S}"/udev/10-blackberry.rules "${S}"/udev/99-blackberry-perms.rules

	# blacklist for BERRY_CHARGE kernel module
	insinto /lib/modprobe.d
	doins "${S}"/modprobe/blacklist-berry_charge.conf

	# pppd options files
	docinto ppp
	dodoc "${S}"/ppp/*

	dobashcomp "${S}"/bash/btool "${S}"/bash/bjavaloader

	newicon -s scalable "${S}"/logo/${PN}_logo_icon.svg ${PN}.svg
	use gui && domenu "${S}"/menu/barrybackup.desktop

	prune_libtool_files
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
