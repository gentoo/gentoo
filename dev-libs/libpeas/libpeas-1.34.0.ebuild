# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org lua-single meson python-single-r1 vala virtualx xdg

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://wiki.gnome.org/Projects/Libpeas https://gitlab.gnome.org/GNOME/libpeas"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="glade +gtk gtk-doc lua +python vala"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.39:=
	gtk? ( >=x11-libs/gtk+-3.0.0:3[introspection] )
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	lua? (
		${LUA_DEPS}
		$(lua_gen_cond_dep '
			>=dev-lua/lgi-0.9.0[${LUA_USEDEP}]
		')
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.11
		>=dev-util/gi-docgen-2021.7
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Gentoo-specific lua tweak hack
	"${FILESDIR}"/1.26.0-lua.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature $(usex lua '!lua_single_target_luajit' 'lua') lua51)
		$(meson_feature $(usex lua 'lua_single_target_luajit' 'lua') luajit)
		-Dpython2=false
		$(meson_use python python3)
		# introspection was always enabled in autotools; would need readiness by consumers
		# to USE flag it, but most need it for python plugins anyways
		-Dintrospection=true
		$(meson_use vala vapi)
		$(meson_use gtk widgetry)
		$(meson_use glade glade_catalog)
		-Ddemos=false
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/libpeas{,-gtk}-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
