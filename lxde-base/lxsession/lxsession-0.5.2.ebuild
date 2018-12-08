# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
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
	dev-libs/libgee:0
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
	"${FILESDIR}"/${P}-reload.patch
	"${FILESDIR}"/${P}-key2-null.patch
	"${FILESDIR}"/${P}-notify-daemon-default.patch
	"${FILESDIR}"/${P}-fix-invalid-memcpy.patch
)

src_prepare() {
	vala_src_prepare

	# Don't start in Xfce to avoid bugs like
	# https://bugzilla.redhat.com/show_bug.cgi?id=616730
	sed -i 's/^NotShowIn=GNOME;KDE;/NotShowIn=GNOME;KDE;XFCE;/g' data/lxpolkit.desktop.in.in || die

	# fix icon in desktop file
	# http://lxde.git.sourceforge.net/git/gitweb.cgi?p=lxde/lxsession-edit;a=commit;h=3789a96691eadac9b8f3bf3034a97645860bd138
	sed -i 's/^Icon=xfwm4/Icon=session-properties/g' data/lxsession-edit.desktop.in || die

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
