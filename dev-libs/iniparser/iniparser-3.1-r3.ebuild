# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="http://ndevilla.free.fr/iniparser/"
SRC_URI="http://ndevilla.free.fr/iniparser/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"
# the tests are rather examples than tests, no point in running them
RESTRICT="test"

BDEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0b-cpp.patch
	"${FILESDIR}"/${PN}-3.0-autotools.patch
	"${FILESDIR}"/${PN}-4.0-out-of-bounds-read.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	if use doc; then
		emake -C doc
		HTML_DOCS=( html/. )
	fi

	default

	if use examples; then
		docinto examples
		dodoc test/*.{c,ini,py}
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}
