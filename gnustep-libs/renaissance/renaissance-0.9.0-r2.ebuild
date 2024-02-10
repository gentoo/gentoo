# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="GNUstep Renaissance allows to describe user interfaces XML files"
HOMEPAGE="https://github.com/gnustep/libs-renaissance"
SRC_URI="http://www.gnustep.it/Renaissance/Download/${P/r/R}.tar.gz"
S="${WORKDIR}/${P/r/R}"

KEYWORDS="~amd64 ~ppc x86"
LICENSE="LGPL-2.1+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-0.8.1_pre20070522-docpath.patch )
