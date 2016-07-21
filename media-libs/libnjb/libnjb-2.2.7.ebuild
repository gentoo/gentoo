# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool multilib udev

DESCRIPTION="a C library and API for communicating with the Creative Nomad JukeBox digital audio player"
HOMEPAGE="http://libnjb.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS="AUTHORS ChangeLog* FAQ HACKING README"

src_prepare() {
	sed -i \
		-e 's:SUBDIRS = src sample doc:SUBDIRS = src doc:' \
		Makefile.in || die

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

	find "${ED}" -name '*.la' -exec rm -f {} +
}
