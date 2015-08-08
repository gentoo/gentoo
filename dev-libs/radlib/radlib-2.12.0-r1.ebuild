# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils autotools

DESCRIPTION="Rapid Application Development Library"
HOMEPAGE="http://www.radlib.teel.ws/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"

SLOT="0"
IUSE="mysql postgres sqlite static-libs"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

RESTRICT_USE="^^ ( mysql postgres )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable mysql)
		$(use_enable postgres pgresql)
		$(use_enable sqlite)
	)

	autotools-utils_src_configure
}

src_test() { :; }
