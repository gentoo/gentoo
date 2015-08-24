# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools versionator

MY_PV=$(replace_version_separator 3 '-' )
MY_P="${PN/vm/VM}-source-${MY_PV}"

DESCRIPTION="Open Source VMware View Client"
HOMEPAGE="https://code.google.com/p/vmware-view-open-client/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/boost-1.34.1
	>=dev-libs/icu-3.8.0:=
	>=dev-libs/libxml2-2.6.0
	>=dev-libs/openssl-0.9.8
	>=net-misc/curl-7.16.0[ssl]
	x11-libs/gtk+:2
"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.21
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	>=net-misc/rdesktop-1.4.1
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-linking.patch" \
		"${FILESDIR}"/${P}-curl-headers.patch \
		"${FILESDIR}"/${P}-unbundle-intltool.patch
	sed -e "s:e.x.p:$(get_version_component_range 1-3):" \
		-e "s:00000:$(get_version_component_range 4):" \
		-i configure.ac

	AT_M4DIR="${AT_M4DIR} -I ${ROOT}/usr/share/aclocal" eautoreconf
}

src_configure() {
	econf \
		--disable-static-icu \
		--enable-nls \
		--with-boost
}
