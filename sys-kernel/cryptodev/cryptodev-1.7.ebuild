# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit linux-info linux-mod

DESCRIPTION="device that allows access to Linux kernel cryptographic drivers"
HOMEPAGE="http://cryptodev-linux.org/index.html"
SRC_URI="http://download.gna.org/cryptodev-linux/${PN}-linux-${PV}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

DEPEND="virtual/linux-sources"
RDEPEND=""
#test do not compile
RESTRICT="test"
S=${WORKDIR}/${PN}-linux-${PV}

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

src_prepare() {
	# get_unused_fd was removed in 3.19
	sed -i 's,get_unused_fd(),get_unused_fd_flags(0),' ioctl.c || die
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
