# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop qmake-utils xdg

DESCRIPTION="Cross-platform Twitch client"
HOMEPAGE="https://alamminsalo.github.io/orion/"
SRC_URI="https://github.com/alamminsalo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mpv qtav qtmedia"

DEPEND=">=dev-qt/qtquickcontrols-5.8:5
	>=dev-qt/qtquickcontrols2-5.8:5
	>=dev-qt/qtsvg-5.8:5
	>=dev-qt/qtwebengine-5.8:5
	mpv? ( media-video/mpv[libmpv] )
	qtav? ( media-libs/qtav )
	qtmedia? ( >=dev-qt/qtmultimedia-5.8:5 )"
RDEPEND="${DEPEND}
	!mpv? ( media-plugins/gst-plugins-hls )"

REQUIRED_USE="^^ ( mpv qtav qtmedia )"

PATCHES=(
	"${FILESDIR}"/${P}-fix_login.patch
	"${FILESDIR}"/${P}-mpv_compilation.patch
	"${FILESDIR}"/${P}-mpv_backwards.patch
)

src_configure() {
	local PLAYER
	if use mpv; then
		PLAYER=mpv
	elif use qtav; then
		PLAYER=qtav
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
