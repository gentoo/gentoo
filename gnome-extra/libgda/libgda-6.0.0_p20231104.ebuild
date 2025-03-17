# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala

COMMIT="b45c05da8c3b094acdcfce55e96ed7b1f948509b"

DESCRIPTION="GNOME database access library"
HOMEPAGE="https://www.gnome-db.org/"
SRC_URI="
	https://gitlab.gnome.org/GNOME/libgda/-/archive/${COMMIT}/libgda-${COMMIT}.tar.bz2
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ LGPL-2+"

SLOT="6/0" # subslot = libgda-6.0 soname version
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="doc examples experimental http keyring json ldap mysql postgres sqlcipher tools vala"

REQUIRED_USE="
	ldap? ( experimental )
	tools? ( experimental )
"

RDEPEND="
	app-text/iso-codes
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	experimental? ( dev-libs/libxslt )
	http? ( net-libs/libsoup:2.4 )
	keyring? ( app-crypt/libsecret )
	ldap? ( net-nds/openldap:= )
	mysql? ( dev-db/mysql-connector-c:= )
	sqlcipher? ( dev-db/sqlcipher )
"
DEPEND="
	${RDEPEND}
	json? ( dev-libs/json-glib )
	postgres? ( dev-db/postgresql )
"
BDEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-util/glib-utils
	sys-apps/sed
	vala? ( $(vala_depend) )
"

# TODO:
# broken features: gui, web
#RDEPEND="
#	gui? (
#		x11-libs/gtk+:3
#		x11-libs/gdk-pixbuf
#		canvas? ( x11-libs/goocanvas:2.0 )
#		glade? ( dev-util/glade )
#		gtksourceview? ( x11-libs/gtksourceview:3.0 )
#		graphviz? ( media-gfx/graphviz )
#	)
#"
#BDEPEND="
#	gui? ( dev-util/intltool )
#"

pkg_setup() {
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Dhelp=true
		-Dui=false
		-Dweb=false
		-Dgraphviz=false
		-Dgoocanvas=false
		-Dgtksourceview=false
		$(meson_use doc)
		$(meson_use examples)
		$(meson_use experimental)
		$(meson_use http libsoup)
		$(meson_use keyring libsecret)
		$(meson_use json)
		$(meson_use ldap)
		$(meson_use mysql)
		$(meson_use postgres)
		$(meson_use sqlcipher)
		$(meson_use tools)
		$(meson_use vala vapi)
	)

	meson_src_configure
}
