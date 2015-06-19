# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/kyotocabinet/kyotocabinet-1.2.76-r1.ebuild,v 1.5 2015/05/01 05:44:59 jer Exp $

EAPI=5

inherit autotools eutils toolchain-funcs

DESCRIPTION="A straightforward implementation of DBM"
HOMEPAGE="http://fallabs.com/kyotocabinet/"
SRC_URI="${HOMEPAGE}pkg/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="debug doc examples static-libs"

DEPEND="sys-libs/zlib
	app-arch/xz-utils"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/fix_configure-1.2.62.patch
	epatch "${FILESDIR}"/${PN}-1.2.76-configure-8-byte-atomics.patch
	epatch "${FILESDIR}"/${PN}-1.2.76-flags.patch
	sed -i -e "/DOCDIR/d" Makefile.in || die
	tc-export AR

	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable !static-libs shared) \
		--enable-lzma --docdir=/usr/share/doc/${PF}
}

src_test() {
	emake -j1 check
}

src_install() {
	emake DESTDIR="${D}" install

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
