# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit epatch toolchain-funcs

MY_PN=mpeg_encode
DESCRIPTION="Tools for MPEG video"
HOMEPAGE="http://bmrc.berkeley.edu/research/mpeg/mpeg_encode.html"
SRC_URI="ftp://mm-ftp.cs.berkeley.edu/pub/multimedia/mpeg/encode/${MY_PN}-${PV}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

RDEPEND="x11-libs/libX11
	virtual/jpeg:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	cd "${WORKDIR}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-64bit_fixes.patch
	epatch "${FILESDIR}"/${P}-tempfile-convert.patch
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-powerpc.patch
	cd "${S}"
	rm -r jpeg
	epatch "${FILESDIR}"/${P}-jpeg.patch
	epatch "${FILESDIR}"/${P}-tempfile-mpeg-encode.patch
	epatch "${FILESDIR}"/${P}-tempfile-tests.patch
	# don't include malloc.h, but use stdlib.h instead
	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:' \
		convert/*.c convert/mtv/*.c *.c headers/*.h || die
}

src_compile() {
	emake CC="$(tc-getCC)"
	emake -C convert CC="$(tc-getCC)"
	emake -C convert/mtv CC="$(tc-getCC)"
}

src_install() {
	dobin mpeg_encode
	doman docs/*.1
	dodoc BUGS CHANGES README TODO VERSION
	dodoc docs/EXTENSIONS docs/INPUT.FORMAT docs/*.param docs/param-summary
	docinto examples
	dodoc examples/*

	cd ../convert
	dobin eyuvtojpeg jmovie2jpeg mpeg_demux mtv/movieToVid
	newdoc README README.convert
	newdoc mtv/README README.mtv
}

pkg_postinst() {
	if [[ -z $(best_version media-libs/netpbm) ]]; then
		elog "If you are looking for eyuvtoppm or ppmtoeyuv, please"
		elog "emerge the netpbm package.  It has updated versions."
	fi
}
