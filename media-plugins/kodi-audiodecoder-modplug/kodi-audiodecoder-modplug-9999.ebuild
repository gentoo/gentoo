# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Modplug decoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audiodecoder.modplug"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audiodecoder.modplug.git"
	inherit git-r3
	DEPEND="~media-tv/kodi-9999"
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/xbmc/audiodecoder.modplug/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audiodecoder.modplug-${PV}-${CODENAME}"
	DEPEND="=media-tv/kodi-19*"
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND+="
	>=media-libs/libmodplug-0.8.9.0
	"

RDEPEND="
	${DEPEND}
	"
