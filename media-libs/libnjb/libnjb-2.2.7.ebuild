# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool udev

DESCRIPTION="Library for communicating with the Creative Nomad JukeBox digital audio player"
HOMEPAGE="http://libnjb.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${P}-exclude-samples.patch )

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	udev_newrules "${FILESDIR}"/${PN}.rules 80-${PN}.rules

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
