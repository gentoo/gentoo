# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_PN=${PN}-fuse
MY_P=${MY_PN}-${PV}

DESCRIPTION="Amazon S3 mounting via fuse"
HOMEPAGE="https://github.com/s3fs-fuse/s3fs-fuse/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openssl nss gnutls nettle"
REQUIRED_USE="
	^^ ( openssl nss gnutls )
	nettle? ( gnutls )"

CDEPEND="
	>=dev-libs/libxml2-2.6:2
	openssl? ( dev-libs/openssl:0 )
	nss? ( dev-libs/nss )
	gnutls? ( net-libs/gnutls )
	nettle? ( dev-libs/nettle )
	>=net-misc/curl-7.0
	>=sys-fs/fuse-2.8.4"

RDEPEND="
	${CDEPEND}
	app-misc/mime-types"

DEPEND="
	${CDEPEND}
	virtual/pkgconfig"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with nss) \
		$(use_with nettle) \
		$(use_with gnutls) \
		$(use_with openssl)
}
