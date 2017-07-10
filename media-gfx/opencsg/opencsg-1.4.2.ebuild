# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

RDEPEND="media-libs/glew:0="
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
"

S="${WORKDIR}/${MY_P}/src"

PATCHES=(
	"${FILESDIR}/${P}-includepath.patch"
)

src_prepare() {
	default

	# removes duplicated headers
	rm -r ../glew || die "failed to remove bundled glew"
}

src_configure() {
	eqmake5 src.pro INSTALLDIR="/usr" LIBDIR="$(get_libdir)"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
