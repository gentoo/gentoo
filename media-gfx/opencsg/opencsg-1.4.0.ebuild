# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

MY_P="OpenCSG-${PV}"
DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="http://www.opencsg.org"
SRC_URI="http://www.opencsg.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="media-libs/glew:0 dev-qt/qtcore:4"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	default

	# removes duplicated headers
	rm -r ../glew || die "failed to remove bundled glew"

	sed -i -e 's:^INSTALLDIR.*:INSTALLDIR = /usr:' src.pro \
		|| die 'failed to fix INSTALLDIR in src.pro'

	sed -i -e "s:^target.path.*:target.path = \$\$INSTALLDIR/$(get_libdir):" \
		src.pro \
		|| die 'failed to fix target.path in src.pro'
}

src_configure() {
	eqmake4 src.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
