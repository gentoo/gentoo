# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="OpenGFX"

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/opengfx/"
SRC_URI="https://cdn.openttd.org/${PN}-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}/${P}-source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	games-util/grfcodec
	games-util/nml
"

DOCS=( "README.md" "changelog.txt" )

src_prepare() {
	default
}

src_compile() {
	myemakeargs=(
		GIMP=""
	)

	emake "${myemakeargs[@]}" all
}

src_test() {
	myemakeargs=(
		GIMP=""
	)

	emake "${myemakeargs[@]}" check
}

src_install() {
	myemakeargs=(
		DO_NOT_INSTALL_README="true"
		DO_NOT_INSTALL_LICENSE="true"
		DO_NOT_INSTALL_CHANGELOG="true"
		GIMP=""
		INSTALL_DIR="${ED}/usr/share/games/openttd/data/"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
