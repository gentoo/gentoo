# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit rpm versionator multilib

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"

DESCRIPTION="Plugin for 'epkowa' backend for image manipulation"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=L"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.i386.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE=""

DEPEND=">=media-gfx/iscan-2.28.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="/usr/lib64/iscan/libesdtr.so.0*
	/usr/lib64/iscan/libesdtr2.so.0*"

src_configure() { :; }
src_compile() { :; }

src_install() {
	dodoc usr/share/doc/*/*

	exeinto /usr/$(get_libdir)/iscan
	doexe usr/$(get_libdir)/iscan/*

	insinto /usr/share/iscan
	doins usr/share/iscan/*
}
