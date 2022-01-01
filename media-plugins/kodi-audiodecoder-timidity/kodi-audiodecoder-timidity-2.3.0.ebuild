# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Timidity decoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audiodecoder.timidity"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audiodecoder.timidity.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/audiodecoder.timidity/archive/${PV}-${CODENAME}.tar.gz -> ${P}-${CODENAME}.tar.gz"
	S="${WORKDIR}/audiodecoder.timidity-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-19*
	"
RDEPEND="
	${DEPEND}
	"

src_configure() {
	append-cflags -fcommon # https://github.com/xbmc/audiodecoder.timidity/issues/32
	kodi-addon_src_configure
}
