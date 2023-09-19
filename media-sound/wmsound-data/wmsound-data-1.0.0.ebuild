# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A bunch of sounds for WindowMaker Sound Server"
HOMEPAGE="http://largo.windowmaker.org/"
SRC_URI="
	http://largo.windowmaker.org/files/worms2sounds.tar.gz
	http://largo.windowmaker.org/files/wmsdefault.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND=">=x11-wm/windowmaker-0.80.2-r2"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/WindowMaker/Defaults
	doins "${FILESDIR}"/WMSound

	insinto /etc/X11/WindowMaker
	doins "${FILESDIR}"/WMSound

	insinto /usr/share/WindowMaker/SoundSets
	doins "${FILESDIR}"/wmsound-soundset

	insinto /usr/share/WindowMaker/SoundSets/Default
	doins "${FILESDIR}"/wmsound-soundset

	insinto /usr/share/WindowMaker/Sounds
	doins Sounds/*.wav

	insinto /usr/share/WindowMaker/SoundSets
	doins SoundSets/Worms2
}
