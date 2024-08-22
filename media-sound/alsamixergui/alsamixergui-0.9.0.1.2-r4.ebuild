# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

MY_P=${PN}-0.9.0rc1-2

DESCRIPTION="FLTK based amixer Frontend"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"

RDEPEND="
	media-libs/alsa-lib:=
	media-sound/alsa-utils
	x11-libs/fltk:1"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/segfault-on-exit.patch
	"${FILESDIR}"/${P}-fltk-1.1.patch
	"${FILESDIR}"/${P}-strsignal.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	append-libs "-L$(dirname $(fltk-config --libs))"
	append-cppflags "-I$(fltk-config --includedir)"
	econf
}

src_install() {
	default

	newicon src/images/alsalogo.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Alsa Mixer GUI"
}
