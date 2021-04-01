# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gsettings-desktop-schemas"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"

BDEPEND="
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Revert change to 'Source Code Pro 10' and 'Cantarell 11' fonts back to generic sans and monospace aliases
	"${FILESDIR}"/3.32.0-default-fonts.patch
)

src_configure() {
	meson_src_configure $(meson_use introspection)
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
