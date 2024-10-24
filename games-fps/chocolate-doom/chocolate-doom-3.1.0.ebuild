# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools prefix python-any-r1 xdg

DESCRIPTION="A Doom source port that is minimalist and historically accurate"
HOMEPAGE="https://www.chocolate-doom.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"
LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc libsamplerate +midi png vorbis"

DEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-mixer[midi?,vorbis?]
	media-libs/sdl2-net
	libsamplerate? ( media-libs/libsamplerate )
	png? ( media-libs/libpng:= )
"

RDEPEND="
	${DEPEND}
"

# ${PYTHON_DEPS} for bash-completion and docs.
BDEPEND="
	${PYTHON_DEPS}
"

DOCS=(
	"AUTHORS"
	"ChangeLog"
	"NEWS.md"
	"NOT-BUGS.md"
	"PHILOSOPHY.md"
	"README.md"
	"README.Music.md"
	"README.Strife.md"
)

src_prepare() {
	default

	hprefixify src/d_iwad.c

	eautoreconf
}

src_configure() {
	econf \
		--enable-bash-completion \
		$(use_enable doc) \
		--disable-fonts \
		--disable-icons \
		$(use_with libsamplerate) \
		$(use_with png libpng)
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove redundant documentation files
	rm -r "${ED}/usr/share/doc/"* || die

	einstalldocs
}
