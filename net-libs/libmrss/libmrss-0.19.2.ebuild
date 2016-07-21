# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="A C-library for parsing and writing RSS 0.91/0.92/1.0/2.0 files or streams"
HOMEPAGE="http://www.autistici.org/bakunin/libmrss/doc/"
SRC_URI="http://www.autistici.org/bakunin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc x86"
IUSE="doc examples static-libs"

RDEPEND=">=net-libs/libnxml-0.18.0
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

# TODO: php-bindings

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_compile() {
	emake

	if use doc; then
		ebegin "Creating documentation"
		doxygen doxy.conf || die "generating docs failed"
		eend 0
	fi
}

src_install() {
	default

	if use doc; then
		dohtml doc/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/test
		doins test/*.c
	fi

	find "${D}" -name '*.la' -exec rm -f {} +
}
