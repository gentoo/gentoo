# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="Foreign function interface for C and Objective-C libraries"
HOMEPAGE="http://www.koguro.net/prog/c-wrapper/"
SRC_URI="http://www.koguro.net/prog/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE="examples"

RDEPEND="dev-scheme/gauche
	virtual/libffi"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-system-libffi.diff
	eautoreconf
}

src_test() {
	emake -j1 -s check
}

src_install() {
	default
	dohtml doc/*

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
