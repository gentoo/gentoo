# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala autotools

DESCRIPTION="LXDE session manager"
HOMEPAGE="https://wiki.lxde.org/en/LXSession"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~x86-linux"
IUSE="nls upower"

COMMON_DEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=lxde-base/lxde-common-0.99.2-r1
	sys-apps/dbus
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	sys-apps/lsb-release
	upower? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# Fedora patches
	"${FILESDIR}"/${PN}-0.5.2-reload.patch
	"${FILESDIR}"/${PN}-0.5.2-notify-daemon-default.patch
)

src_prepare() {
	rm *.stamp || die
	vala_src_prepare
	default
	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (logind), and suspend/hibernate (UPower)
	econf \
		$(use_enable nls) \
		--enable-gtk3
}
