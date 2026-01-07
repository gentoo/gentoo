# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libnotify"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"
REQUIRED_USE="gtk-doc? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.62:2[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[introspection?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-libs/gobject-introspection-common-1.32
	dev-util/glib-utils
	virtual/pkgconfig
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	gtk-doc? (
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.1.2
	)
	test? (
		dev-lang/python
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		gui-libs/gtk:4
		sys-apps/dbus
		x11-misc/xvfb-run
	)
"
IDEPEND="app-eselect/eselect-notify-send"
PDEPEND="virtual/notification-daemon"

python_check_deps() {
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool test tests)
		$(meson_native_use_feature introspection)
		$(meson_native_use_bool gtk-doc gtk_doc)
		-Ddocbook_docs=disabled
	)
	meson_src_configure
}

multilib_src_install_all() {
	mv "${ED}"/usr/bin/{,libnotify-}notify-send || die #379941

	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/{doc,gtk-doc}/libnotify-0 || die
	fi
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
