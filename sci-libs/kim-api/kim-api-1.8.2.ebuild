# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}-v${PV}"
DESCRIPTION="Application Programming Interface for atomistic simulations"
HOMEPAGE="https://openkim.org"
SRC_URI="https://s3.openkim.org/${PN}/${MY_P}.tgz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

MAKEOPTS+=" -j1"

src_prepare() {
	#https://github.com/openkim/kim-api/pull/2
	sed -i 's/libDir/libdir/' configure
	default
}

src_configure() {
	#not an Autotools configure
	./configure --prefix=/usr --libdir=/usr/$(get_libdir) || die
}
