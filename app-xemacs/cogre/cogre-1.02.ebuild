# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="Graph editing mode"
PKG_CAT="standard"

RDEPEND="
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edebug
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/semantic
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
