# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Replacement for the .NET runtime and class libraries in Wine"
HOMEPAGE="
	https://gitlab.winehq.org/wine/wine/-/wikis/Wine-Mono/
	https://gitlab.winehq.org/mono/wine-mono/
"
SRC_URI="
	shared? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.tar.xz )
	!shared? ( https://dl.winehq.org/wine/${PN}/${PV}/${P}-x86.msi )
"
S=${WORKDIR}

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT MPL-1.1"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+shared"

src_install() {
	insinto /usr/share/wine/mono

	if use shared; then
		doins -r ${P}
	else
		doins "${DISTDIR}"/${P}-x86.msi
	fi
}
