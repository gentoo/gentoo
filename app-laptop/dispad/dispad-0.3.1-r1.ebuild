# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Daemon to disable trackpads while typing"
HOMEPAGE="https://github.com/BlueDragonX/dispad"
SRC_URI="https://github.com/BlueDragonX/dispad/tarball/v${PV/_/-} -> ${P}.tar.gz"

S="${WORKDIR}/BlueDragonX-dispad-dbb9be3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/confuse
	x11-libs/libX11
	x11-libs/libXi"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf -i
}
