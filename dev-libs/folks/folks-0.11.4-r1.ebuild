# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala virtualx

DESCRIPTION="Library for aggregating people from multiple sources"
HOMEPAGE="https://wiki.gnome.org/Projects/Folks"

LICENSE="LGPL-2.1+"
SLOT="0/25" # subslot = libfolks soname version
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"

# TODO: --enable-profiling
# Vala isn't really optional, https://bugzilla.gnome.org/show_bug.cgi?id=701099
IUSE="bluetooth debug eds +telepathy test tracker utils"
REQUIRED_USE="bluetooth? ( eds )"

COMMON_DEPEND="
	$(vala_depend)
	>=dev-libs/glib-2.40:2
	dev-libs/dbus-glib
	>=dev-libs/gobject-introspection-1.30:=
	>=dev-libs/libgee-0.10:0.8[introspection]
	dev-libs/libxml2
	sys-libs/ncurses:0=
	sys-libs/readline:0=

	bluetooth? ( >=net-wireless/bluez-5 )
	eds? ( >=gnome-extra/evolution-data-server-3.13.90:=[vala] )
	telepathy? ( >=net-libs/telepathy-glib-0.19.9[vala] )
	tracker? ( >=app-misc/tracker-1:0= )
"
# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-mission-control
"
# folks socialweb backend requires that libsocialweb be built with USE=vala,
# even when building folks with --disable-vala.
#
# FIXME:
# test? ( bluetooth? ( dbusmock is missing in the tree ) )
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50.0
	sys-devel/gettext
	virtual/pkgconfig

	test? (
		sys-apps/dbus
		bluetooth? (
			>=gnome-extra/evolution-data-server-3.9.1
			>=dev-libs/glib-2.40:2 ) )
"

PATCHES=(
	"${FILESDIR}"/${PV}-vala-0.42-compat.patch
)

src_prepare() {
	# Force re-generation of introspection files, otherwise it does not match installed libs
	find -name "*.vala" -exec touch {} \; || die

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Rebuilding docs needs valadoc, which has no release
	gnome2_src_configure \
		$(use_enable bluetooth bluez-backend) \
		$(use_enable debug) \
		$(use_enable eds eds-backend) \
		$(use_enable eds ofono-backend) \
		$(use_enable telepathy telepathy-backend) \
		$(use_enable tracker tracker-backend) \
		$(use_enable utils inspect-tool) \
		$(use_enable test modular-tests) \
		--enable-vala \
		--enable-import-tool \
		--disable-docs \
		--disable-fatal-warnings \
		--disable-libsocialweb-backend
}

src_test() {
	dbus-launch virtx emake check
}
