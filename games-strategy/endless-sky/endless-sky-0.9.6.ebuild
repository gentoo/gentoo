# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils scons-utils

DESCRIPTION="Space exploration, trading & combat in the tradition of Terminal Velocity"
HOMEPAGE="https://endless-sky.github.io"
SRC_URI="https://github.com/endless-sky/endless-sky/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0 CC-BY-SA-3.0 GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/glew:0
	media-libs/libsdl2
	media-libs/libjpeg-turbo
	media-libs/libpng:=
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's/\(.*flags += \["\)-O3\("\]\)/\1\2/g' SConstruct || die
	sed -i 's#env.Install("$DESTDIR$PREFIX/games", sky)#env.Install("$DESTDIR$PREFIX/bin", sky)#g' SConstruct || die
	eapply_user
}

src_compile() {
	escons
}

src_install() {
	escons PREFIX="${D}/usr/" install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
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
