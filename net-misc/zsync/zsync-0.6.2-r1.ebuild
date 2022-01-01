# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

ZLIB_PV=1.2.3
ZLIB_P="zlib-${ZLIB_PV}"

DESCRIPTION="Partial/differential file download client over HTTP which uses the rsync algorithm"
HOMEPAGE="http://zsync.moria.org.uk/"
SRC_URI="
	http://zsync.moria.org.uk/download/${P}.tar.bz2
	http://www.gzip.org/zlib/${ZLIB_P}.tar.bz2
	http://www.zlib.net/${ZLIB_P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

ZLIB_S="${WORKDIR}/${ZLIB_P}"

src_prepare() {
	# Move old zlib-1.2.11 out the way
	mv "${S}"/zlib zlib-1.2.11-modified || die

	cd "${ZLIB_S}" || die
	# I am not sure how many other zlib patches we will need to port as well
	# This covers the security vuln in 1.2.11
	epatch "${FILESDIR}"/${P}-${ZLIB_P}-support.patch
	rm -f Makefile || die

	cd "${S}" || die
	cp -a "${ZLIB_S}" "${ZLIB_P}-modified" || die
	ln -s "${ZLIB_P}-modified" zlib || die

	eautoreconf
}

src_install() {
	dobin zsync zsyncmake
	dodoc NEWS README
	doman doc/zsync.1 doc/zsyncmake.1
}
