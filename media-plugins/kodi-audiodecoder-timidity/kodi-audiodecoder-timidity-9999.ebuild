# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Timidity decoder addon for Kodi"
HOMEPAGE="https://github.com/notspiff/audiodecoder.timidity"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/audiodecoder.timidity.git"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/notspiff/audiodecoder.timidity/archive/${PV}-${CODENAME}.tar.gz -> ${P}-${CODENAME}.tar.gz"
	S="${WORKDIR}/audiodecoder.timidity-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	"
RDEPEND="
	${DEPEND}
	"
