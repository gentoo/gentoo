# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/buddy/buddy-2.2.ebuild,v 1.7 2013/02/05 18:33:04 ulm Exp $

DESCRIPTION="Binary Decision Diagram Package"
HOMEPAGE="http://www.itu.dk/research/buddy/"
SRC_URI="http://www.itu.dk/research/buddy/buddy22.tar.gz"

LICENSE="buddy"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

S=${WORKDIR}/buddy22

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LIBDIR=usr/lib \
		INCDIR=usr/include \
		|| die
}

src_install() {
	dodir /usr/lib /usr/include
	emake install \
		LIBDIR="${D}"/usr/lib \
		INCDIR="${D}"/usr/include || die
	dodoc CHANGES README doc/*.txt
	insinto /usr/share/doc/${P}/ps
	doins doc/*.ps
	insinto /usr/share/${PN}/examples
	cd examples
	for example in *; do
		tar -czf ${example}.tar.gz ${example}
		doins ${example}.tar.gz
	done
}
