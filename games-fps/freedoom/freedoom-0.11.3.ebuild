# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Free game content for the Doom engine"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/freedoom-${PV}.zip
	https://github.com/freedoom/freedoom/releases/download/v${PV}/freedm-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/doom-data/${PN}
	doins */*.wad
	dodoc "${P}"/CREDITS.txt "${P}"/README.html
}

pkg_postinst() {
	einfo "Please note that WAD files location is /usr/share/doom-data/${PN}"
}
