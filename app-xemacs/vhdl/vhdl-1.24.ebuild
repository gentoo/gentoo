# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Support for VHDL"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/edit-utils
app-xemacs/c-support
app-xemacs/speedbar
app-xemacs/ps-print
app-xemacs/os-utils
app-xemacs/cedet-common
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
