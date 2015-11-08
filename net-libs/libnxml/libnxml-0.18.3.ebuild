# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="A C-library for parsing and writing XML 1.0/1.1 files or streams"
HOMEPAGE="http://www.autistici.org/bakunin/libnxml/doc/"
SRC_URI="http://www.autistici.org/bakunin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ~sparc x86"
IUSE="doc examples static-libs"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_compile() {
	emake

	if use doc; then
		ebegin "Creating documentation"
		doxygen doxy.conf || die "creating docs failed"
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

	find "${D}" -name '*.la' -delete
}
