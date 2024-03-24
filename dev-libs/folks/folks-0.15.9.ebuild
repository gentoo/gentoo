# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Library for aggregating people from multiple sources"
HOMEPAGE="https://wiki.gnome.org/Projects/Folks https://gitlab.gnome.org/GNOME/folks"

LICENSE="LGPL-2.1+"
SLOT="0/26" # subslot = libfolks soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-linux"

IUSE="bluetooth eds telepathy test utils"
REQUIRED_USE="bluetooth? ( eds )"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.58:2
	>=dev-libs/libgee-0.10:0.8[introspection]
	>=dev-libs/gobject-introspection-1.54:=
	telepathy? (
		>=net-libs/telepathy-glib-0.19.9
		dev-libs/dbus-glib
	)
	eds? ( >=gnome-extra/evolution-data-server-3.38:= )
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
	${PYTHON_DEPS}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	telepathy? ( net-libs/telepathy-glib[vala] )
	eds? ( gnome-extra/evolution-data-server[vala] )
	test? (
		sys-apps/dbus
		bluetooth? (
			$(python_gen_any_dep '
				>=dev-python/python-dbusmock-0.30.1[${PYTHON_USEDEP}]
			')
		)
	)
"

python_check_deps() {
	if use test && use bluetooth; then
		python_has_version ">=dev-python/python-dbusmock-0.30.1[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth bluez_backend)
		$(meson_use eds eds_backend)
		$(meson_use eds ofono_backend)
		$(meson_use telepathy telepathy_backend)
		-Dzeitgeist=false # last rited package
		-Dimport_tool=true
		$(meson_use utils inspect_tool)
		$(meson_use test tests)
		-Dinstalled_tests=false
		-Ddocs=false # Needs find_program sedding to specific version; only dev docs, don't bother
	)
	meson_src_configure
}

src_test() {
	# Avoid warnings when /etc/profile.d/flatpak.sh from flatpak modified XDG_DATA_DIRS
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	dbus-run-session meson test -C "${BUILD_DIR}" -t 5 || die "tests failed"
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
