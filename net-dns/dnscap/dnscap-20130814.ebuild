# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="network capture utility designed specifically for DNS traffic"
HOMEPAGE="https://dnscap.dns-oarc.net/"

## github commit tarball
MY_GIT_COMMIT="727ed7d5e46625abc2c8d988689a300589e948b6"
MY_P="verisign-${PN}-${MY_GIT_COMMIT:0:7}"
SRC_URI="https://github.com/verisign/${PN}/tarball/${MY_GIT_COMMIT} -> ${PF}.tar.gz"

S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="ISC"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}.install.patch" )
