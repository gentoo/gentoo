# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools-utils

DESCRIPTION="Condor's classified advertisement language"
HOMEPAGE="http://www.cs.wisc.edu/condor/classad/"
SRC_URI="ftp://ftp.cs.wisc.edu/condor/classad/c++/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcre static-libs"

RDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}"

src_configure() {
	myeconfargs+=(
		--enable-namespace
		--enable-flexible-member
	)
	autotools-utils_src_configure
}
