# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Clone of Ataxx"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${PN}_${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-warnings.patch
	"${FILESDIR}"/${P}-as-needed.patch
)

src_prepare() {
	default

	sed -i "/LoadBMP/s|\"|\"${EPREFIX}/usr/share/${PN}/|" main.c || die
}

src_compile() {
	tc-export CC

	emake E_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins *.bmp

	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Atakks
}
