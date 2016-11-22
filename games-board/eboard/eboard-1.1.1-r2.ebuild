# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DEB_V=${PV}-4.1
EXTRAS1="eboard-extras-1pl2"
EXTRAS2="eboard-extras-2"
DESCRIPTION="chess interface for POSIX systems"
HOMEPAGE="http://www.bergo.eng.br/eboard/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${EXTRAS1}.tar.gz
	mirror://sourceforge/${PN}/${EXTRAS2}.tar.gz
	mirror://debian/pool/main/e/eboard/${PN}_${DEB_V}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="
	media-libs/libpng:0=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/${PN}_${DEB_V}.diff
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-ovflfix.patch
	"${FILESDIR}"/${P}-libpng15.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:(\"-O6\"):split(' ', \"${CXXFLAGS}\"):" \
		configure || die
}

src_configure() {
	./configure \
		--compiler="$(tc-getCXX)" \
		--prefix="/usr" \
		--data-prefix="/usr/share" \
		--man-prefix="/usr/share/man" \
		--extra-libs="dl" \
		$(use_enable nls) || die # not an autoconf script
}

src_install() {
	default
	dodoc Documentation/*.txt

	newicon icon-eboard.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}

	cd "${WORKDIR}"/${EXTRAS1}
	insinto /usr/share/${PN}
	doins *.png *.wav
	newins extras1.conf themeconf.extras1
	newdoc ChangeLog Changelog.extras
	newdoc README README.extras
	dodoc CREDITS

	cd "${WORKDIR}"/${EXTRAS2}
	doins *.png *.wav
	newins extras2.conf themeconf.extras2
}
