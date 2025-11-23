# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Fly a plane around and bomb/shoot the enemy (port of Planegame from Amiga)"
HOMEPAGE="https://github.com/moggers87/apricots"
SRC_URI="
	https://github.com/moggers87/apricots/releases/download/v${PV}/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test" # this is only static analysis / linter tests

RDEPEND="
	media-libs/alure
	media-libs/freealut
	media-libs/libsdl2[sound,video]
	media-libs/openal"
DEPEND="${RDEPEND}"

src_install() {
	default
	einstalldocs

	insinto /etc
	doins ${PN}/${PN}.cfg

	doicon -s 128 "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
