# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnxml/libnxml-0.18.3.ebuild,v 1.6 2012/06/29 12:54:53 ranger Exp $

EAPI="4"

DESCRIPTION="A C-library for parsing and writing XML 1.0/1.1 files or streams"
HOMEPAGE="http://www.autistici.org/bakunin/libnxml/doc/"
SRC_URI="http://www.autistici.org/bakunin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
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

	find "${D}" -name '*.la' -exec rm -f {} +
}
