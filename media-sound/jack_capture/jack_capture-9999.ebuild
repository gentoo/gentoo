# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs git-r3

DESCRIPTION="JACK Recording utility"
HOMEPAGE="https://github.com/kmatheussen/jack_capture"
EGIT_REPO_URI="https://github.com/kmatheussen/jack_capture.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="mp3 ogg osc"

CDEPEND="
	media-libs/libsndfile
	virtual/jack
	mp3? ( media-sound/lame )
	ogg? ( media-libs/libogg )
	osc? ( media-libs/liblo )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.73-r1-Makefile.patch"
)

DOCS=( README config )

src_prepare() {
	default

	use ogg || sed -i -e 's/HAVE_OGG 1/HAVE_OGG 0/' gen_das_config_h.sh
	use mp3 || sed -i -e 's/HAVE_LAME 1/HAVE_LAME 0/' -e '/COMPILEFLAGS -lmp3lame/d' gen_das_config_h.sh
	use osc || sed -i -e 's/HAVE_LIBLO 1/HAVE_LIBLO 0/' -e '/COMPILEFLAGS .* liblo/d' gen_das_config_h.sh
}

src_compile()
{
	tc-export CC CXX

	emake PREFIX="${EPREFIX}/usr" jack_capture
}

src_install()
{
	dobin jack_capture

	dodoc "${DOCS[@]}"
}
