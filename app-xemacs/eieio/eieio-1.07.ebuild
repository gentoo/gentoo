# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/eieio/eieio-1.07.ebuild,v 1.6 2011/07/22 11:24:59 xarthisius Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Enhanced Implementation of Emacs Interpreted Objects"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/edebug
app-xemacs/cedet-common
app-xemacs/speedbar
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
