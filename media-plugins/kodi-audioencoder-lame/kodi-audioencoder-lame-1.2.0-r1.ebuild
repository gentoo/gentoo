# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Lame MP3 encoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audioencoder.lame"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audioencoder.lame.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/audioencoder.lame/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audioencoder.lame-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-17*
	media-sound/lame
	"

RDEPEND="
	${DEPEND}
	"
