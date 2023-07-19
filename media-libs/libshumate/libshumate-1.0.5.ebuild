# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala virtualx

DESCRIPTION="Shumate is a GTK toolkit providing widgets for embedded maps"
HOMEPAGE="https://wiki.gnome.org/Projects/libshumate https://gitlab.gnome.org/GNOME/libshumate"

SLOT="1.0/1"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"
REQUIRED_USE="gtk-doc? ( introspection )"

IUSE="gtk-doc +introspection vala" # vector-renderer is still experimental, maybe put in at a later release

RDEPEND="
	>=dev-libs/glib-2.68.0:2
	>=x11-libs/cairo-1.4
	>=dev-db/sqlite-1.12:3
	>=gui-libs/gtk-4:4
	>=net-libs/libsoup-3.0:3.0
	introspection? ( >=dev-libs/gobject-introspection-0.6.3:= )
"
# vector-renderer? (
#	>=dev-libs/json-glib-1.6.0[introspection?]
#	dev-libs/protobuf-c
# )

DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/1.0.4-tests-Add-test-setup-for-valgrind.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use introspection gir)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		-Ddemos=false # only built, not installed
		# $(meson_use vector-renderer vector_renderer)
		-Dvector_renderer=false
		-Dlibsoup3=true
	)
	meson_src_configure
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

src_install() {
	meson_src_install
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/libshumate-1.0 "${ED}"/usr/share/gtk-doc/html/libshumate-1.0 || die
	fi
}
