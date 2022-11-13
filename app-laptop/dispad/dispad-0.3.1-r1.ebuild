# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Daemon to disable trackpads while typing"
HOMEPAGE="https://github.com/BlueDragonX/dispad"
SRC_URI="https://github.com/BlueDragonX/dispad/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"
S="${WORKDIR}/BlueDragonX-dispad-dbb9be3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/confuse
	x11-libs/libX11
	x11-libs/libXi"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf -i
}
