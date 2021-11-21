# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Collection of LV2 plugins"
HOMEPAGE="https://github.com/x42/x42-plugins"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/x42/x42-plugins.git"
else
	SRC_URI="http://gareus.org/misc/x42-plugins/${P}.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

RDEPEND="dev-libs/glib
	media-fonts/dejavu
	media-libs/ftgl
	media-libs/glu
	media-libs/liblo
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libltc
	media-libs/lv2
	media-libs/zita-convolver
	sci-libs/fftw:3.0
	virtual/jack
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/pango
"
DEPEND="${RDEPEND}
	sys-apps/help2man"

src_compile() {
	emake STRIP="#" FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LV2DIR="/usr/$(get_libdir)/lv2" install
}
