# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
VALA_MAX_API_VERSION="0.44" # tests-utils fails to build with newer with v0.12.1

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Library for aggregating people from multiple sources"
HOMEPAGE="https://wiki.gnome.org/Projects/Folks"

LICENSE="LGPL-2.1+"
SLOT="0/25" # subslot = libfolks soname version
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"

IUSE="bluetooth eds +telepathy test tracker utils"
REQUIRED_USE="bluetooth? ( eds )"
RESTRICT="!test? ( test )"

DEPEND="
	$(vala_depend)
	>=dev-libs/glib-2.44:2
	dev-libs/dbus-glib
	>=dev-libs/libgee-0.10:0.8[introspection]
	>=dev-libs/gobject-introspection-1.54:=
	telepathy? ( >=net-libs/telepathy-glib-0.19.9[vala] )
	tracker? ( app-misc/tracker:0/2.0 )
	eds? ( >=gnome-extra/evolution-data-server-3.13.90:=[vala] )
	dev-libs/libxml2:2
	utils? ( sys-libs/readline:0= )
"
# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${DEPEND}
	bluetooth? ( >=net-wireless/bluez-5[obex] )
	telepathy? ( net-im/telepathy-mission-control )
"
BDEPEND="
	>=dev-util/meson-0.49
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

# FIXME:
# test? ( bluetooth? ( dbusmock is missing in the tree ) )
DEPEND="${COMMON_DEPEND}
	test? ( sys-apps/dbus
		bluetooth? ( dev-python/dbusmock ) )
"

PATCHES=(
	"${FILESDIR}"/${PV}-conditional-tests.patch # Allow not building lots of test executables when tests are disabled
	"${FILESDIR}"/${PV}-no-tracker-tests.patch # TODO: Tracker tests fail; this removed them for now
)

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth bluez_backend)
		$(meson_use eds eds_backend)
		-Dlibsocialweb_backend=false # not packaged
		$(meson_use eds ofono_backend)
		$(meson_use telepathy telepathy_backend)
		$(meson_use tracker tracker_backend)
		-Dzeitgeist=false # last rited package
		-Dimport_tool=true
		$(meson_use utils inspect_tool)
		$(meson_use test)
		-Dinstalled_tests=false
		-Ddocs=false # Needs find_program sedding to specific version; only dev docs, don't bother
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
