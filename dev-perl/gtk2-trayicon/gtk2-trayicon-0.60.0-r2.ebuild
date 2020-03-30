# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BORUP
DIST_VERSION=0.06
DIST_NAME=Gtk2-TrayIcon
DIST_EXAMPLES=("examples/*")
inherit perl-module virtualx

DESCRIPTION="Perl wrappers for the egg cup Gtk2::TrayIcon utilities"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Gtk2-TrayIcon"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-perl/glib-perl-1.012
	>=dev-perl/Gtk2-1.012
	gnome-base/libglade:2.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	virtual/pkgconfig"

src_test() {
	virtx perl-module_src_test
}
