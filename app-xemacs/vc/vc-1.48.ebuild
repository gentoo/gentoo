# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Version Control for Free systems"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/ediff
app-xemacs/sh-script
app-xemacs/pcl-cvs
app-xemacs/tramp
app-xemacs/prog-modes
app-xemacs/elib
app-xemacs/edebug
app-xemacs/gnus
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
