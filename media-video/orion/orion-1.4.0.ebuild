# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils eutils

DESCRIPTION="Cross-platform Twitch client"
HOMEPAGE="https://alamminsalo.github.io/orion/"
SRC_URI="https://github.com/alamminsalo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mpv"

DEPEND="dev-qt/qtquickcontrols:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	mpv? ( media-video/mpv[libmpv] )
	!mpv? ( dev-qt/qtmultimedia:5 )"
RDEPEND="${DEPEND}
	!mpv? ( media-plugins/gst-plugins-hls )"

src_prepare() {
	sed -i \
		-e 's:^Icon=/usr/local/share/icons/orion.svg$:Icon=/usr/share/icons/hicolor/scalable/apps/orion.svg:' \
		-e 's:^Categories=Games$:Categories=Game;:' \
		distfiles/*.desktop
	eapply_user
}

src_configure() {
	# TODO: also supports qtav, not yet in portage
	local PLAYER
	if use mpv; then
		PLAYER=mpv
	else
		PLAYER=multimedia
	fi
	eqmake5 ${PN}.pro CONFIG+=${PLAYER}
}

src_install() {
	dobin ${PN}
	domenu distfiles/*.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins distfiles/${PN}.svg
}
