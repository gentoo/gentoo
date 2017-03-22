# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info linux-mod

DESCRIPTION="device that allows access to Linux kernel cryptographic drivers"
HOMEPAGE="http://cryptodev-linux.org/index.html"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/cryptodev-linux/cryptodev-linux.git"
	S="${WORKDIR}/${PN}-${PV}"
else
	SRC_URI="http://download.gna.org/cryptodev-linux/${PN}-linux-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}/${PN}-linux-${PV}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="examples"

DEPEND="virtual/linux-sources"
RDEPEND=""
#test now compile, but need the module to run
RESTRICT="test"

MODULE_NAMES="cryptodev(extra:${S})"

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK="~CRYPTO ~CRYPTO_BLKCIPHER ~CRYPTO_AEAD"
		check_extra_config
	fi
}

pkg_setup() {
	if use kernel_linux ; then
		linux-mod_pkg_setup
	else
		die "cryptodev ebuild only support linux"
	fi
	BUILD_TARGETS="build"
	export KERNEL_DIR
}

src_install() {
	linux-mod_src_install
	if use examples ; then
		docinto examples
		dodoc example/*
	fi
	insinto /usr/include/crypto
	doins crypto/cryptodev.h
}
