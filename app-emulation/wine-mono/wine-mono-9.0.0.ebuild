# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Replacement for the .NET runtime and class libraries in Wine"
HOMEPAGE="https://wiki.winehq.org/Mono"
SRC_URI="
	shared? ( https://github.com/madewokherd/wine-mono/releases/download/${P}/${P}-x86.tar.xz )
	!shared? ( https://github.com/madewokherd/wine-mono/releases/download/${P}/${P}-x86.msi )"
S="${WORKDIR}"

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
