# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils perl-module versionator autotools

DESCRIPTION="Generates ppds out of xml foomatic printer description files"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://www.openprinting.org/download/foomatic/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="net-print/cups
	virtual/pkgconfig"
RDEPEND="
	dev-libs/libxml2
	>=net-print/cups-filters-1.0.43-r1[foomatic]
"
PDEPEND="net-print/foomatic-db"

src_prepare() {
	epatch \
		"${FILESDIR}"/4.0.7-perl-module.patch \
		"${FILESDIR}"/4.0.7-respect-ldflag.patch \
		"${FILESDIR}"/4.0.12-use-pkgconfig.patch
	sed -i -e "s:@LIB_CUPS@:$(cups-config --serverbin):" Makefile.in || die
	eautoreconf

	cd lib
	perl-module_src_prepare
}

src_configure() {
	default
	emake defaults

	cd lib
	perl-module_src_configure
}

src_compile() {
	default

	cd lib
	perl-module_src_compile
}

src_install() {
	default
	dodoc USAGE

	cd lib
	perl-module_src_install
}

src_test() {
	cd lib
	perl-module_src_test
}
