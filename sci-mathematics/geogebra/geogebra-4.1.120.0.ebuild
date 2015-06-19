# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/geogebra/geogebra-4.1.120.0.ebuild,v 1.1 2014/08/23 15:59:10 amynka Exp $

EAPI=5

inherit eutils

DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="http://www.geogebra.org/cms/en"
SRC_URI="https://geogebra.googlecode.com/files/GeoGebra-Unixlike-Installer-${PV}.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0 BSD public-domain GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jdk-1.6.0-r1
	${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-install.sh.patch"
}

src_install() {
	./install.sh || die
}
