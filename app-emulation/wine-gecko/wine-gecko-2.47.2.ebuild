# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Mozilla Gecko based version of Internet Explorer for Wine"
HOMEPAGE="
	https://wiki.winehq.org/Gecko
	https://gitlab.winehq.org/wine/wine-gecko/"
SRC_URI="
	shared? (
		abi_x86_32? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.tar.xz )
		abi_x86_64? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86_64.tar.xz )
	)
	!shared? (
		abi_x86_32? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.msi )
		abi_x86_64? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86_64.msi )
	)"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="${PV}"
KEYWORDS="amd64 x86"
IUSE="+abi_x86_32 abi_x86_64 +shared"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"

src_install() {
	insinto /usr/share/wine/gecko

	if use shared; then
		use abi_x86_32 && doins -r ${P}-x86
		use abi_x86_64 && doins -r ${P}-x86_64
	else
		use abi_x86_32 && doins "${DISTDIR}"/${P}-x86.msi
		use abi_x86_64 && doins "${DISTDIR}"/${P}-x86_64.msi
	fi
}
