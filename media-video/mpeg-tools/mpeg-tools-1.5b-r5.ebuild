# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PN=mpeg_encode
DESCRIPTION="Tools for MPEG video"
HOMEPAGE="http://bmrc.berkeley.edu/research/mpeg/mpeg_encode.html"
SRC_URI="ftp://mm-ftp.cs.berkeley.edu/pub/multimedia/mpeg/encode/${MY_PN}-${PV}-src.tar.gz"
S="${WORKDIR}"/${MY_PN}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x64-macos"

RDEPEND="x11-libs/libX11
	virtual/jpeg:0"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-64bit_fixes.patch
	"${FILESDIR}"/${P}-tempfile-convert.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-powerpc.patch
	"${FILESDIR}"/${P}-jpeg.patch
	"${FILESDIR}"/${P}-tempfile-mpeg-encode.patch
	"${FILESDIR}"/${P}-tempfile-tests.patch
	"${FILESDIR}"/0001-fix-missing-prototype-for-internal-jpeg-ABI.patch
	"${FILESDIR}"/0001-fix-K-R-C-on-various-counts.patch
)

src_prepare() {
	cd .. || die
	default
	cd "${S}" || die

	rm -r jpeg || die

	# don't include malloc.h, but use stdlib.h instead
	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:' \
		convert/*.c convert/mtv/*.c *.c headers/*.h || die
}

src_compile() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861137
	# Upstream is thoroughly dead, homepage doesn't even exist anymore.
	filter-lto

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

	cd ../convert || die
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
