# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="GnuPG interface for Emacs"
XEMACS_PKG_CAT="standard"

KEYWORDS="~amd64"

RDEPEND="app-xemacs/xemacs-base
	app-xemacs/dired
	app-xemacs/mail-lib"

inherit xemacs-packages
