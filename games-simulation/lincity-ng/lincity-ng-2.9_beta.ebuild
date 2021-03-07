# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool multiprocessing toolchain-funcs

DESCRIPTION="City simulation game"
HOMEPAGE="https://github.com/lincity-ng/lincity-ng"
SRC_URI="https://github.com/lincity-ng/lincity-ng/archive/lincity-ng-${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BitstreamVera CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/physfs
	dev-libs/libxml2:2
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/ftjam
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${P/_/-}"

src_prepare() {
	default

	# Missing CREDITS files actually breaks the install.
	sed -i -r "s/\b(COPYING[^ ]*|CREDITS)\b//g" Jamfile || die

	# Can't use eautoreconf as it does weird jam stuff.
	autotools_run_tool ./autogen.sh
	elibtoolize
}

src_compile() {
	jam -q -dx \
		-j$(makeopts_jobs) \
		-sAR="$(tc-getAR) ru" \
		-sRANLIB="$(tc-getRANLIB)" \
		|| die "jam failed"
}

src_install() {
	jam -sDESTDIR="${D}" \
		-sappdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		-sapplicationsdir="${EPREFIX}/usr/share/applications" \
		-spixmapsdir="${EPREFIX}/usr/share/pixmaps" \
		install \
		|| die "jam install failed"
}
