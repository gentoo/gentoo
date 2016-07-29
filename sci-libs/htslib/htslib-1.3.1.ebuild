# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
