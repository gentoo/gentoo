# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="OpenSFX data files for OpenTTD"
HOMEPAGE="https://wiki.openttd.org/en/Basesets/OpenSFX https://github.com/OpenTTD/OpenSFX"
SRC_URI="https://cdn.openttd.org/opensfx-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}"/${P}-source

LICENSE="CC-BY-SA-3.0 CDDL-1.1 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
# Missing files (bug #948588)
RESTRICT="test"

BDEPEND="
	games-util/catcodec
	games-util/grfcodec
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.3-no-which.patch
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

	dodoc docs/{changelog.txt,readme.ptxt}
	einstalldocs
}
