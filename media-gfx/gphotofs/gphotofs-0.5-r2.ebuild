# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="FUSE file system for interfacing with digital cameras using gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="https://downloads.sourceforge.net/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/libgphoto2:=
	sys-fs/fuse:0="
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5-fix-build-clang16.patch
)
