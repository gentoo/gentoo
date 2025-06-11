# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SFTP VFS addon for Kodi"
HOMEPAGE="https://github.com/xbmc/vfs.sftp"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/vfs.sftp.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/vfs.sftp/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.sftp-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-${PV%%.*}*
	net-libs/libssh:=[sftp]
"
RDEPEND="${DEPEND}"

src_prepare() {
	if [[ -d depends ]]; then
		rm -r depends || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
