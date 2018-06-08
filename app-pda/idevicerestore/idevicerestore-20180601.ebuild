# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

EGIT_COMMIT="707856d9005a48ee006dfcc7e5424473cf9e7652"

DESCRIPTION="A cross-platform tool to restore Apple devices from IPSW files."
HOMEPAGE="http://libimobiledevice.org"
SRC_URI="https://github.com/libimobiledevice/idevicerestore/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/idevicerestore-${EGIT_COMMIT}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/6"
KEYWORDS="~amd64"

RDEPEND="app-pda/libirecovery:0=
	>=app-pda/libimobiledevice-1.1.6:0=
	app-pda/libplist:0=
	>=dev-libs/libzip-0.8.0
	>=net-misc/curl-7.0.0
	dev-libs/openssl:0=
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS INSTALL NEWS README TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# the software's configure.ac doesn't handle things quite correctly,
	# pass -pthread and -lpthread to solve the issue
	append-flags "-pthread"
	append-ldflags "-lpthread"
	econf
}

src_install() {
	default
	doman docs/idevicerestore.1
	find "${D}" -name '*.la' -delete || die
}
