# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Libarchive VFS add-on for Kodi"
HOMEPAGE="https://github.com/xbmc/vfs.libarchive"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/vfs.libarchive.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/vfs.libarchive/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.libarchive-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	app-arch/libarchive[bzip2,lz4,lzma,lzo,zlib]
	app-arch/lzma
	app-arch/bzip2
	sys-libs/zlib
	app-arch/lz4
	dev-libs/lzo:2
	>=dev-libs/openssl-1.0.2l:0=
	~media-tv/kodi-9999
	"
RDEPEND="${DEPEND}"
