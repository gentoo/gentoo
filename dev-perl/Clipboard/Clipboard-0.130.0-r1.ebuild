# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Clipboard/Clipboard-0.130.0-r1.ebuild,v 1.1 2014/08/24 12:43:36 axs Exp $

EAPI=5

MODULE_AUTHOR=KING
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Copy and paste with any OS"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE=""

RDEPEND="x11-misc/xclip"
