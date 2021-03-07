# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Terminal emulation"
XEMACS_PKG_CAT="standard"

MY_PN=${PN/xemacs-/}
SRC_URI="http://ftp.xemacs.org/packages/${MY_PN}-${PV}-pkg.tar.gz"

RDEPEND="app-xemacs/xemacs-base"

KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
