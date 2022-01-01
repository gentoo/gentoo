# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SLOT="0"
DESCRIPTION="Display time & date on the modeline"
XEMACS_PKG_CAT="standard"

XEMACS_EXPERIMENTAL="true"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
