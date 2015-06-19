# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/dictionary/dictionary-1.16.ebuild,v 1.4 2014/08/10 18:49:06 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Interface to RFC2229 dictionary servers"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
