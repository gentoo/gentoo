# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Flac encoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audioencoder.flac"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audioencoder.flac.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/audioencoder.flac/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audioencoder.flac-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	media-libs/libogg
	media-libs/flac
	"
RDEPEND="
	${DEPEND}
	"
