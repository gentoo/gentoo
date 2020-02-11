# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Graph editing mode"
XEMACS_PKG_CAT="standard"

RDEPEND="
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edebug
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/semantic
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
