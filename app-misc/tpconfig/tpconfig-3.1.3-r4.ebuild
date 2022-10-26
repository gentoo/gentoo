# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools toolchain-funcs

DESCRIPTION="Touchpad config for ALPS and Synaptics TPs. Controls tap/click behaviour"
HOMEPAGE="http://www.compass.com/synaptics/"
SRC_URI="http://www.compass.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-fix-automake-unrecognized-option.patch
	"${FILESDIR}"/${P}-fix-clang16-build.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake
}

src_install() {
	einstalldocs
	dobin "${PN}"
	newinitd "${FILESDIR}"/"${PN}-r1" "${PN}"
	newconfd "${FILESDIR}"/"${PN}.conf" "${PN}"
}
