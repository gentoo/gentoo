# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Utility for Active Directory administration"
HOMEPAGE="http://gp2x.org/adtool/"
SRC_URI="http://gp2x.org/adtool/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ssl"

DEPEND="
	net-nds/openldap
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-bfr-overflow.patch )

src_prepare() {
	# automake-1.13
	mv configure.{in,ac} || die
	sed \
		-e '/libactive_directory.a/s:@top_srcdir@:@top_builddir@:' \
		-i src/tools/Makefile.am || die
	autotools-utils_src_prepare
}
