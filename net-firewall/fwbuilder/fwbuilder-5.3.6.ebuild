# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit qmake-utils autotools

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="https://github.com/UNINETT/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	dev-libs/elfutils
	>=dev-qt/qtgui-5.5.1-r1"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	sed -i -e '/dnl.*AM_INIT_AUTOMAKE/d' configure.in || die #398743
	mv configure.in configure.ac || die #426262
	eautoreconf
}

src_configure() {
	eqmake5
	# portage handles ccache/distcc itself
	econf --without-{ccache,distcc}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	validate_desktop_entries

	elog "You need to emerge sys-apps/iproute2"
	elog "in order to run the firewall script."
}
