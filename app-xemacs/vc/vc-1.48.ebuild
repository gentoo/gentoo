# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="Version Control for Free systems"
PKG_CAT="standard"

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
