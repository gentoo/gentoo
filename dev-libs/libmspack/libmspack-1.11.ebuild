# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/kyz/libmspack.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/kyz/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="https://www.cabextract.org.uk/libmspack/"

S="${WORKDIR}/${P}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug doc"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_test() {
	default

	cd "${S}"/test || die
	./cabd_test || die
}

src_install() {
	use doc && HTML_DOCS=( doc/. )

	default

	if use doc ; then
		rm "${ED}"/usr/share/doc/"${PF}"/html/{Makefile*,Doxyfile*} || die
	fi

	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name "*.a" -delete || die
}
