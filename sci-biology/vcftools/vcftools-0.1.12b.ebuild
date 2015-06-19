# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/vcftools/vcftools-0.1.12b.ebuild,v 1.1 2015/04/03 15:31:25 dilfridge Exp $

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

MY_P="${PN}_${PV}"

DESCRIPTION="Tools for working with VCF (Variant Call Format) files"
HOMEPAGE="http://vcftools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lapack"

RDEPEND="lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch
	tc-export CXX PKG_CONFIG
}

src_compile() {
	local myconf
	use lapack && myconf="VCFTOOLS_PCA=1"
	emake -C cpp ${myconf}
}

src_install(){
	perl_set_version
	dobin cpp/${PN}
	insinto ${VENDOR_LIB}
	doins perl/*.pm
	dobin perl/{fill,vcf}-*
	dodoc README.txt
}
