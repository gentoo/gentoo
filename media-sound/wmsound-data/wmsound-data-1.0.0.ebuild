# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

IUSE=""

DESCRIPTION="A bunch of sounds for WindowMaker Sound Server"
SRC_URI="http://largo.windowmaker.org/files/worms2sounds.tar.gz
		http://largo.windowmaker.org/files/wmsdefault.tar.gz"
HOMEPAGE="http://largo.windowmaker.org/"

DEPEND=">=x11-wm/windowmaker-0.80.2-r2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"

S1=${WORKDIR}/Sounds
S2=${WORKDIR}/SoundSets

src_install() {
	insinto /usr/share/WindowMaker/Defaults
	doins "${FILESDIR}"/WMSound

	insinto /etc/X11/WindowMaker
	doins "${FILESDIR}"/WMSound

	insinto /usr/share/WindowMaker/SoundSets
	doins "${FILESDIR}"/wmsound-soundset

	insinto /usr/share/WindowMaker/SoundSets/Default
	doins "${FILESDIR}"/wmsound-soundset

	cd "${S1}"
	insinto /usr/share/WindowMaker/Sounds
	doins *.wav

	cd "${S2}"
	insinto /usr/share/WindowMaker/SoundSets
	doins Worms2
}
