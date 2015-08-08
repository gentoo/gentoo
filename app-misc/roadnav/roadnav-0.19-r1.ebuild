# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER=2.8

inherit eutils wxwidgets

DESCRIPTION="Roadnav is a street map application with routing and GPS support"
HOMEPAGE="http://roadnav.sourceforge.net"
SRC_URI="mirror://sourceforge/roadnav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps festival openstreetmap scripting" #flite, see bug #516426

DEPEND="
	x11-libs/wxGTK:2.8[X]
	~dev-libs/libroadnav-${PV}
	festival? ( app-accessibility/festival )
	gps? ( sci-geosciences/gpsd )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc45.patch
}

src_configure() {
	econf \
		$(use_enable festival) \
		$(use_enable gps gpsd) \
		$(use_enable openstreetmap) \
		$(use_enable scripting) \
		--disable-flite \
		--with-wx-config=${WX_CONFIG}
}

src_install() {
	default

	# generic or empty
	for f in NEWS COPYING INSTALL; do
		rm -f "${D}"/usr/share/doc/${PN}/${f}
	done

	# --docdir is broken and hardcoded to ${PN}
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${P}

	domenu "${S}"/roadnav.desktop
}

pkg_postinst() {
	echo
	elog "After upgrading to ${P} you will need to recompile your maps."
	echo
}
