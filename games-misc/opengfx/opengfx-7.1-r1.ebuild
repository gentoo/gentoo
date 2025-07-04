# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="https://wiki.openttd.org/en/Basesets/OpenGFX https://github.com/OpenTTD/OpenGFX"
SRC_URI="https://cdn.openttd.org/${PN}-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}/${P}-source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
# Mismatch appears somewhat intentional w/ changing versions of deps (bug #928269)
RESTRICT="test"

BDEPEND="
	games-util/grfcodec
	games-util/nml
	${PYTHON_DEPS}
"

DOCS=( "README.md" "changelog.txt" )

PATCHES=(
	"${FILESDIR}"/${PN}-7.1-no-which.patch
)

src_compile() {
	myemakeargs=(
		GIMP=""
		PYTHON="${EPYTHON}"
		CC="$(tc-getCC)"

		# Make logs verbose
		_V=
		_E=echo
	)

	emake "${myemakeargs[@]}" all
}

src_test() {
	emake "${myemakeargs[@]}" check
}

src_install() {
	myemakeargs+=(
		DO_NOT_INSTALL_README="true"
		DO_NOT_INSTALL_LICENSE="true"
		DO_NOT_INSTALL_CHANGELOG="true"
		INSTALL_DIR="${ED}/usr/share/openttd/baseset/"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
