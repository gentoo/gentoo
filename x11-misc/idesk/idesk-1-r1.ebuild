# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

inherit autotools

DESCRIPTION="Utility to place icons on the root window"
HOMEPAGE="https://github.com/antonialoytorrens/idesk/"
SRC_URI="https://github.com/antonialoytorrens/idesk/releases/download/v1/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	dev-libs/glib
	dev-libs/libxml2
	media-libs/freetype
	media-libs/imlib2[X]
	media-libs/libart_lgpl
	x11-libs/libXft
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/startup-notification
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1-use-pkg-config-imlib2.patch
)

src_prepare() {
	default

	sed -i -e 's,/usr/local/,/usr/,' examples/default.lnk || die

	eautoreconf
}

src_configure() {
	econf --enable-libsn
}
