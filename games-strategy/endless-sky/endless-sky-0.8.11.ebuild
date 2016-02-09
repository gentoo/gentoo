# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils scons-utils

DESCRIPTION="Space exploration, trading & combat game."
HOMEPAGE="https://endless-sky.github.io"
SRC_URI="https://github.com/endless-sky/endless-sky/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0 CC-BY-SA-3.0 GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/glew
	media-libs/libsdl2
	media-libs/libjpeg-turbo
	media-libs/libpng:=
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's/"-std=c++0x", "-O3", "-Wall"/"-std=c++0x", "-Wall"/' SConstruct || die
	sed -i 's#env.Install("$DESTDIR$PREFIX/games", sky)#env.Install("$DESTDIR$PREFIX'"/bin"'", sky)#' SConstruct || die
	myesconsargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PREFIX="${D}usr/games/"
	)
}
src_compile() {
	escons
}

src_install() {
	escons install
}

pkg_postinst() {
	einfo "Endless Sky provides high-res sprites for high-dpi screens."
	einfo "If you want to use them, download"
	einfo
	einfo "   https://github.com/endless-sky/endless-sky-high-dpi/releases"
	einfo
	einfo "and extract it to ~/.local/share/endless-sky/plugins/."
	einfo
	einfo "   Enjoy."
}
