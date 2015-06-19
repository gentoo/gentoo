# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/iscan-plugin-esdip/iscan-plugin-esdip-1.0.0.5-r1.ebuild,v 1.2 2014/08/10 21:14:27 slyfox Exp $

EAPI=4

inherit rpm versionator multilib

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"

DESCRIPTION="Plugin for 'epkowa' backend for image manipulation"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=L"
SRC_URI="amd64? ( http://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.x86_64.rpm )
	x86? ( http://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.ltdl7.i386.rpm )"

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
