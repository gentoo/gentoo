# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/pcl-cvs/pcl-cvs-1.67.ebuild,v 1.5 2014/08/10 19:20:59 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="CVS frontend"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/elib
app-xemacs/vc
app-xemacs/dired
app-xemacs/edebug
app-xemacs/ediff
app-xemacs/edit-utils
app-xemacs/mail-lib
app-xemacs/prog-modes
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
