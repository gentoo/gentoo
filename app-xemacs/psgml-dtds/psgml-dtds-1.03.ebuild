# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/psgml-dtds/psgml-dtds-1.03.ebuild,v 1.5 2014/08/10 19:24:38 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Deprecated collection of DTDs for psgml"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/psgml
app-xemacs/edit-utils
app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-eterm
app-xemacs/sh-script
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
