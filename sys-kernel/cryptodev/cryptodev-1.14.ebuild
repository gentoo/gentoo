# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod-r1

DESCRIPTION="device that allows access to Linux kernel cryptographic drivers"
HOMEPAGE="http://cryptodev-linux.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryptodev-linux/cryptodev-linux.git"
else
	SRC_URI="https://github.com/cryptodev-linux/cryptodev-linux/archive/${PN}-linux-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}/${PN}-linux-${PN}-linux-${PV}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="examples"

DEPEND="virtual/linux-sources"

#test requires that the module is already loaded
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-linux-6.18.patch
)

pkg_pretend() {
	use kernel_linux || die "cryptodev ebuild only support linux"

	CONFIG_CHECK="~CRYPTO ~CRYPTO_AEAD"
	if kernel_is -lt 4 8 0; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_BLKCIPHER"
	else
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_SKCIPHER"
	fi
	check_extra_config
}

src_compile() {
	local modlist=( cryptodev="extra:${S}" )
	local modargs=( KERNEL_DIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /usr/include/crypto
	doins crypto/cryptodev.h

	if use examples ; then
		docinto examples
		dodoc example/*
	fi
}
