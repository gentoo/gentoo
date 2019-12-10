# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="header-only library for creating parsers according to Parsing Expression Grammar"
HOMEPAGE="https://github.com/ColinH/PEGTL"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/PEGTL-${PV}"

src_compile() {
	:
}

src_test() {
	emake CXX="$(tc-getCXX)" PEGTL_CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dodoc README.md
	insinto /usr/include
	doins -r pegtl pegtl.hh
}
