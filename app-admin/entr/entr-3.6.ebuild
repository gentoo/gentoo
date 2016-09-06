# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Run arbitrary commands when files change"
HOMEPAGE="http://entrproject.org/"
SRC_URI="http://entrproject.org/code/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

src_unpack() {
	unpack "${P}.tar.gz"
	mv eradman-* "${P}" || die
}

src_configure() {
	sh configure || die
	sed -i -e 's#\(^PREFIX \).*#\1\?= /usr#' Makefile.bsd || die
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" install
}
