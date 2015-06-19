# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/opencpn-plugin-climatology/opencpn-plugin-climatology-1.0.ebuild,v 1.2 2015/04/30 16:42:13 mschiff Exp $

EAPI=5

WX_GTK_VER="2.8"
inherit cmake-utils wxwidgets

MY_PN="climatology_pi"

DESCRIPTION="Climatology Plugin for OpenCPN (includes CL-DATA)"
HOMEPAGE="http://opencpn.org/ocpn/downloadplugins"
SRC_URI="
	https://github.com/seandepagnier/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://sourceforge/opencpnplugins/climatology_pi/CL-DATA-1.0.tar.xz -> ${P}-CL-DATA.tar.xz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sci-geosciences/opencpn-4.0.0
	sys-devel/gettext
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	cmake-utils_src_install
	insinto "/usr/share/opencpn/plugins/${MY_PN}/data/"
	doins "${S}"/{,../}data/*
}
