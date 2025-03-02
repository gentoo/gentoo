# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

MYPN=Montage
DESCRIPTION="Toolkit for assembling FITS images into mosaics"
HOMEPAGE="http://montage.ipac.caltech.edu/"
SRC_URI="http://montage.ipac.caltech.edu/download/${MYPN}_v${PV}.tar.gz"
S="${WORKDIR}/${MYPN}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc mpi"

RDEPEND="
	media-libs/freetype:2=
	media-libs/libjpeg-turbo:0=
	sci-astronomy/wcstools:0=
	sci-libs/cfitsio:0=
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1-fix_format_errors.patch
	"${FILESDIR}"/${PN}-4.1-initdistdata.patch
	"${FILESDIR}"/${PN}-5.0-fix_freetype_incude.patch
	"${FILESDIR}"/${PN}-5.0-c23.patch
)

src_prepare() {
	default

	sed -e '/cfitsio/d' \
		-e '/wcssubs/d' \
		-e '/jpeg/d' \
		-e '/freetype/d' \
		-i lib/src/Makefile || die

	tc-export CC AR

	# bug #708396
	append-cflags -fcommon -std=gnu17

	find . -name Makefile\* | xargs sed -i \
		-e "/^CC.*=/s:\(gcc\|cc\):$(tc-getCC):g" \
		-e "/^CFLAGS.*=/s:-g:${CFLAGS} $($(tc-getPKG_CONFIG) --cflags wcstools):g" \
		-e "s:-I../../lib/freetype/include :$($(tc-getPKG_CONFIG) --cflags freetype2):g" \
		-e 's:$(CC) -o:$(CC) $(LDFLAGS) -o:g' \
		-e "s:-lwcs:$($(tc-getPKG_CONFIG) --libs wcstools):g" \
		-e "s:-lcfitsio:$($(tc-getPKG_CONFIG) --libs cfitsio):g" \
		-e 's:-lnsl::g' \
		-e "s:ar q:$(tc-getAR) q:g"  || die

	if use mpi; then
		sed -e 's:# MPICC:MPICC:' \
			-e 's:# BINS:BINS:' \
			-i Montage/Makefile.* || die
	fi

	# Handwritten makefile. No parallel build support
	# bug #888553 #942753
	MAKEOPTS=-j1
}

src_install() {
	dobin bin/*
	dodoc README* ChangeHistory
	use doc && dodoc -r man/*
}
