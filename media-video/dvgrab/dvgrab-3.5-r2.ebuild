# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Digital Video (DV) grabber for GNU/Linux"
HOMEPAGE="https://github.com/ddennedy/dvgrab"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="jpeg quicktime"

RDEPEND=">=sys-libs/libraw1394-1.1
	>=media-libs/libdv-0.103
	>=media-libs/libiec61883-1
	>=sys-libs/libavc1394-0.5.1
	jpeg? ( media-libs/libjpeg-turbo:0= )
	quicktime? ( media-libs/libquicktime )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-3.5-gcc6.patch"
)

src_configure() {
	econf \
		$(use_with quicktime libquicktime) \
		$(use_with jpeg libjpeg)
}
