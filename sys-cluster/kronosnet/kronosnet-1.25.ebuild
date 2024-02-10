# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network abstraction layer designed for High Availability use cases"
HOMEPAGE="https://kronosnet.org"
SRC_URI="https://kronosnet.org/releases/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~sparc x86"
IUSE="doc nss +openssl lz4 lzo2 test zstd"
RESTRICT="!test? ( test )"

DEPEND="
	>=sys-cluster/libqb-2.0.0:=
	dev-libs/libnl:3
	sys-libs/zlib:=
	app-arch/bzip2:=
	app-arch/xz-utils
	zstd? ( app-arch/zstd:= )
	lzo2? ( dev-libs/lzo:2 )
	lz4? ( app-arch/lz4:= )
	nss? ( dev-libs/nss )
	openssl? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		>=sys-cluster/libqb-2.0.0
		app-text/doxygen[dot]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.19-no-Werror.patch
	"${FILESDIR}"/${PN}-1.23-no-extra-fortify-source.patch
)

src_prepare() {
	default

	# For our patches
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc man)

		--enable-libnozzle
		--disable-libknet-sctp
		--enable-compress-zlib
		--enable-compress-bzip2
		--enable-compress-lzma

		$(use_enable nss crypto-nss)
		$(use_enable openssl crypto-openssl)
		$(use_enable zstd compress-zstd)
		$(use_enable lz4 compress-lz4)
		$(use_enable lzo2 compress-lzo2)

		$(use_enable test functional-tests)
	)

	econf "${myeconfargs[@]}"
}
