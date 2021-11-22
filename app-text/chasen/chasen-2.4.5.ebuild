# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit perl-module

DESCRIPTION="Japanese Morphological Analysis System, ChaSen"
HOMEPAGE="https://chasen-legacy.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}-legacy/56305/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~riscv x86 ~sparc-solaris"
IUSE="perl static-libs"

RDEPEND="virtual/libiconv"
DEPEND=">=dev-libs/darts-0.32"
PDEPEND=">=app-dicts/ipadic-2.7.0"

PATCHES=( "${FILESDIR}"/${PN}-uar.patch )

src_configure() {
	econf $(use_enable static-libs static)

	if use perl; then
		cd "${S}"/perl || die
		perl-module_src_configure
	fi
}

src_compile() {
	default

	if use perl; then
		cd "${S}"/perl || die
		perl-module_src_compile
	fi
}

src_test() {
	default

	if use perl; then
		cd "${S}"/perl || die
		perl-module_src_test
	fi
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	if use perl; then
		cd "${S}"/perl || die
		perl-module_src_install
		newdoc README README.perl
	fi
}
