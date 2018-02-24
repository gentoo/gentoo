# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune toolchain-funcs

DESCRIPTION="A straightforward implementation of DBM"
HOMEPAGE="http://fallabs.com/kyotocabinet/"
SRC_URI="${HOMEPAGE}pkg/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="debug doc examples static-libs"

DEPEND="sys-libs/zlib[static-libs?]
	app-arch/xz-utils[static-libs?]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix_configure-1.2.62.patch
	"${FILESDIR}"/${PN}-1.2.76-configure-8-byte-atomics.patch
	"${FILESDIR}"/${PN}-1.2.76-flags.patch
	"${FILESDIR}"/${PN}-1.2.76-gcc6.patch
)

src_prepare() {
	default

	sed -i -e "/DOCDIR/d" Makefile.in || die
	tc-export AR

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable !static-libs shared) \
		--enable-lzma
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	prune_libtool_files

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/*
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	fi
}
