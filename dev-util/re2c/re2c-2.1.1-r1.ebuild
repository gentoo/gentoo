# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="tool for generating C-based recognizers from regular expressions"
HOMEPAGE="http://re2c.org/"
SRC_URI="https://github.com/skvadrik/re2c/releases/download/${PV}/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug"

PATCHES=("${FILESDIR}"/${P}-sh.patch)

src_configure() {
	econf \
		--enable-golang \
		ac_cv_path_BISON="no" \
		$(use_enable debug)
}

src_install() {
	default

	docompress -x /usr/share/doc/${PF}/examples
	dodoc -r README.md CHANGELOG examples
}
