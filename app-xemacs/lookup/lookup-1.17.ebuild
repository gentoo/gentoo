# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="MULE: Dictionary support"
XEMACS_PKG_CAT="mule"

RDEPEND="app-xemacs/mule-base
app-xemacs/cookie
"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

inherit xemacs-packages
