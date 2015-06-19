# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/orthorobot/orthorobot-0.ebuild,v 1.3 2013/09/14 10:04:32 ago Exp $

EAPI="5"

inherit eutils games

DESCRIPTION="Nice perspective based puzzle game, where you flatten the view to move across gaps"
HOMEPAGE="http://stabyourself.net/orthorobot/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}/${PN}-source.zip -> ${P}.zip"

LICENSE="CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=games-engines/love-0.8.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	default
	#it is only one .love file (but with crappy name), so we can use asterisk
	mv *.love "${P}.zip" || die 'mv failed'
	unpack "./${P}.zip"
	rm "${P}.zip" || die 'rm failed'
}

src_prepare() {
	# fix error on quit
	sed -i -e 's/love.event.push("q")/love.event.push(fadegoal)/' menu.lua || die 'sed failed'

	epatch_user
}

src_install() {
	local dir="${GAMES_DATADIR}/love/${PN}"
	insinto "${dir}"
	doins -r .
	games_make_wrapper "${PN}" "love ${dir}"
	make_desktop_entry "${PN}"
	prepgamesdirs
}

pkg_postinst() {
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
}
