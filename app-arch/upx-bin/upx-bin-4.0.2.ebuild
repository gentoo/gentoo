# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils

MY_P="${PN/-bin}-${PV}"

DESCRIPTION="Ultimate Packer for eXecutables, binary version with proprietary NRV compression"
HOMEPAGE="https://upx.github.io/"
SRC_URI="x86? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-i386_linux.tar.xz )
	amd64? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-amd64_linux.tar.xz )
	arm64? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-arm64_linux.tar.xz )
	arm? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-armeb_linux.tar.xz )
	mips? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-mipsel_linux.tar.xz )
	ppc? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-powerpc_linux.tar.xz )
	ppc64? ( https://github.com/upx/upx/releases/download/v${PV}/${MY_P}-powerpc64le_linux.tar.xz )"

LICENSE="GPL-2+ UPX-exception"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 x86"
RESTRICT="strip"

RDEPEND="!app-arch/upx"
BDEPEND="app-arch/xz-utils[extra-filters]"

S="${WORKDIR}"

QA_PREBUILT="/opt/bin/upx"

src_install() {
	cd ${MY_P}* || die
	into /opt
	dobin upx
	pax-mark -m "${ED}"/opt/bin/upx
	doman upx.1
	dodoc NEWS README THANKS upx-doc.html upx-doc.txt
}
