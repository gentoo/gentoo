# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gnome2-wnck/gnome2-wnck-0.160.0-r1.ebuild,v 1.2 2015/05/01 12:29:26 dilfridge Exp $

EAPI=5

MY_PN=Gnome2-Wnck
MODULE_AUTHOR=TSCH
MODULE_VERSION=0.16

inherit perl-module

DESCRIPTION="Perl interface to the Window Navigator Construction Kit"
HOMEPAGE="http://gtk2-perl.sourceforge.net/ ${HOMEPAGE}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-perl/glib-perl-1.180.0
	>=dev-perl/gtk2-perl-1.42.0
	>=x11-libs/libwnck-2.20:1"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/ExtUtils-Depends-0.2"
