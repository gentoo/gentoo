# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://codeberg.org/grisha/gumbo-parser"
SRC_URI="https://codeberg.org/grisha/gumbo-parser/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gumbo-parser"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	default

	if use doc; then
		doxygen || die "doxygen failed"
		HTML_DOCS=( docs/html/. )
	fi
}

src_install() {
	default
	use doc && doman docs/man/man3/*

	find "${ED}" -name '*.la' -delete || die
}
