# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Gnome2
MODULE_AUTHOR=XAOC
MODULE_VERSION=1.045
inherit perl-module

DESCRIPTION="Perl interface to the 2.x series of the Gnome libraries"
HOMEPAGE="http://gtk2-perl.sourceforge.net/ ${HOMEPAGE}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-perl/gtk2-perl
	gnome-base/libgnomeui
	gnome-base/libbonoboui
	dev-perl/gnome2-canvas
	>=dev-perl/glib-perl-1.40.0
	dev-perl/gnome2-vfs-perl"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig"

SRC_TEST=do
