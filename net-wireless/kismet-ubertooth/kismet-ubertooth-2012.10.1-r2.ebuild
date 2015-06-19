# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kismet-ubertooth/kismet-ubertooth-2012.10.1-r2.ebuild,v 1.1 2013/04/27 23:12:42 zerochaos Exp $

EAPI="5"

inherit multilib

MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
S="${WORKDIR}/ubertooth-${MY_PV}"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://ubertooth.git.sourceforge.net/gitroot/ubertooth/ubertooth"
	SRC_URI=""
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/ubertooth/ubertooth-${MY_PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Provides basic bluetooth support in kismet"
HOMEPAGE="http://ubertooth.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE=""

DEPEND=">=net-wireless/kismet-2011.03.2-r1:= \
	>=net-wireless/ubertooth-${PV}:= \
	>=net-libs/libbtbb-${PV}:= \
	virtual/libusb:1"
RDEPEND="${DEPEND}"

src_compile() {
	if has_version =net-wireless/kismet-9999; then
		cd "${S}/host/kismet/plugin-ubertooth-phyneutral" || die
	else
		cd "${S}/host/kismet/plugin-ubertooth" || die
	fi
	emake KIS_SRC_DIR="/usr/include/kismet/"
}

src_install() {
	if has_version =net-wireless/kismet-9999; then
		cd "${S}/host/kismet/plugin-ubertooth-phyneutral" || die
	else
		cd "${S}/host/kismet/plugin-ubertooth" || die
	fi
	emake DESTDIR="${ED}" LIBDIR="/$(get_libdir)" KIS_SRC_DIR="/usr/include/kismet/" install
}

pkg_postinst() {
	ewarn "This package must be rebuilt every time kismet is rebuilt. Or else."
}
