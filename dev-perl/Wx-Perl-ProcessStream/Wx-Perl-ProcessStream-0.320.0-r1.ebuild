# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Wx-Perl-ProcessStream/Wx-Perl-ProcessStream-0.320.0-r1.ebuild,v 1.1 2014/08/26 19:45:06 axs Exp $

EAPI=5

WX_GTK_VER="2.8"
MODULE_AUTHOR=MDOOTSON
MODULE_VERSION=0.32
inherit wxwidgets perl-module

DESCRIPTION="access IO of external processes via events"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:2.8
	>=dev-perl/wxperl-0.97.01"
DEPEND="${RDEPEND}"

#SRC_TEST=do
