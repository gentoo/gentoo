# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="COmputer Language Manipulation"
HOMEPAGE="https://www.colm.net/open-source/colm/"
SRC_URI="https://www.colm.net/files/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

BDEPEND="
	doc? (
		|| ( app-text/asciidoc dev-ruby/asciidoctor )
		dev-python/pygments
	)
"
# libfsm moved from ragel -> colm, bug #766108
RDEPEND="!<dev-util/ragel-7.0.3"

src_prepare() {
	default

	# bug #733426
	sed -i -e 's/(\[ASCIIDOC\], \[asciidoc\], \[asciidoc\]/S([ASCIIDOC], [asciidoc asciidoctor]/' configure.ac || die

	# bug #766069
	sed -i -e "s:gcc:$(tc-getCC):" test/colm.d/gentests.sh || die
	sed -i -e "s:g++:$(tc-getCXX):" test/colm.d/gentests.sh || die

	eautoreconf
}

src_configure() {
	econf $(use_enable doc manual)
}

src_test() {
	# Build tests
	default

	# Run them
	cd test || die
	./runtests || die
}

src_install() {
	default

	# NOTE: dev-util/ragel needs the static libraries
	# and .la files, unfortunately.
	# (May have better luck if we use the CMake port?)
}
