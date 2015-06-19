# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/virtuoso-odbc/virtuoso-odbc-6.1.6.ebuild,v 1.6 2014/03/07 03:28:28 creffett Exp $

EAPI=4

inherit virtuoso

DESCRIPTION="ODBC driver for OpenLink Virtuoso Open-Source Edition"

KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/openssl-0.9.7i:0
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-6.1.6-am_config_header.patch" )

VOS_EXTRACT="
	libsrc/Dk
	libsrc/Thread
	libsrc/odbcsdk
	libsrc/util
	binsrc/driver
"

src_configure() {
	myconf+="
		--disable-static
		--without-iodbc
	"

	virtuoso_src_configure
}

src_install() {
	default_src_install

	# Remove libtool files
	find "${ED}" -name '*.la' -delete
}
