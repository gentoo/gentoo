# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BORUP
MODULE_VERSION=0.06
MY_PN=Gtk2-TrayIcon
inherit perl-module

DESCRIPTION="Perl wrappers for the egg cup Gtk2::TrayIcon utilities"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-perl/glib-perl-1.012
	>=dev-perl/gtk2-perl-1.012
	gnome-base/libglade:2.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig
	virtual/pkgconfig"
