# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Very small xine frontend for playing audio events"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=39596"
SRC_URI="http://www.kde-apps.org/content/files/39596-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="media-libs/xine-lib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	rm -f ${PN} INSTALL || die
}

src_configure() {
	tc-export CC
	append-cppflags $($(tc-getPKG_CONFIG) --cflags libxine)
	export LDLIBS="$($(tc-getPKG_CONFIG) --libs libxine) -lm"
}

src_compile() {
	emake ${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
