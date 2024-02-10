# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="SMT Solver supporting SMT-LIB and Yices specification language"
HOMEPAGE="https://github.com/SRI-CSL/yices2/"
SRC_URI="https://github.com/SRI-CSL/${PN}/archive/Yices-${PV}.tar.gz"
S="${WORKDIR}"/${PN}-Yices-${PV}

LICENSE="GPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+mcsat"

RDEPEND="
	dev-libs/gmp:=
	mcsat? (
		sci-mathematics/libpoly:=
		sci-mathematics/cudd:=
	)
"
DEPEND="${RDEPEND}"

DOCS=( FAQ.md README.md )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable mcsat)
}

src_compile() {
	emake STRIP=echo
}

src_install() {
	default

	doman doc/*.1

	rm "${ED}"/usr/$(get_libdir)/libyices.a || die
}
