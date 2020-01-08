# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A simple and lightweight interface to the CGI for C and C++ programs"
HOMEPAGE="http://www.infodrom.org/projects/cgilib/"
SRC_URI="${HOMEPAGE}download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog README cookies.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}
