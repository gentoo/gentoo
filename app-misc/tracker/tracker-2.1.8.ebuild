# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit bash-completion-r1 eapi7-ver gnome.org linux-info meson python-any-r1 systemd vala xdg

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/2.0"
IUSE="gtk-doc +miners networkmanager stemmer"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

PV_SERIES=$(ver_cut 1-2)

# In 2.2.0 util-linux should only be necessary if glib is older than 2.52 at compile-time
RDEPEND="
	>=dev-libs/glib-2.46:2
	>=sys-apps/dbus-1.3.2
	>=dev-libs/gobject-introspection-1.54:=
	>=dev-libs/icu-4.8.1.2:=
	>=dev-libs/json-glib-1.0
	>=net-libs/libsoup-2.40.1:2.4
	>=dev-libs/libxml2-2.7
	>=dev-db/sqlite-3.20.0
	networkmanager? ( >=net-misc/networkmanager-0.8 )
	stemmer? ( dev-libs/snowball-stemmer )
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/intltool-0.40.0
	$(vala_depend)
	gtk-doc? ( >=dev-util/gtk-doc-1.8
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	${PYTHON_DEPS}
" # g-ir-merge needs py3; functional tests need py2, so disabled for now due to mixup
# intltool-merge manually called in meson.build in 2.1.7; properly gone by 2.2.0
PDEPEND="miners? ( >=app-misc/tracker-miners-${PV_SERIES} )"

PATCHES=(
	"${FILESDIR}"/${PV}-doc-options.patch # https://gitlab.gnome.org/GNOME/tracker/merge_requests/58
	"${FILESDIR}"/${PV}-test-fix.patch # https://gitlab.gnome.org/GNOME/tracker/merge_requests/59
	"${FILESDIR}"/${PV}-prevent-stack-smashing.patch
	"${FILESDIR}"/${PV}-fix-library-symlinks.patch
)

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

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dfts=true
		-Dfunctional_tests=false # python2, but g-ir-merge needs py3; https://gitlab.gnome.org/GNOME/tracker/merge_requests/40
		$(meson_use gtk-doc)
		-Dman=true
		-Dnetwork_manager=$(usex networkmanager yes no)
		-Dstemmer=$(usex stemmer yes no)
		-Dunicode_support=icu
		-Dbash_completion="$(get_bashcompdir)"
		-Dsystemd_user_services="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}
