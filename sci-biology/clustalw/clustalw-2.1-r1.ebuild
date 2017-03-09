# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="General purpose multiple alignment program for DNA and proteins"
HOMEPAGE="http://www.clustal.org/"
SRC_URI="http://www.clustal.org/download/current/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

src_install() {
	default
	rmdir "${ED%/}"/usr/share/aclocal || die
}
