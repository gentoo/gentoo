# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Toolkit for assembling FITS images into mosaics"
HOMEPAGE="http://montage.ipac.caltech.edu/"
SRC_URI="https://github.com/Caltech-IPAC/Montage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Montage-${PV}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-arch/bzip2:=
	media-libs/freetype:2
	sci-astronomy/wcstools
	sci-libs/cfitsio:0=
	media-libs/libjpeg-turbo:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1-prototypes.patch
	"${FILESDIR}"/${PN}-6.1-tcol-cntr.patch
	"${FILESDIR}"/${PN}-6.1-presentation-strcpy.patch
	"${FILESDIR}"/${PN}-6.1-montagelib-dep.patch
)

src_prepare() {
	default

	sed -e '/cfitsio/d' \
		-e '/wcssubs/d' \
		-e '/jpeg/d' \
		-e '/freetype/d' \
		-e '/bzip2/d' \
		-i lib/src/Makefile MontageLib/Makefile || die

	tc-export CC AR

	# bug #708396
	append-cflags -fcommon

	find . -type f -name Makefile\* -execdir sed -i \
		-e "/^CC.*=/s#\(gcc\|cc\)#$(tc-getCC)#g" \
		-e "/^CFLAGS.*=/s#-g#${CFLAGS} $($(tc-getPKG_CONFIG) --cflags wcstools)#g" \
		-e "s#-I../../lib/freetype/include #$($(tc-getPKG_CONFIG) --cflags freetype2)#g" \
		-e 's#$(CC) -o#$(CC) $(LDFLAGS) -o#g' \
		-e 's#$(CC) -g -o#$(CC) $(LDFLAGS) -o#g' \
		-e "s#-lwcs#$($(tc-getPKG_CONFIG) --libs wcstools)#g" \
		-e "s#-lcfitsio#$($(tc-getPKG_CONFIG) --libs cfitsio)#g" \
		-e 's#-lnsl##g' \
		-e "s#\tar #\t$(tc-getAR) #g" \
		-e "s#ranlib #$(tc-getRANLIB) #g" \
		-e "s#\tgcc -shared#\t$(tc-getCC) \$(LDFLAGS) -shared#g" \
		-e "s#\tgcc -std=gnu99 -o#\t$(tc-getCC) \$(LDFLAGS) -o#g" \
		-e "s#\tgcc -std=gnu99 -g -O2#\t$(tc-getCC) \$(CFLAGS)#g" \
		'{}' + || die
}

src_install() {
	dobin bin/*
	dodoc README* ChangeHistory
	use doc && dodoc -r man/*
}
