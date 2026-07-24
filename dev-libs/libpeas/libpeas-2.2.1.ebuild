# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{12..15} )

inherit gnome.org lua-single meson python-single-r1 vala virtualx xdg

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libpeas"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="glade gtk-doc javascript lua +python vala"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=dev-libs/glib-2.86:2
	>=dev-libs/gobject-introspection-1.82.0-r2:=
	javascript? (
		>=dev-libs/gjs-1.78.5
		dev-lang/spidermonkey:140=
	)
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
			>=dev-python/pygobject-3.55:3[${PYTHON_USEDEP}]
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
	vala? ( dev-lang/vala )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Gentoo-specific lua tweak hack
	"${FILESDIR}"/${PN}-2.2.1-lua_impl.patch
	"${FILESDIR}"/${PN}-1.38.1-test-extension.patch

	# https://bugs.gentoo.org/961580
	"${FILESDIR}"/${PN}-2.2.1-skip_test_gjs.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	use vala && vala_setup
	local emesonargs=(
		$(meson_feature $(usex lua '!lua_single_target_luajit' 'lua') lua51)
		$(meson_feature $(usex lua 'lua_single_target_luajit' 'lua') luajit)
		$(meson_use javascript gjs)
		$(meson_use python python3)
		# introspection was always enabled in autotools; would need readiness by consumers
		# to USE flag it, but most need it for python plugins anyways
		-Dintrospection=true
		$(meson_use vala vapi)
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
		mv "${ED}"/usr/share/doc/libpeas-2 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
