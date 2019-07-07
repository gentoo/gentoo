# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Makes the color of your computer's display adapt to the time of the day"
HOMEPAGE="https://justgetflux.com/"
SRC_URI="
	amd64? ( https://justgetflux.com/linux/${PN}64.tgz -> ${PN}64-${PV}.tar.gz )
	x86? ( https://justgetflux.com/linux/${PN}-pre.tgz -> ${P}.tar.gz )
"

KEYWORDS="-* amd64 x86"
LICENSE="f.lux"
SLOT="0"

RESTRICT="bindist mirror"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXxf86vm
"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/xflux"

src_install() {
	dobin xflux
}
