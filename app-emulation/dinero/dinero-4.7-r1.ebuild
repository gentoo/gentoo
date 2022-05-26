# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_P="d${PV/./-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Cache simulator"
HOMEPAGE="https://pages.cs.wisc.edu/~markhill/DineroIV/"
SRC_URI="ftp://ftp.cs.wisc.edu/markhill/DineroIV/${MY_P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_prepare() {
	default

	# 331837
	sed -e "s/\$(CC)/& \$(LDFLAGS)/" \
	  -i Makefile.in || die

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	tc-export AR
	default
}

src_install() {
	dobin dineroIV
	dodoc CHANGES COPYRIGHT NOTES README TODO
}
