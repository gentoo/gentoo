# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

MYPN=Montage

DESCRIPTION="Toolkit for assembling FITS images into mosaics"
HOMEPAGE="http://montage.ipac.caltech.edu/"
SRC_URI="https://github.com/Caltech-IPAC/${MYPN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

IUSE="doc mpi"

RDEPEND="
	media-libs/freetype:2=
	sci-astronomy/wcstools:0=
	sci-libs/cfitsio:0=
	virtual/jpeg:0
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix_format_errors.patch"
	"${FILESDIR}/${P}-initdistdata.patch"
	"${FILESDIR}/${P}-fix_freetype_incude.patch"
	"${FILESDIR}/${P}-use_system_libs.patch"
)

S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	default
	tc-export CC AR

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
}

src_install () {
	dobin bin/*
	dodoc README* ChangeHistory
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r man/*
	fi
}
