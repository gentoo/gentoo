# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic

MY_PV=${PV/_p*/}

DESCRIPTION="TCP daemon and set of libraries for usbredir protocol (redirecting USB traffic)"
HOMEPAGE="http://spice-space.org/page/UsbRedir"
SRC_URI="http://spice-space.org/download/${PN}/${PN}-${MY_PV}.tar.bz2
	https://dev.gentoo.org/~tamiko/distfiles/${P}-patches.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${S}_p20170503-patches"
)

DOCS="ChangeLog README* TODO *.txt"

src_configure() {
	# https://bugs.freedesktop.org/show_bug.cgi?id=54643
	append-cflags -Wno-error

	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	# noinst_PROGRAMS
	dobin usbredirtestclient/usbredirtestclient
}
