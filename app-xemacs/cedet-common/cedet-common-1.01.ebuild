# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/cedet-common/cedet-common-1.01.ebuild,v 1.11 2014/08/10 18:45:28 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Common files for CEDET development environment"
PKG_CAT="standard"

RDEPEND="app-xemacs/edebug
	app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
