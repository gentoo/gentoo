# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_P="u-boot-${PV/_/-}"
DESCRIPTION="utilities for working with Das U-Boot"
HOMEPAGE="http://www.denx.de/wiki/U-Boot/WebHome"
SRC_URI="ftp://ftp.denx.de/pub/u-boot/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	# Unset a few KBUILD variables. Bug #540476
	unset KBUILD_OUTPUT KBUILD_SRC
	emake defconfig
	emake \
		HOSTSTRIP=: \
		STRIP=: \
		HOSTCC="$(tc-getCC)" \
		HOSTCFLAGS="${CFLAGS} ${CPPFLAGS}"' $(HOSTCPPFLAGS)' \
		HOSTLDFLAGS="${LDFLAGS}" \
		CONFIG_ENV_OVERWRITE=y \
		tools-all
}

src_install() {
	cd tools || die
	dobin bmp_logo dumpimage fdtgrep gen_eth_addr img2srec mkenvimage mkimage
	dobin easylogo/easylogo
	dobin env/fw_printenv
	dosym fw_printenv /usr/bin/fw_setenv
	insinto /etc
	doins env/fw_env.config
	doman "${S}"/doc/mkimage.1
}
