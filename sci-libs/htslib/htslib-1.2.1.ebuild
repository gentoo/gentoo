# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/htslib/htslib-1.2.1.ebuild,v 1.1 2015/02/18 08:43:24 jlec Exp $

EAPI=5

DESCRIPTION="C library for high-throughput sequencing data formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/samtools/${PV}/${P}.tar.bz2"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}
