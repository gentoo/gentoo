# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-any-r1

DESCRIPTION="Tool for generating C-based recognizers from regular expressions"
HOMEPAGE="https://re2c.org/"
SRC_URI="https://github.com/skvadrik/re2c/releases/download/${PV}/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug test"

RESTRICT="!test? ( test )"

# python is used only as a test driver
BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	econf \
		--enable-golang \
		--enable-rust \
		ac_cv_path_BISON="no" \
		$(use_enable debug)
}

src_install() {
	default

	docompress -x /usr/share/doc/${PF}/examples
	dodoc -r README.md CHANGELOG examples
}
