# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Perspective based puzzle game, where you flatten the view to move across gaps"
HOMEPAGE="https://stabyourself.net/orthorobot/"
SRC_URI="https://stabyourself.net/dl.php?file=${PN}/${PN}-source.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=games-engines/love-0.8.0:0"
BDEPEND="app-arch/unzip"

src_unpack() {
	default

	# It is only one .love file (but with crappy name), so we can use asterisk
	mv *.love "${P}.zip" || die "mv failed"
	unpack "./${P}.zip"

	rm "${P}.zip" || die "rm failed"
}

src_prepare() {
	default

	# Fix error on quit
	sed -i -e 's/love.event.push("q")/love.event.push(fadegoal)/' menu.lua || die "sed failed"
}

src_install() {
	local dir=/usr/share/love/${PN}
	insinto ${dir}

	doins -r .
	make_wrapper "${PN}" "love ${dir}"
	make_desktop_entry "${PN}"
}
