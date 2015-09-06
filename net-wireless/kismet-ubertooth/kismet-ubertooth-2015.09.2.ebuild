# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/ubertooth.git"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV=${PV/\./-}
	MY_PV=${MY_PV/./-R}
	S="${WORKDIR}/ubertooth-${MY_PV}"
	SRC_URI="https://github.com/greatscottgadgets/ubertooth/releases/download/${MY_PV}/ubertooth-${MY_PV}.tar.xz"
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
