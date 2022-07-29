# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
VALA_MIN_API_VERSION="0.40"

inherit bash-completion-r1 flag-o-matic gnome.org gnome2-utils linux-info meson python-any-r1 systemd vala xdg

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker https://gitlab.gnome.org/GNOME/tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="3/0" # libtracker-sparql-3.0 soname version
KEYWORDS="~alpha ~amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +miners stemmer test"
RESTRICT="!test? ( test )"

PV_SERIES=$(ver_cut 1-2)

RDEPEND="
	>=dev-libs/glib-2.52:2
	>=sys-apps/dbus-1.3.2
	>=dev-libs/gobject-introspection-1.54:=
	>=dev-libs/icu-4.8.1.2:=
	>=dev-libs/json-glib-1.4
	>=net-libs/libsoup-2.40.1:2.4
	>=dev-libs/libxml2-2.7
	>=dev-db/sqlite-3.29.0
	stemmer? ( dev-libs/snowball-stemmer:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	app-text/asciidoc
	dev-libs/libxslt
	$(vala_depend)
	gtk-doc? (
		>=dev-util/gtk-doc-1.8
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.5
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/tappy[${PYTHON_USEDEP}]')
	)
	${PYTHON_DEPS}
"
PDEPEND="miners? ( >=app-misc/tracker-miners-${PV_SERIES} )"

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

python_check_deps() {
	python_has_version -b \
		"dev-python/pygobject[${PYTHON_USEDEP}]" \
		"dev-python/tappy[${PYTHON_USEDEP}]"
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	append-cflags -DTRACKER_DEBUG -DG_DISABLE_CAST_CHECKS

	local emesonargs=(
		$(meson_use gtk-doc docs)
		-Dman=true
		$(meson_feature stemmer)
		-Dunicode_support=icu
		-Dbash_completion_dir="$(get_bashcompdir)"
		-Dsystemd_user_services_dir="$(systemd_get_userunitdir)"
		$(meson_use test tests)
		-Dintrospection=enabled
		-Dsoup=soup2
	)
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
