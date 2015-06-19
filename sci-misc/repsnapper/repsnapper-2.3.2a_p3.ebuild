# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/repsnapper/repsnapper-2.3.2a_p3.ebuild,v 1.1 2013/12/02 09:06:24 slis Exp $

EAPI=5

inherit autotools versionator

MY_PV="$(get_version_component_range 1-4)$(get_version_component_range 5)"
MY_PV=${MY_PV/p/}

DESCRIPTION="Host software for controlling the RepRap open source 3D printer"
HOMEPAGE="https://github.com/timschmidt/repsnapper"
SRC_URI="https://github.com/timschmidt/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-cpp/gtkglextmm-1.2
	dev-cpp/gtkmm:2.4
	dev-cpp/libxmlpp
	dev-libs/libzip
	virtual/opengl
"
RDEPEND=${DEPEND}

src_prepare() {
	eautoreconf
}
