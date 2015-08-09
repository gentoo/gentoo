# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Very small xine frontend for playing audio events"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=39596"
SRC_URI="http://www.kde-apps.org/content/files/39596-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/xine-lib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -f "${S}/${PN}"
}

doecho() {
	echo "$@"
	"$@"
}

src_compile() {
	doecho $(tc-getCC) -o ${PN} \
		${CFLAGS} $(pkg-config --cflags libxine) ${LDFLAGS} \
		${PN}.c -lm $(pkg-config --libs libxine) \
		|| die "build failed"
}

src_install() {
	dobin ${PN}
	dodoc AUTHORS INSTALL
}
