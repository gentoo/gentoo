# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Goo-Canvas/Goo-Canvas-0.60.0-r1.ebuild,v 1.2 2015/05/01 12:00:29 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=YEWENBIN
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl interface to the GooCanvas"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/goocanvas:0
	dev-perl/gtk2-perl
	dev-perl/glib-perl
	dev-perl/Cairo"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig"

PATCHES=(
	# this patch fixes segfaults on amd64 platforms
	"${FILESDIR}"/fix_implicit_pointer_declaration.patch
)
