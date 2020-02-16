# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Gnome2-Wnck
MODULE_AUTHOR=TSCH
MODULE_VERSION=0.16

inherit perl-module

DESCRIPTION="Perl interface to the Window Navigator Construction Kit"
HOMEPAGE="http://gtk2-perl.sourceforge.net/ https://metacpan.org/release/Gnome2-Wnck"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/glib-perl-1.180.0
	>=dev-perl/Gtk2-1.42.0
	>=x11-libs/libwnck-2.20:1"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-PkgConfig-1.03
	>=dev-perl/ExtUtils-Depends-0.2"
