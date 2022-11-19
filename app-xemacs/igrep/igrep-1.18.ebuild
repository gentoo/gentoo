# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="Enhanced front-end for Grep"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/xemacs-base
app-xemacs/efs
"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

inherit xemacs-packages
