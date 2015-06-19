# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/pgg/pgg-1.07.ebuild,v 1.7 2014/08/10 19:22:49 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs interface to various PGP implementations"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/fsf-compat
app-xemacs/edebug
app-xemacs/ecrypto
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
