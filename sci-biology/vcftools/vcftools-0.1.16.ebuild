# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic perl-functions toolchain-funcs

DESCRIPTION="Tools for working with VCF (Variant Call Format) files"
HOMEPAGE="http://vcftools.sourceforge.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack"

RDEPEND="sys-libs/zlib
	dev-lang/perl:=
	lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	perl_set_version

	append-flags $($(tc-getPKG_CONFIG) --cflags lapack)
	append-libs $($(tc-getPKG_CONFIG) --libs lapack)

	econf \
		$(use_enable lapack pca) \
		--with-pmdir="${VENDOR_LIB#${EPREFIX}/usr}"
}
