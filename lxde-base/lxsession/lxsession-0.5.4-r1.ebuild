# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vala autotools

DESCRIPTION="LXDE session manager"
HOMEPAGE="https://wiki.lxde.org/en/LXSession"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~x86-linux"
SLOT="0"

# upower USE flag is enabled by default in the desktop profile
IUSE="nls upower"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	dev-libs/libunique:1
	lxde-base/lxde-common
	sys-auth/polkit
	x11-libs/gtk+:2
	x11-libs/libX11
	sys-apps/dbus
"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	sys-apps/lsb-release
	upower? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto
"

PATCHES=(
	# Fedora patches
	"${FILESDIR}"/${PN}-0.5.2-reload.patch
	"${FILESDIR}"/${PN}-0.5.2-notify-daemon-default.patch
	"${FILESDIR}"/${PN}-0.5.2-fix-invalid-memcpy.patch
)

src_prepare() {
	vala_src_prepare

	default
	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (CK, logind?), and suspend/hibernate (UPower)
	# gtk3 looks to not be ready, follow what other distributions are
	# doing
	econf \
		$(use_enable nls) \
		--disable-gtk3
}
