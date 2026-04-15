# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/marcusmeissner.asc
inherit autotools verify-sig

DESCRIPTION="FUSE file system for interfacing with digital cameras using gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="
	https://github.com/gphoto/gphotofs/releases/download/v${PV}/${P}.tar.bz2
	verify-sig? ( https://github.com/gphoto/gphotofs/releases/download/v${PV}/${P}.tar.bz2.asc )
"

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
	sys-fs/fuse:3=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-marcusmeissner )
"

src_prepare() {
	default
	eautoreconf
}
