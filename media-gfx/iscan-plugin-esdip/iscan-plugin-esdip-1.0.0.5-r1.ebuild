# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV="$(ver_cut 1-3)"
MY_PVR="$(ver_rs 3 -)"

DESCRIPTION="Plugin for 'epkowa' backend for image manipulation"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=L"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.i386.rpm )"
S="${WORKDIR}"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND=">=media-gfx/iscan-2.28.0"
RDEPEND="${DEPEND}"

QA_PREBUILT="*"

src_configure() { :; }
src_compile() { :; }

src_install() {
	dodoc usr/share/doc/*/*

	exeinto /usr/$(get_libdir)/iscan
	doexe usr/$(get_libdir)/iscan/*

	insinto /usr/share/iscan
	doins usr/share/iscan/*
}
