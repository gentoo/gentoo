# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop optfeature

DESCRIPTION="GTK program to rip CD audio tracks to Ogg, MP3 or FLAC"
HOMEPAGE="https://gitlab.com/tiagobar/ripperx"
SRC_URI="https://gitlab.com/tiagobar/ripperx/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

DEPEND="
	dev-libs/glib
	media-libs/taglib:=
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}
	media-sound/cdparanoia
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/ripperx-3.0.1-cxx.patch
)

src_prepare() {
	default

	find src -name '*.c' -execdir mv '{}' '{}pp' \; || die
	sed -i -e 's/\.c/.cpp/g' src/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	local DOCS=( CHANGELOG.md BUGS FAQ README* TODO )
	default

	doicon src/xpms/ripperX-icon.xpm
	make_desktop_entry ripperX ripperX ripperX-icon
}

pkg_postinst() {
	optfeature_header "Install optional encoders:"
	optfeature FLAC media-libs/flac
	optfeature Musepack media-sound/musepack-tools
	optfeature MP2 media-sound/toolame media-sound/twolame
	optfeature MP3 media-sound/lame
	optfeature OGG media-sound/vorbis-tools
	optfeature Opus media-sound/opus-tools
}
