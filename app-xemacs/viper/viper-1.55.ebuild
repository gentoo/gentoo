# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/viper/viper-1.55.ebuild,v 1.9 2014/08/10 19:43:38 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="VI emulation support"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
