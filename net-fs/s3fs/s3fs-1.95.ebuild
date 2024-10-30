# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN=${PN}-fuse
MY_P=${MY_PN}-${PV}

DESCRIPTION="Amazon S3 mounting via fuse"
HOMEPAGE="https://github.com/s3fs-fuse/s3fs-fuse/"
SRC_URI="
	https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="gnutls nettle nss"
REQUIRED_USE="nettle? ( gnutls !nss )"

# Requires active internet connection and it tries to download some binaries for later execution
RESTRICT="test"

DEPEND="
	dev-libs/libxml2:2
	net-misc/curl
	sys-fs/fuse:0
	nss? ( dev-libs/nss )
	!nss? (
		gnutls? (
			net-libs/gnutls:=
			nettle? ( dev-libs/nettle:= )
		)
		!gnutls? ( dev-libs/openssl:0= )
	)
"

RDEPEND="
	${DEPEND}
	app-misc/mime-types
"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i 's/ -D_FORTIFY_SOURCE=3//' configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with nettle)
	)
	if use nss; then
		myeconfargs+=( $(use_with nss) )
	elif use gnutls; then
		myeconfargs+=( $(use_with gnutls) )
	else
		myeconfargs+=( --with-openssl )
	fi

	econf "${myeconfargs[@]}"
}
