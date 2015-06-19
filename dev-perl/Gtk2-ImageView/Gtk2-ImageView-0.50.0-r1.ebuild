# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-ImageView/Gtk2-ImageView-0.50.0-r1.ebuild,v 1.2 2015/05/01 12:02:00 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RATCLIFFE
MODULE_VERSION=0.05
inherit perl-module
#inherit virtualx

DESCRIPTION="Perl binding for the GtkImageView image viewer widget"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/gtk2-perl
	>=media-gfx/gtkimageview-1.6.3"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	>=dev-perl/ExtUtils-Depends-0.300
	>=dev-perl/extutils-pkgconfig-1.030"

#SRC_TEST=do
#src_test(){
#	Xmake test || die
#}
