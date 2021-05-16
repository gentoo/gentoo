# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/xemacs-/}
XEMACS_PKG_CAT="standard"

inherit xemacs-packages

SLOT="0"
DESCRIPTION="Terminal emulation"

SRC_URI="http://ftp.xemacs.org/packages/${MY_PN}-${PV}-pkg.tar.gz"

KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

RDEPEND="app-xemacs/xemacs-base"
