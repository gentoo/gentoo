# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://github.com/google/gumbo-parser#readme"
SRC_URI="https://github.com/google/gumbo-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/gumbo-parser-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
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
