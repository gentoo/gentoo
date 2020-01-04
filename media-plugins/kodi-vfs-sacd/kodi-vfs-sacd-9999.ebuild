# Copyright 1999-2019 Gentoo Authors
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
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/vfs.sacd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.sacd-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=dev-libs/libplatform-2*
	~media-libs/kodi-platform-9999
	~media-tv/kodi-9999
	"
