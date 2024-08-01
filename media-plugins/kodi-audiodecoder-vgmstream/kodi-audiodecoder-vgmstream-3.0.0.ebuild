# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="vgmstream decoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audiodecoder.vgmstream"


case ${PV} in
9999)
	
	EGIT_REPO_URI="https://github.com/xbmc/audiodecoder.vgmstream"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/audiodecoder.vgmstream/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audiodecoder.vgmstream-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"


DEPEND="
	=media-tv/kodi-19*
	"
RDEPEND="
	${DEPEND}
	"
