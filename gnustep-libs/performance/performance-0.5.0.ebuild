# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

MY_P=${P/p/P}
DESCRIPTION="Help improve the performance of GNUstep applications"
HOMEPAGE="https://github.com/gnustep/libs-performance"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="LGPL-3+"
SLOT="0"

src_prepare() {
	if ! use doc; then
		# Remove doc target
		sed -i -e '/documentation\.make/d' GNUmakefile \
			|| die "doc sed failed"
	fi

	default
}
