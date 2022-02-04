# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Jigsaw puzzle program"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-docdir.patch
)

src_compile() {
	tc-export CXX

	append-cppflags $($(tc-getPKG_CONFIG) --cflags gtk+-3.0) -DDOCDIR="'\"${PF}\"'"
	append-ldflags -pthread
	append-libs $($(tc-getPKG_CONFIG) --libs gtk+-3.0)

	emake PREFIX="${EPREFIX}/usr" CFLAGS="${CXXFLAGS} ${CPPFLAGS} -c" LIBS="${LIBS}"
}

src_install() {
	dobin ${PN}
	newman doc/${PN}.man ${PN}.1

	insinto /usr/share/${PN}
	doins -r icons locales

	dodoc doc/{README,changelog,translations}

	docinto html
	dodoc -r doc/{images,userguide-en.html}

	doicon icons/${PN}.png
	make_desktop_entry ${PN} Picpuz
}
