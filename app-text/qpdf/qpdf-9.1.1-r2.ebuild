# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="http://qpdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/qpdf/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 Artistic-2 )"

# subslot = libqpdf soname version
SLOT="0/26"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="doc examples static-libs test"

RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/gnutls:0=
	sys-libs/zlib
	virtual/jpeg:0=
"
DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		media-libs/tiff
		app-text/ghostscript-gpl[tiff(+)]
	)
"

DOCS=( ChangeLog README.md TODO )

src_configure() {
	local myeconfargs=(
		--disable-implicit-crypto
		--enable-crypto-gnutls
		--enable-crypto-native
		--with-default-crypto=gnutls
		$(use_enable static-libs static)
		$(use_enable test test-compare-images)
	)
	CONFIG_SHELL=/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use examples ; then
		dobin examples/build/.libs/*
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
