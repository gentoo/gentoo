# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C<<1 programming language system"
HOMEPAGE="http://gpl.arachne.cz/"
SRC_URI="http://gpl.arachne.cz/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos"

RDEPEND="sys-devel/gcc"

src_install() {
	doheader cll1.h

	dodoc cll1.txt

	docinto examples
	dodoc demos/*.c
	docompress -x /usr/share/doc/${PF}/examples
}
