# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-dnh${PV}"

DESCRIPTION="Enhanced CTorrent is a BitTorrent console client written in C and C++"
HOMEPAGE="http://www.rahul.net/dholmes/ctorrent/"
SRC_URI="mirror://sourceforge/dtorrent/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ~s390 ~sparc x86"
IUSE="libressl"

RDEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-CVE-2009-1759.patch
	"${FILESDIR}"/${P}-negative-ints.patch
	"${FILESDIR}"/${P}-empty-path-components.patch
	"${FILESDIR}"/${P}-sys-types_h.patch
)
