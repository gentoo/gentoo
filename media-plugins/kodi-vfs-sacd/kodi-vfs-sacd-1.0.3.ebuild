# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="SACD VFS addon for Kodi"
HOMEPAGE="https://github.com/xbmc/vfs.sacd"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/vfs.sacd.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/vfs.sacd/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.sacd-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-libs/kodi-platform-18*
	=media-tv/kodi-18*
	virtual/libiconv
	"
RDEPEND="${DEPEND}"
