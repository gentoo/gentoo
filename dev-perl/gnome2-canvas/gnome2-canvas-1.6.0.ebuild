# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=Gnome2-Canvas
DIST_AUTHOR=XAOC
DIST_VERSION=1.006
DIST_EXAMPLES=( "canvas_demo/*" )
inherit perl-module virtualx

DESCRIPTION="Perl interface to the Gnome Canvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libgnomecanvas-2
	>=dev-perl/glib-perl-1.120.0
	>=dev-perl/Gtk2-1.100.0"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-PkgConfig-1.30.0
	>=dev-perl/ExtUtils-Depends-0.200.0
	virtual/pkgconfig"

src_test() {
	virtx perl-module_src_test
}
