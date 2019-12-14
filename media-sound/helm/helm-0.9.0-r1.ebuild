# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="Open source polyphonic software synthesizer with lots of modulation"
HOMEPAGE="https://tytel.org/helm/"
SRC_URI="https://github.com/mtytel/helm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/lv2
	virtual/jack
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr"
RDEPEND="${DEPEND}
	!app-admin/helm
"

DOCS=( changelog README.md )

PATCHES=(
	"${FILESDIR}/${P}-nomancompress.patch"
	"${FILESDIR}/${P}-fix-gcc91.patch"
)

src_prepare() {
	default
	sed -e "s|/usr/lib/|/usr/$(get_libdir)/|" -i Makefile || die "Failed to fix libdir"
	sed -e "s|^\(CHANGES.*\)/|\1-${PVR}|" -i Makefile || die "Failed to fix doc path"
}

src_compile() {
	emake PREFIX=/usr all
}

src_install() {
	default
	make_desktop_entry /usr/bin/helm Helm /usr/share/helm/icons/helm_icon_32_1x.png
}
