# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/psgml/psgml-1.44.ebuild,v 1.5 2014/08/10 19:24:02 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Validated HTML/SGML editing"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/edit-utils
app-xemacs/edebug
app-xemacs/xemacs-devel
app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-eterm
app-xemacs/sh-script
app-xemacs/ps-print
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
