# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Gtk2-GladeXML
DIST_AUTHOR=TSCH
DIST_VERSION=1.007
DIST_EXAMPLES=("examples/*")
inherit perl-module virtualx

DESCRIPTION="Create user interfaces directly from Glade XML files"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 ppc64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	gnome-base/libglade:2.0
	>=dev-perl/glib-perl-1.020
	>=dev-perl/Gtk2-1.012"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.300
	dev-perl/ExtUtils-PkgConfig"

src_test() {
	virtx perl-module_src_test
}
