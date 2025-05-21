# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Libarchive VFS add-on for Kodi"
HOMEPAGE="https://github.com/xbmc/vfs.libarchive"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/vfs.libarchive.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/vfs.libarchive/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.libarchive-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	app-arch/bzip2
	app-arch/libarchive:=[bzip2,lz4,lzma,lzo,zlib(+)]
	app-arch/lz4:=
	app-arch/lzma
	dev-libs/lzo:2
	>=dev-libs/openssl-1.0.2l:0=
	=media-tv/kodi-${PV%%.*}*
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
