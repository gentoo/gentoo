# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit python-any-r1

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="https://wiki.openttd.org/en/Basesets/OpenGFX https://github.com/OpenTTD/OpenGFX"
SRC_URI="https://cdn.openttd.org/${PN}-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}/${P}-source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	games-util/grfcodec
	games-util/nml
	${PYTHON_DEPS}
"

DOCS=( "README.md" "changelog.txt" )

PATCHES=(
	"${FILESDIR}"/${PN}-7.1-no-which.patch
)

src_prepare() {
	default

	python-any-r1_pkg_setup
}

src_compile() {
	local myemakeargs=(
		GIMP=""
		PYTHON="${EPYTHON}"
	)

	emake "${myemakeargs[@]}" all
}

src_test() {
	local myemakeargs=(
		GIMP=""
		PYTHON="${EPYTHON}"
	)

	emake "${myemakeargs[@]}" check
}

src_install() {
	local myemakeargs=(
		DO_NOT_INSTALL_README="true"
		DO_NOT_INSTALL_LICENSE="true"
		DO_NOT_INSTALL_CHANGELOG="true"
		GIMP=""
		INSTALL_DIR="${ED}/usr/share/openttd/baseset/"
		PYTHON="${EPYTHON}"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
