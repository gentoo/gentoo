# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 desktop udev xdg

DESCRIPTION="Sync, backup, program management, and charging for BlackBerry devices"
HOMEPAGE="http://www.netdirect.ca/software/packages/barry/"
SRC_URI="mirror://sourceforge/barry/${P}.tar.bz2"

LICENSE="CC-BY-SA-3.0 GPL-2" #See logo/README for CCPL
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc gui nls"

RDEPEND="
	>=dev-cpp/libxmlpp-2.6:2.6
	dev-libs/glib:2
	>=dev-libs/libtar-1.2.11-r2
	>=media-libs/libsdl-1.2
	>=sys-fs/fuse-2.5:=
	sys-libs/zlib
	virtual/libusb:1
	boost? ( dev-libs/boost:= )
	gui? (
		dev-cpp/glibmm:2
		dev-cpp/gtkmm:2.4
		dev-cpp/libglademm:2.4
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.6 )
	nls? ( >=sys-devel/gettext-0.18.1.1 )"

PATCHES=( "${FILESDIR}"/${PN}-0.18.4-shared_ptr.patch )

src_prepare() {
	default

	sed -e 's:plugdev:usb:g' -i udev/99-blackberry-perms.rules || die
	sed -e '/Icon/s:=.*:=barry:' -i menu/*.desktop || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable boost) \
		$(use_enable gui) \
		--disable-desktop \
		--disable-rpath \
		--disable-static
}

src_compile() {
	default

	if use doc; then
		doxygen || die
		# clean out cruft
		find doc/www/doxygen/html/ \( \
			-iname '*.map*' -o \
			-iname '*.md5' -o \
			-iname '*.php' -o \
			-iname '*.sh' \) -delete || die
	fi
}

src_install() {
	default

	# docs
	dodoc KnownBugs
	use doc && dodoc -r doc/www/doxygen/html
	rm -rf doc/www || die
	dodoc -r doc/.

	# Skipping different (old Fedora) rules 69-blackberry.rules in purpose
	udev_dorules udev/10-blackberry.rules udev/99-blackberry-perms.rules

	# blacklist for BERRY_CHARGE kernel module
	insinto /lib/modprobe.d
	doins modprobe/blacklist-berry_charge.conf

	# pppd options files
	docinto ppp
	dodoc -r ppp/.

	dobashcomp bash/btool bash/bjavaloader

	newicon -s scalable logo/${PN}_logo_icon.svg ${PN}.svg
	use gui && domenu menu/barrybackup.desktop

	find "${ED}" -name '*.la' -delete || die
}
