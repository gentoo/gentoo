# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GnuPG archive keys of the Debian archive"
HOMEPAGE="http://packages.debian.org/sid/debian-archive-keyring"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/jetring"

MAKEOPTS+=' -j1'

PATCHES=(
	"${FILESDIR}"/${P}-order.patch
)
