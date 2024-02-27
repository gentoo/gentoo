# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="Library for easy management of RSS/Atom/Pie feeds"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgrss"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.42.1:2
	>=dev-libs/libxml2-2.9.2:2
	>=net-libs/libsoup-2.48:2.4
	introspection? ( >=dev-libs/gobject-introspection-1.42 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/gtk-doc-am-1.10
	virtual/pkgconfig
"
