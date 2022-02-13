# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wine Mono is a replacement for the .NET runtime and class libraries in Wine"
HOMEPAGE="https://www.winehq.org/"
SRC_URI="
	!shared? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.msi )
	shared? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.tar.xz )
"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT MPL-1.1"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+shared"

DEPEND="!!app-emulation/wine:0"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/wine/mono
	if use shared; then
		doins -r "${P}"
	else
		doins "${DISTDIR}/${P}-x86.msi"
	fi
}
