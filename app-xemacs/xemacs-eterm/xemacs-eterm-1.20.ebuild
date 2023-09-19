# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/xemacs-/}
XEMACS_PKG_CAT="standard"

inherit xemacs-packages

SLOT="0"
DESCRIPTION="Terminal emulation"

SRC_URI="http://ftp.xemacs.org/pub/xemacs/packages/${MY_PN}-${PV}-pkg.tar.gz"

KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

RDEPEND="app-xemacs/xemacs-base
"
