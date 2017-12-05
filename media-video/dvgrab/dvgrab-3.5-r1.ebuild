# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Digital Video (DV) grabber for GNU/Linux"
HOMEPAGE="http://www.kinodv.org/"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="jpeg quicktime"

RDEPEND=">=sys-libs/libraw1394-1.1
	>=media-libs/libdv-0.103
	>=media-libs/libiec61883-1
	>=sys-libs/libavc1394-0.5.1
	jpeg? ( virtual/jpeg:0 )
	quicktime? ( media-libs/libquicktime )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-3.5-gcc6.patch"
)

src_configure() {
	econf \
		$(use_with quicktime libquicktime) \
		$(use_with jpeg libjpeg)
}
