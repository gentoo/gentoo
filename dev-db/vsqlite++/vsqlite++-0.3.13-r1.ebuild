# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/vsqlite++/vsqlite++-0.3.13-r1.ebuild,v 1.3 2015/04/18 12:12:20 swegener Exp $

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="VSQLite++ - A welldesigned and portable SQLite3 Wrapper for C++"
HOMEPAGE="http://evilissimo.fedorapeople.org/releases/vsqlite--/"
SRC_URI="https://github.com/vinzenz/vsqlite--/archive/${PV}.tar.gz -> ${P}.tar.gz"
IUSE="static-libs"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=dev-libs/boost-1.33.1"

RDEPEND="${DEPEND}
		dev-db/sqlite:3"

DOCS=(AUTHORS COPYING ChangeLog INSTALL NEWS README.md TODO VERSION)

# package name is vsqlite++, but github / homepage name is vsqlite--
S="${WORKDIR}/vsqlite---${PV}"

src_prepare() {
	## remove O3 in AM_CXXFLAGS
	sed -i -e 's/-O3//' Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	econf $(use_enable static-libs static)
}
