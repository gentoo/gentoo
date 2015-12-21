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
SLOT="0/2"
KEYWORDS="~amd64 ~arm hppa ~x86 ~amd64-linux"
IUSE="debug doc static-libs test"

RDEPEND="
	>=dev-libs/libestr-0.1.3
	>=dev-libs/json-c-0.11:=
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-python/sphinx-1.2.2 )
"

DOCS=( ChangeLog )

PATCHES=(
	"${FILESDIR}"/respect_CFLAGS.patch
	"${FILESDIR}"/${PN}-1.1.2-issue_135.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable test testbench)
		$(use_enable debug)
		--disable-regexp
	)

	autotools-utils_src_configure
}

src_test() {
	# When adding new tests via patches we have to make them executable
	einfo "Adjusting permissions of test scripts ..."
	find "${S}"/tests -type f -name '*.sh' \! -perm -111 -exec chmod a+x '{}' \; || \
		die "Failed to adjust test scripts permission"

	emake --jobs 1 check
}
