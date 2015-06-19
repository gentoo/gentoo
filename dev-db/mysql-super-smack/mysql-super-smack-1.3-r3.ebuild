# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-super-smack/mysql-super-smack-1.3-r3.ebuild,v 1.7 2015/01/26 10:30:05 ago Exp $

EAPI=5
WANT_AUTOMAKE="1.13"
AUTOTOOLS_AUTORECONF="YES"
#AUTOTOOLS_IN_SOURCE_BUILD="YES"

inherit eutils autotools-utils

MY_PN="super-smack"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Benchmarking, stress testing, and load generation tool for MySQL & PostGreSQL"
HOMEPAGE="http://vegan.net/tony/supersmack/"
SRC_URI="http://vegan.net/tony/supersmack/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+mysql postgres"
REQUIRED_USE="|| ( mysql postgres )"

DEPEND="mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql[server] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.destdir.patch
	"${FILESDIR}"/${PN}-1.3.amd64.patch
	"${FILESDIR}"/${PN}-1.3.gcc4.3.patch
	"${FILESDIR}"/${PN}-1.3-gen-data.patch
	"${FILESDIR}"/${PN}-1.3-automake-1.13.patch
)
DOCS=( CHANGES INSTALL MANUAL README TUTORIAL )

src_prepare() {
	# Clean up files so eautoreconf does not pick up any
	# deprecated autotools macros.
	rm acinclude.m4 aclocal.m4 acconfig.h config.status config.h || die
	mv configure.in configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(usex mysql --with-mysql "")
		$(usex postgres --with-pgsql "")
		--with-datadir=/var/tmp/${MY_PN}
		--with-smacks-dir=/usr/share/${MY_PN}
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	elog "The gen-data binary is now installed as super-smack-gen-data"
}
