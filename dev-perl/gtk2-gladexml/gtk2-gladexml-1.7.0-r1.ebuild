# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Gtk2-GladeXML
MODULE_AUTHOR=TSCH
MODULE_VERSION=1.007
inherit perl-module

DESCRIPTION="Create user interfaces directly from Glade XML files"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Gtk2-GladeXML"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 ppc64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	gnome-base/libglade:2.0
	>=dev-perl/glib-perl-1.020
	>=dev-perl/Gtk2-1.012"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.300
	dev-perl/ExtUtils-PkgConfig"
