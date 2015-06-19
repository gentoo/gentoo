# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xslt-process/xslt-process-1.12.ebuild,v 1.5 2014/08/10 19:50:23 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="XSLT processing support"
PKG_CAT="standard"

RDEPEND="app-xemacs/jde
app-xemacs/cc-mode
app-xemacs/semantic
app-xemacs/debug
app-xemacs/speedbar
app-xemacs/edit-utils
app-xemacs/xemacs-eterm
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/elib
app-xemacs/eieio
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/xemacs-devel
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
