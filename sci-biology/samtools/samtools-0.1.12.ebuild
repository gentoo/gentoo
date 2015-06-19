# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/samtools/samtools-0.1.12.ebuild,v 1.6 2013/12/06 12:44:16 jlec Exp $

EAPI=2

MY_P="${P}a"

DESCRIPTION="Utilities for SAM (Sequence Alignment/Map), a format for large nucleotide sequence alignments"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i 's/^CFLAGS=/CFLAGS+=/' "${S}"/{Makefile,misc/Makefile}
}

src_install() {
	dobin samtools || die
	dobin $(find misc -type f -executable) || die
	insinto /usr/share/${PN}
	doins -r examples || die
	doman ${PN}.1 || die
	dodoc AUTHORS ChangeLog NEWS
}
