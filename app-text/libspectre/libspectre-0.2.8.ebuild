# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A library for rendering Postscript documents"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libspectre"
SRC_URI="https://libspectre.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug doc static-libs"

RDEPEND=">=app-text/ghostscript-gpl-8.62"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

# does not actually test anything, see bug 362557
RESTRICT="test"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-0.2.0-interix.patch
	eautoreconf # need new libtool for interix
}

src_configure() {
	econf \
		$(use_enable debug asserts) \
		$(use_enable debug checks) \
		$(use_enable static-libs static) \
		--disable-test
}

src_compile() {
	emake
	if use doc; then
		doxygen || die
	fi
}

src_install() {
	default
	use doc && dohtml -r doc/html/*
	prune_libtool_files
}
