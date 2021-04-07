# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_SKINS="SKINSbmodels-48files-4-23-05.zip"
MY_TEXTURES="textures-486files-8-20-05.rar"

DESCRIPTION="Collection of graphical improvements for Quake 1"
HOMEPAGE="http://facelift.quakedev.com/"
SRC_URI="http://facelift.quakedev.com/download/${MY_SKINS}
	http://facelift.quakedev.com/download/${MY_TEXTURES}"
S="${WORKDIR}"

LICENSE="quake1-textures"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-arch/unzip
	|| (
		app-arch/unrar
		app-arch/rar
	)
"

src_unpack() {
	unpack ${A}

	mv readme.txt skins.txt || die
}

src_install() {
	local dir=/usr/share/quake1
	insinto ${dir}/id1/textures
	doins -r *.tga

	# Set up symlink, for the demo levels to include the textures
	dosym ../id1/textures ${dir}/demo/textures
	dodoc *.txt
}

pkg_postinst() {
	elog "Use a Quake 1 client (e.g. darkplaces) to take advantage of these."
}
