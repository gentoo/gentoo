# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/classads/classads-1.0.10.ebuild,v 1.1 2012/01/11 22:18:07 bicatali Exp $

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
