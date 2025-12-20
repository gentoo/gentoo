# Copyright 2007-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple templatized C++ library for parsing command line arguments"
HOMEPAGE="http://tclap.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	econf $(use_enable doc doxygen)
}

src_test() {
	emake -j1 check
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}"/usr/share/doc/${PF}/html install
}
