# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="WindowMaker CPU and Memory Usage Monitor Dock App"
HOMEPAGE="http://www.geocities.ws/neofpo/wmcms.html"
SRC_URI="http://www.geocities.ws/neofpo/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=x11-libs/libdockapp-0.7:="

src_prepare() {
	epatch "${FILESDIR}"/wmcms-0.3.5-s4t4n.patch

	# Respect LDFLAGS, see bug #335031
	sed -e 's/ -o wmcms/ ${LDFLAGS} -o wmcms/' -i Makefile || die

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin wmcms
}
