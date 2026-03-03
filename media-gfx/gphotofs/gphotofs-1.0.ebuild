# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="FUSE file system for interfacing with digital cameras using gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="https://github.com/gphoto/gphotofs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/"${P}"-fuse-prototype.patch
	"${FILESDIR}"/"${P}"-largefile.patch
)

RDEPEND="
	dev-libs/glib:2
	media-libs/libgphoto2:=
	sys-fs/fuse:3="
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
