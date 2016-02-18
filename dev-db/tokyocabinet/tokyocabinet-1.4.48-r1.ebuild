# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="A library of routines for managing a database"
HOMEPAGE="http://fallabs.com/tokyocabinet/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="bzip2 debug doc examples threads zlib"

DEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fix_rpath.patch"
	sed -i \
		-e "/ldconfig/d" \
		-e "/DATADIR/d" Makefile.in || die
	# cflags fix - remove -O2 at end of line and -fomit-frame-pointer
	sed -i -e 's/-O3"$/"/' configure.in || die
	sed -i -e 's/-fomit-frame-pointer//' configure.in || die
	# flag only works on x86 derivatives, remove everywhere else
	if ! use x86 && ! use amd64; then sed -i -e 's/ -minline-all-stringops//' configure.in; fi
	eautoreconf
}

src_configure() {
	# we use the "fastest" target without the -O3
	econf \
	$(use_enable debug) \
	$(use_enable bzip2 bzip) \
	$(use_enable zlib) \
	$(use_enable threads pthread) \
	--enable-off64 --enable-fastest
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/* || die "Install failed"
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/* || die "Install failed"
	fi
}

src_test() {
	emake -j1 check || die "Tests failed"
}
