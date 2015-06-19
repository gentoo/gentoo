# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/easypg/easypg-1.02.ebuild,v 1.2 2014/08/10 18:50:54 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="GnuPG interface for Emacs"
PKG_CAT="standard"

KEYWORDS="~amd64"

RDEPEND="app-xemacs/xemacs-base
	app-xemacs/dired
	app-xemacs/mail-lib"

inherit xemacs-packages
