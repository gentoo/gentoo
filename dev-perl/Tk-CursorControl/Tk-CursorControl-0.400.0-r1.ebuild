# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tk-CursorControl/Tk-CursorControl-0.400.0-r1.ebuild,v 1.1 2014/08/23 00:26:25 axs Exp $

EAPI=5

MODULE_AUTHOR=DUNNIGANJ
MODULE_VERSION=0.4
inherit eutils perl-module

DESCRIPTION="Manipulate the mouse cursor programmatically"

SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE=""

RDEPEND="dev-perl/perl-tk"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/0.4-demo.patch" )

src_prepare() {
	perl-module_src_prepare
	edos2unix "${S}"/{CursorControl.pm,demos/cursor.pl}
}
