# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnustep-2

MY_P=${P/p/P}
DESCRIPTION="Help improve the performance of GNUstep applications"
HOMEPAGE="http://wiki.gnustep.org/index.php/Performance"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="LGPL-3"
SLOT="0"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if ! use doc; then
		# Remove doc target
		sed -i -e '/documentation\.make/d' GNUmakefile \
			|| die "doc sed failed"
	fi
}
