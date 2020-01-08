# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="Clone of the famous PuyoPuyo game"
HOMEPAGE="http://www.ios-software.com/?page=projet&quoi=29"
SRC_URI="http://www.ios-software.com/flobopuyo/${P}.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="media-libs/libsdl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	opengl? ( virtual/opengl )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-libs.patch

	find . -type f -name ".*" -exec rm -f \{\} \;
	sed -i \
		-e "s:^DATADIR=.*:DATADIR=\"/usr/share/${PN}\":" \
		-e "/^INSTALL_BINDIR/s:/\$(PREFIX)/games:/usr/bin:" \
		Makefile \
		|| die
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		ENABLE_OPENGL="$(use opengl && echo true || echo false)"
}

src_install() {
	default
	doman man/flobopuyo.6
	doicon "${DISTDIR}/${PN}.png"
	make_desktop_entry flobopuyo FloboPuyo
}
