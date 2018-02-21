# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/${PN}.git"
else
	SRC_URI="http://ivana.home.cern.ch/ivana/${PN}.${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}.${PV}"
fi

DESCRIPTION="Virtual Geometry Model for High Energy Physics Experiments"
HOMEPAGE="http://ivana.home.cern.ch/ivana/VGM.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples +geant4 +root test"

RDEPEND="
	sci-physics/clhep:=
	root? ( sci-physics/root:= )
	geant4? ( >=sci-physics/geant-4.10.03 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

DOCS=(
	doc/README
	doc/todo.txt
	doc/VGMhistory.txt
	doc/VGM.html
	doc/VGMversions.html
)

src_configure() {
	local mycmakeargs=(
		-DCLHEP_DIR="${EROOT}usr"
		-DWITH_EXAMPLES="$(usex examples)"
		-DINSTALL_EXAMPLES="$(usex examples)"
		-DWITH_GEANT4="$(usex geant4)"
		-DWITH_ROOT="$(usex root)"
		-DWITH_TEST="$(usex test)"
	)
	if use test && use root && use geant4; then
		mycmakeargs+=( -DWITH_G4ROOT=yes )
	else
		mycmakeargs+=( -DWITH_G4ROOT=no )
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cd packages
		doxygen || die
	fi
}

src_test() {
	cd "${BUILD_DIR}"/test || die
	./test_suite.sh || die
}

src_install() {
	cmake-utils_src_install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
