# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

MY_SKINS="SKINSbmodels-48files-4-23-05.zip"
MY_TEXTURES="textures-486files-8-20-05.rar"

DESCRIPTION="Collection of graphical improvements for Quake 1"
HOMEPAGE="http://facelift.quakedev.com/"
SRC_URI="http://facelift.quakedev.com/download/${MY_SKINS}
	http://facelift.quakedev.com/download/${MY_TEXTURES}"

LICENSE="quake1-textures"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip
	|| (
		app-arch/unrar
		app-arch/rar )"

S=${WORKDIR}
dir=${GAMES_DATADIR}/quake1

src_unpack() {
	unpack ${A}

	mv readme.txt skins.txt
}

src_install() {
	insinto "${dir}"/id1/textures
	doins -r *.tga

	# Set up symlink, for the demo levels to include the textures
	dosym "${dir}/id1/textures" "${dir}/demo/textures"

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Use a Quake 1 client (e.g. darkplaces) to take advantage of these."
}
