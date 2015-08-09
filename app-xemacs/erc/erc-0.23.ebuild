# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="ERC - The Emacs IRC Client"
PKG_CAT="standard"

KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

RDEPEND="app-xemacs/edit-utils
app-xemacs/fsf-compat
app-xemacs/gnus
app-xemacs/pcomplete
app-xemacs/xemacs-base
app-xemacs/text-modes
app-xemacs/xemacs-ispell
app-xemacs/viper
"
