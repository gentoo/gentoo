# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.gns3.net/dynamips/"
SRC_URI="mirror://sourceforge/project/gns-3/Dynamips/${PV}/${P}-source.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/elfutils
	net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"

	# enable verbose build
	sed -i \
		-e 's/@$(CC)/$(CC)/g' \
		stable/Makefile || die 'sed on stable/Makefile failed'
	# respect compiler
	tc-export CC

	epatch_user
}

src_compile() {
	if use amd64 || use x86; then
		emake DYNAMIPS_ARCH="${ARCH}"
	else
		emake DYNAMIS_ARCH="nojit"
	fi
}

src_install () {
	newbin dynamips.stable dynamips
	newbin nvram_export.stable nvram_export
	doman man/*
	dodoc README README.hypervisor TODO
}
