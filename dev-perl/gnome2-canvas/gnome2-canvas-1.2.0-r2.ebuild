# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Gnome2-Canvas
DIST_AUTHOR=TSCH
DIST_VERSION=1.002
DIST_EXAMPLES=( "canvas_demo/*" )
inherit perl-module virtualx

DESCRIPTION="Perl interface to the Gnome Canvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc sparc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libgnomecanvas-2
	>=dev-perl/glib-perl-1.040
	>=dev-perl/Gtk2-1.040"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-PkgConfig-1.03
	>=dev-perl/ExtUtils-Depends-0.202
	virtual/pkgconfig"

src_test() {
	virtx perl-module_src_test
}
