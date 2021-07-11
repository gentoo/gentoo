# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=Gtk2-GladeXML
DIST_AUTHOR=XAOC
DIST_VERSION=1.008
DIST_EXAMPLES=("examples/*")
inherit perl-module virtualx

DESCRIPTION="Create user interfaces directly from Glade XML files"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Gtk2-GladeXML"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86"

RDEPEND="x11-libs/gtk+:2
	gnome-base/libglade:2.0
	>=dev-perl/glib-perl-1.020
	>=dev-perl/Gtk2-1.012"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.300
	dev-perl/ExtUtils-PkgConfig"

src_test() {
	virtx perl-module_src_test
}
