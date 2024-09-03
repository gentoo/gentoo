# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="dockapp that monitors your apm battery status"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
