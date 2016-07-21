# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="MITM all SSL connections on a LAN and dynamically generates certs"
HOMEPAGE="http://thoughtcrime.org/software/sslsniff/"
SRC_URI="http://thoughtcrime.org/software/sslsniff/${P}.tar.gz"

LICENSE="GPL-3" # plus OpenSSL exception
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/boost:=
	dev-libs/log4cpp:=
	dev-libs/openssl:0"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README )

# last two patches are taken from http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=652756
PATCHES=(
	"${FILESDIR}"/${PN}-0.6-asneeded.patch
	"${FILESDIR}"/${P}-error-redefinition.patch
	"${FILESDIR}"/${P}-fix-compatibility-with-boost-1.47-and-higher.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

src_prepare() {
	epatch ${PATCHES[@]}
	epatch_user

	eautoreconf
}

src_install() {
	default

	insinto /usr/share/sslsniff
	doins leafcert.pem IPSCACLASEA1.crt

	insinto /usr/share/sslsniff/updates
	doins updates/*xml

	insinto /usr/share/sslsniff/certs
	doins certs/*
}
