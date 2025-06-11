# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools perl-module

DESCRIPTION="Generates ppds out of xml foomatic printer description files"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://www.openprinting.org/download/foomatic/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 sparc x86"

BDEPEND="
	net-print/cups
	virtual/pkgconfig"
RDEPEND="
	dev-libs/libxml2:=
	>=net-print/cups-filters-1.0.43-r1[foomatic]
"
DEPEND="${RDEPEND}"
PDEPEND="net-print/foomatic-db"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/4.0.7-perl-module.patch \
		"${FILESDIR}"/4.0.7-respect-ldflag.patch \
		"${FILESDIR}"/4.0.12-use-pkgconfig.patch
	sed -i -e "s:@LIB_CUPS@:$(cups-config --serverbin):" Makefile.in || die
	eautoreconf

	cd lib || die
	perl-module_src_prepare
}

src_configure() {
	default

	cd lib || die
	perl-module_src_configure
}

src_compile() {
	emake defaults
	default

	cd lib || die
	perl-module_src_compile
}

src_test() {
	cd lib || die
	perl-module_src_test
}

src_install() {
	default
	dodoc USAGE

	cd lib || die
	perl-module_src_install
}
