# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/fcpci/fcpci-0.1-r3.ebuild,v 1.2 2014/06/27 06:38:56 pinkbyte Exp $

EAPI=5

inherit eutils linux-mod rpm

DESCRIPTION="AVM kernel modules for Fritz!Card PCI"
HOMEPAGE="http://opensuse.foehr-it.de/"
SRC_URI="http://opensuse.foehr-it.de/rpms/11_2/src/${P}-0.src.rpm -> ${P}-0.src-11_2.rpm"

LICENSE="AVM-FC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!net-dialup/fritzcapi"
RDEPEND="${DEPEND}
	net-dialup/capi4k-utils"

RESTRICT="mirror primaryuri"

S="${WORKDIR}/fritz"

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is le 3 0 ; then
		die "This package works only with 3.x kernels!"
	fi

	BUILD_TARGETS="all"
	BUILD_PARAMS="KDIR=${KV_DIR} LIBDIR=${S}/src V=1"
	MODULE_NAMES="${PN}(net:${S}/src)"
}

src_unpack() {
	local BIT=""
	use amd64 && BIT="64bit-"
	rpm_unpack ${A}
	DISTDIR="${WORKDIR}" unpack ${PN}-suse[0-9][0-9]-${BIT}[0-9].[0-9]*-[0-9]*.tar.gz
}

src_prepare() {
	local PAT="012345"
	use amd64 && PAT="1234"
	PAT="${PAT}67"

	epatch $(sed -n "s|^Patch[${PAT}]:\s*\(.*\)|../\1|p" "${WORKDIR}/${PN}.spec")

	epatch "${FILESDIR}"/fcpci-kernel-2.6.34.patch

	if use amd64; then
		epatch "${FILESDIR}"/fcpci-kernel-2.6.39-amd64.patch
	else
		epatch "${FILESDIR}"/fcpci-kernel-2.6.39.patch
	fi

	if kernel_is ge 3 2 0 ; then
		epatch "${FILESDIR}"/fcpci-kernel-3.2.0.patch
	fi
	if kernel_is ge 3 4 0 ; then
		epatch "${FILESDIR}"/fcpci-kernel-3.4.0.patch
	fi
	if kernel_is ge 3 8 0 ; then
		epatch "${FILESDIR}"/fcpci-kernel-3.8.0.patch
	fi
	if kernel_is ge 3 10 0 ; then
		epatch "${FILESDIR}"/fcpci-kernel-3.10.0.patch
	fi

	epatch_user

	convert_to_m src/Makefile

	for i in lib/*-lib.o; do
		einfo "Localize symbols in ${i##*/} ..."
		objcopy -L memcmp -L memcpy -L memmove -L memset -L strcat \
			-L strcmp -L strcpy -L strlen -L strncmp -L strncpy "${i}"
	done
}

src_install() {
	linux-mod_src_install
	dodoc CAPI*.txt
	dohtml *.html
}
