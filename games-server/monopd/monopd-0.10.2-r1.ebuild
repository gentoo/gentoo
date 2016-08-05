# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils systemd

DESCRIPTION="server for atlantik games"
HOMEPAGE="http://gtkatlantic.gradator.net/"
SRC_URI="http://download.tuxfamily.org/gtkatlantic/monopd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	>=dev-cpp/muParser-2
	dev-libs/utfcpp"

src_prepare() {
	default

	sed "s:GENTOO_DIR:\"/usr/bin\":" \
		"${FILESDIR}"/monopd.in > "${T}"/monopd || die
	sed -i \
		-e "s:/usr/sbin:/usr/bin:" \
		doc/systemd/monopd.service || die
	sed -i \
		-e '/C_SUBST(CXXFLAGS/s/CFLAGS/CXXFLAGS/' \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_with systemd systemd-daemon)
}

src_install() {
	default
	doinitd "${T}"/monopd
	systemd_dounit doc/systemd/monopd.s*
}
