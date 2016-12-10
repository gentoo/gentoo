# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	dev-perl/ExtUtils-PkgConfig"

PATCHES=(
	# this patch fixes segfaults on amd64 platforms
	"${FILESDIR}"/fix_implicit_pointer_declaration.patch
)
