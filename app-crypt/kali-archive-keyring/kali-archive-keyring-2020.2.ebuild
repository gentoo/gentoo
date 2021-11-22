# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GnuPG archive keys of the Kali archive"
HOMEPAGE="https://www.kali.org"
SRC_URI="https://http.kali.org/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="app-crypt/jetring"
