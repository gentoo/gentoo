# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic gnome2-utils cmake-utils

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="https://symless.com/synergy https://github.com/symless/synergy-core"
SRC_URI="
	https://github.com/symless/${PN}-core/archive/v${PV}-stable.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="libressl"

S=${WORKDIR}/${PN}-core-${PV}-stable

COMMON_DEPEND="
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="
	${COMMON_DEPEND}
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	append-cxxflags ${mycmakeargs}
	local mycmakeargs=(  -DSYNERGY_REVISION=0bd448d5 )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin ../${P}_build/bin/${PN}{c,s} ../${P}_build/bin/synergy-core

	insinto /etc
	newins doc/synergy.conf.example synergy.conf

	newman doc/${PN}c.man ${PN}c.1
	newman doc/${PN}s.man ${PN}s.1

	dodoc doc/synergy.conf.example* ChangeLog
}
