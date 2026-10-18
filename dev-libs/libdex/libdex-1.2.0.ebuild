# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit gnome.org linux-info meson python-r1 vala virtualx

DESCRIPTION="Dex provides Future-based programming for GLib-based applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdex"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"

IUSE="+eventfd gtk-doc +introspection +liburing python sysprof test vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	python? ( ${PYTHON_REQUIRED_USE} )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.87:2
	liburing? ( >=sys-libs/liburing-0.7:= )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	python? ( ${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
	sysprof? ( dev-util/sysprof-capture:4 )
	elibc_musl? ( sys-libs/libucontext )
"
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	test? ( dev-util/gdbus-codegen )
"

pkg_setup() {
	if use eventfd && linux_config_exists; then
		if ! linux_chkconfig_present EVENTFD ; then
			ewarn "CONFIG_EVENTFD must be enabled for USE=eventfd"
		fi
	fi
}

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		-Dexamples=false
		$(meson_use vala vapi)
		$(meson_feature introspection)
		$(meson_use sysprof)
		$(meson_use test tests)
		$(meson_feature liburing)
		$(meson_feature eventfd)
		$(meson_use python pygobject)
		-Dgdbus=enabled
	)
	meson_src_configure
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" --print-errorlogs || die
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-1 "${ED}"/usr/share/gtk-doc/html/ || die
	fi

	if use python; then
		python_moduleinto gi/overrides/
		python_foreach_impl python_optimize
	fi
}
