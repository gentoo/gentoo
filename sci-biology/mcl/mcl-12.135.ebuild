# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

MY_P="${PN}-${PV/./-}"

DESCRIPTION="A Markov Cluster Algorithm implementation"
HOMEPAGE="http://micans.org/mcl/"
SRC_URI="http://micans.org/mcl/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blast"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find \
		-name Makefile.am \
		-exec sed \
			-e '/docdir/d' \
			-e '/exampledir/s:doc::g' \
			-i '{}' + || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( $(use_enable blast) )
	autotools-utils_src_configure
}
