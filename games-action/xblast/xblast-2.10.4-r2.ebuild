# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

MY_GAMEDATA=(
	images-2005-01-06:image
	levels-2005-01-06:level
	models-2005-01-06:image/sprite
	musics-2005-01-06:sounds
	sounds
)

DESCRIPTION="Bomberman clone with network support for up to 6 players"
HOMEPAGE="https://xblast.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/xblast/${P}.tar.gz
	$(printf 'mirror://sourceforge/xblast/%s.tar.gz ' "${MY_GAMEDATA[@]%:*}")"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	media-fonts/font-adobe-100dpi"
DEPEND="
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXt"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_prepare() {
	default

	find "${WORKDIR}" -name Imakefile -exec rm {} + || die

	# badly non-utf8 named file that doesn't match xblast.wxs runtime #750077
	mv "${WORKDIR}"/levels-2005-01-06/reconstruct{?,i}on2.xal || die

	eautoreconf #255857
}

src_configure() {
	econf \
		--enable-sound \
		--with-otherdatadir="${EPREFIX}"/usr/share/${PN}
}

src_install() {
	default

	local data
	for data in "${MY_GAMEDATA[@]}"; do
		insinto /usr/share/${PN}/${data#*:}
		doins -r "${WORKDIR}"/${data%:*}/.
	done

	make_desktop_entry ${PN} XBlast applications-games
}
