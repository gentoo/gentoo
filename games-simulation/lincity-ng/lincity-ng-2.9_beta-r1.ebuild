# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multiprocessing toolchain-funcs

DESCRIPTION="City simulation game"
HOMEPAGE="https://github.com/lincity-ng/lincity-ng"
SRC_URI="https://github.com/lincity-ng/lincity-ng/archive/lincity-ng-${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${P/_/-}"

LICENSE="GPL-2+ BitstreamVera CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/physfs
	dev-libs/libxml2:2=
	media-libs/libsdl[joystick,opengl,sound,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxslt
	dev-util/ftjam
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
)

src_prepare() {
	default

	AT_M4DIR=mk/autoconf eautoreconf

	# strip down autogen.sh / makerelease.sh for needed additional actions
	sed -i -e '1a\set -e' -e '1n;/# generate Jam/,$!d;/^$/,$d' autogen.sh || die
	sed -i -e '1a\set -e' -e '/^$/,$d' makerelease.sh || die

	./autogen.sh || die "Failed to generate Jamconfig.in"
	./makerelease.sh || die "Failed to generate CREDITS"
}

src_compile() {
	tc-export CC RANLIB
	export AR="$(tc-getAR) cru" #739376

	jam -q -dx -j$(makeopts_jobs) || die
}

src_install() {
	jam -q -dx -sDESTDIR="${D}" -sPACKAGE_VERSION=${PVR} install || die

	rm "${ED}"/usr/share/doc/${PF}/COPYING* || die
}
