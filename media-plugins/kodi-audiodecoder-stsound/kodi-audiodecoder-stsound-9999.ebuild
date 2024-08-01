# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="SPC decoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audiodecoder.stsound"


case ${PV} in
9999)
	
	EGIT_REPO_URI="https://github.com/xbmc/audiodecoder.stsound.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/audiodecoder.stsound/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audiodecoder.stsound-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"


DEPEND="
	~media-tv/kodi-9999
	"
RDEPEND="
	${DEPEND}
	"
