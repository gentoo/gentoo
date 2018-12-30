# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info udev

DESCRIPTION="TCG Trusted Platform Module 2.0 Software Stack"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tss"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"	# sublot is libtss2-sys number
KEYWORDS="~amd64"
IUSE="doc +gcrypt libressl openssl static-libs test"

REQUIRED_USE="
	gcrypt? ( !openssl )
	openssl? ( !gcrypt )
	|| ( gcrypt openssl )"

RDEPEND="gcrypt? ( dev-libs/libgcrypt:0= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${DEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-tests.patch"
)

pkg_setup() {
	local CONFIG_CHECK=" \
		~TCG_TPM
	"
	linux-info_pkg_setup
	kernel_is ge 4 12 0 || ewarn "At least kernel 4.12.0 is required"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# next version add --disable-defaultflags
	econf \
		$(use_enable doc doxygen-doc) \
		$(use_enable static-libs static) \
		$(use_enable test unit) \
		--with-crypto="$(usex gcrypt gcrypt ossl)" \
		--with-udevrulesdir="$(get_udevdir)/rules.d" \
		--with-udevrulesprefix=60-
}
