# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake desktop

MY_P=${P/_/-}

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="https://groups.io/g/js8call"
SRC_URI="https://github.com/${PN}-improved/${PN}-improved/archive/refs/tags/release/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/JS8Call-improved-release-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtserialport:6
	dev-libs/boost:=
	sci-libs/fftw:3.0=[threads,fortran]
	>=media-libs/hamlib-4:= "
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.1-no-pcr.patch
	)

src_install() {
	dobin "${S}_build"/JS8Call
	dodoc README.md
	insinto /usr/share/${PN}
	doins JS8_Include/cty.dat
	doins JS8_Include/eclipse.txt
	domenu JS8Call.desktop
	insinto /usr/share/pixmaps
	doins icons/Unix/js8call_icon.png
}
