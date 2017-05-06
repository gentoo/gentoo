# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit autotools autotools-utils

DESCRIPTION="A simple and lightweight interface to the CGI for C and C++ programs"
HOMEPAGE="http://www.infodrom.org/projects/cgilib/"
SRC_URI="http://www.infodrom.org/projects/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog README cookies.txt )

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}
