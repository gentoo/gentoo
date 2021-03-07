# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Perspective based puzzle game, where you flatten the view to move across gaps"
HOMEPAGE="https://stabyourself.net/orthorobot/"
SRC_URI="https://stabyourself.net/dl.php?file=${PN}/${PN}-source.zip -> ${P}.zip"

LICENSE="CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.8"
RDEPEND="games-engines/love:${LVSLOT}"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	default
	#it is only one .love file (but with crappy name), so we can use asterisk
	mv *.love "${P}.zip" || die 'mv failed'
	unpack "./${P}.zip"
	rm "${P}.zip" || die 'rm failed'
}

src_prepare() {
	default
	# fix error on quit
	sed -i -e 's/love.event.push("q")/love.event.push(fadegoal)/' menu.lua || die 'sed failed'
}

src_install() {
	local dir="/usr/share/love/${PN}"
	insinto "${dir}"
	doins -r .
	make_wrapper "${PN}" "love-${LVSLOT} ${dir}"
	make_desktop_entry "${PN}"
}
