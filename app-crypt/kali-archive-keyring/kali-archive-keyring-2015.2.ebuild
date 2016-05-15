# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="GnuPG archive keys of the Kali archive"
HOMEPAGE="http://www.kali.org"
SRC_URI="http://http.kali.org/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="app-crypt/jetring"

MAKEOPTS+=' -j1'
