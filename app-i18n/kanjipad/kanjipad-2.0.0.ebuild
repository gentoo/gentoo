# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Japanese handwriting recognition tool"
HOMEPAGE="https://fishsoup.net/software/kanjipad/"
SRC_URI="https://fishsoup.net/software/kanjipad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README TODO jstroke/README-kanjipad )

PATCHES=(
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	default
	perl -i -pe "s|PREFIX=/usr/local|PREFIX=/usr|;
		s|-DG.*DISABLE_DEPRECATED||g" Makefile || die "Fixing Makefile failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin kanjipad kpengine
	insinto /usr/share/kanjipad
	doins jdata.dat
	einstalldocs
}
