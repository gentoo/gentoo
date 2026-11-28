# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network abstraction layer designed for High Availability use cases"
HOMEPAGE="https://kronosnet.org"
SRC_URI="https://kronosnet.org/releases/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
# NOTE: could use verify-sig but I do not know the signing key
IUSE="bzip2 doc nss +openssl lz4 lzo2 lzma test zlib zstd"
RESTRICT="!test? ( test )"

DEPEND="
	>=sys-cluster/libqb-2.0.0:=
	dev-libs/libnl:3
	bzip2? ( app-arch/bzip2:= )
	lzo2? ( dev-libs/lzo:2 )
	lz4? ( app-arch/lz4:= )
	nss? ( dev-libs/nss )
	openssl? ( dev-libs/openssl:= )
	lzma? ( app-arch/xz-utils:= )
	zlib? ( sys-libs/zlib:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-cluster/libqb-2.0.0
	doc? ( app-text/doxygen[dot] )
"

DOCS=( README ChangeLog )

PATCHES=(
	"${FILESDIR}"/${PN}-1.19-no-Werror.patch
)

src_prepare() {
	default

	# For our patches
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc man)
		$(use_enable test functional-tests)

		--disable-hardening
		--disable-libknet-sctp
		--enable-libnozzle

		$(use_enable nss crypto-nss)
		$(use_enable openssl crypto-openssl)

		$(use_enable bzip2 compress-bzip2)
		$(use_enable zstd compress-zstd)
		$(use_enable lz4 compress-lz4)
		$(use_enable lzma compress-lzma)
		$(use_enable lzo2 compress-lzo2)
		$(use_enable zlib compress-zlib)
	)

	econf "${myeconfargs[@]}"
}
