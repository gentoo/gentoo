# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Libarchive VFS add-on for Kodi"
HOMEPAGE="https://github.com/notspiff/vfs.libarchive"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/vfs.libarchive.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/notspiff/vfs.libarchive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/vfs.libarchive-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE="libressl"

DEPEND="
	app-arch/libarchive[bzip2,lz4,lzma,lzo,zlib]
	app-arch/lzma
	app-arch/bzip2
	sys-libs/zlib
	app-arch/lz4
	dev-libs/lzo:2
	!libressl? ( >=dev-libs/openssl-1.0.2l:0= )
	libressl? (
		dev-libs/libressl:0=
		app-arch/libarchive[libressl]
	)
	=media-tv/kodi-9999
	"
