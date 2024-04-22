# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="This is an IPv4 and IPv6 capable GeoIP dlfunc library for Exim"
HOMEPAGE="https://dist.epipe.com/exim/"
SRC_URI="https://dist.epipe.com/exim/exim-geoipv6-dlfunc-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/geoip
	mail-mta/exim[dlfunc]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/exim-geoipv6-dlfunc-${PV}"

src_configure() {
	append-cppflags "-I/usr/include/exim -DDLFUNC_IMPL"
	econf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Failed to prune libtool files"
}
