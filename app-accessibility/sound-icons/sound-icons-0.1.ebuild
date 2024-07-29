# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Collection of Sound Icons for speech-dispatcher"
HOMEPAGE="https://www.freebsoft.org"
SRC_URI="https://www.freebsoft.org/pub/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-accessibility/speech-dispatcher"

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	dodoc README
	insinto /usr/share/sounds/sound-icons
	doins "${S}"/*.wav
	local links=$(find "${S}" -type l -print)
	for link in ${links}; do
		target=$(readlink -n "${link}")
		dosym "${target}" /usr/share/sounds/sound-icons/$(basename "${link}")
	done
}
