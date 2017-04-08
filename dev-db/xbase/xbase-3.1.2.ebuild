# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune

DESCRIPTION="xbase (i.e. dBase, FoxPro, etc.) compatible C++ class library"
HOMEPAGE="http://linux.techass.com/projects/xdb/"
SRC_URI="mirror://sourceforge/xdb/${PN}64-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~x86-fbsd"
IUSE="doc static-libs"

S="${WORKDIR}"/${PN}64-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-fixconfig.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${PN}-2.0.0-ppc.patch
	"${FILESDIR}"/${P}-xbnode.patch
	"${FILESDIR}"/${P}-lesserg.patch
	"${FILESDIR}"/${P}-outofsource.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc-version.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	# media-tv/linuxtv-dvb-apps collision, bug #208596
	mv "${ED}/usr/bin/zap" "${ED}/usr/bin/${PN}-zap" || die

	if use doc; then
		dohtml html/*
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
