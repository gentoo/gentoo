# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="a dockapp that lets you easily track time spent on different projects"
HOMEPAGE="https://www.dockapps.net/wmwork"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/libXext-1.0.3
	>=x11-libs/libX11-1.1.1-r1
	>=x11-libs/libXpm-3.5.6"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${P}/src

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ../{CHANGES,README}
}
