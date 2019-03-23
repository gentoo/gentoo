# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="RAR VFS addon for Kodi"
HOMEPAGE="https://github.com/xbmc/vfs.rar"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/vfs.rar.git"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/vfs.rar/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.rar-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=dev-libs/libplatform-2*
	=media-libs/kodi-platform-18*
	=media-tv/kodi-18*
	"

pkg_postinst() {
	elog "${PN} competes with media-plugins/kodi-vfs-libarchive."
	elog "Both plugins register the RAR extension resulting in Kodi not"
	elog "recognizing RAR at all. So be aware to activate only one of them."
}
