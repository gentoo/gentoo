# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/fsf-compat/fsf-compat-1.15.ebuild,v 1.6 2014/08/10 19:02:27 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="FSF Emacs compatibility files"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base"

KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"

inherit xemacs-packages
