# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools games

DESCRIPTION="ROM management tools and library"
HOMEPAGE="http://mamory.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/expat"
RDEPEND="${DEPEND}"

src_prepare() {
	# Make sure the system expat is used
	sed -i \
		-e 's/#ifdef.*SYSEXPAT/#if 1/' \
		mamory/amlxml.c mamory/amlxml.h || die

	# Remove hardcoded CFLAGS options
	sed -i \
		-e '/AC_ARG_ENABLE(debug,/ {N;N;N;d}' \
		configure.ac || die

	# Make it possible for eautoreconf to fix fPIC etc.
	sed -i \
		-e '/libcommon_la_LDFLAGS= -static/d' \
		common/Makefile.am || die

	AT_M4DIR="config" eautoreconf
}

src_configure() {
	egamesconf \
		--includedir=/usr/include
}

src_install() {
	default
	dohtml DOCS/mamory.html
	prepgamesdirs
}
