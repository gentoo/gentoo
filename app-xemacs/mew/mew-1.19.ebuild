# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/mew/mew-1.19.ebuild,v 1.6 2014/08/10 19:13:19 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Messaging in an Emacs World"
PKG_CAT="standard"

RDEPEND="app-xemacs/w3
app-xemacs/efs
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/fsf-compat
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
