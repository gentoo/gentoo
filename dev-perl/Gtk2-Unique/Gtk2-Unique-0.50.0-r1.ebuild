# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-Unique/Gtk2-Unique-0.50.0-r1.ebuild,v 1.2 2015/05/01 12:04:39 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=POTYL
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl binding for C libunique library"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/libunique:1
	dev-perl/gtk2-perl
"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-0.05-implicit-pointer.patch )
