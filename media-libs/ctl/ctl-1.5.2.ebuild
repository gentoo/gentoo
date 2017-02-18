# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="https://github.com/ampas/CTL"
SRC_URI="${HOMEPAGE}/archive/ctl-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=media-libs/ilmbase-2.2.0:=
	 >=media-libs/openexr-2.2.0:=
	 media-libs/tiff:=
	 !!media-libs/openexr_ctl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/CTL-ctl-${PV}"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s|doc/CTL|share/doc/${PF}|" \
	    -i doc/CMakeLists.txt || die
}
