# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF="yes"

inherit autotools-utils

DESCRIPTION="Fast samples-based log normalization library"
HOMEPAGE="http://www.liblognorm.com"
SRC_URI="http://www.liblognorm.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="amd64 arm hppa x86 ~amd64-linux"
IUSE="debug doc pcre static-libs test"

RDEPEND="
	>=dev-libs/libestr-0.1.3
	>=dev-libs/json-c-0.11:=
	pcre? ( >=dev-libs/libpcre-8.35 )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog )

PATCHES=(
	"${FILESDIR}"/respect_CFLAGS.patch
	"${FILESDIR}"/${PN}-1.1.0-fix-enable-docs.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc docs)
		$(use_enable pcre regexp)
		$(use_enable test testbench)
	)

	autotools-utils_src_configure
}
