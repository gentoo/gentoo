# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN=${PN}-fuse
MY_P=${MY_PN}-${PV}

DESCRIPTION="Amazon S3 mounting via fuse"
HOMEPAGE="https://github.com/s3fs-fuse/s3fs-fuse/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls nettle nss +openssl test"
REQUIRED_USE="
	^^ ( gnutls nss openssl )
	nettle? ( gnutls )"

# Requires active internet connection
RESTRICT="test"

DEPEND="
	dev-libs/libxml2:2
	net-misc/curl
	sys-fs/fuse:0
	gnutls? ( net-libs/gnutls:= )
	nettle? ( dev-libs/nettle:= )
	nss? ( dev-libs/nss )
	openssl? ( dev-libs/openssl:0= )
"

RDEPEND="${DEPEND}
	app-misc/mime-types
"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with gnutls)
		$(use_with nettle)
		$(use_with nss)
		$(use_with openssl)
	)
	econf "${myeconfargs[@]}"
}
