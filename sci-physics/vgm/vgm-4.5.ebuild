# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/${PN}.git"
else
	MY_PV=$(ver_rs 1- -)
	SRC_URI="https://github.com/vmc-project/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Virtual Geometry Model for High Energy Physics Experiments"
HOMEPAGE="http://ivana.home.cern.ch/ivana/VGM.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples +geant4 +root test"

# sci-physics/root[c++11] required to match sci-physics/geant
RDEPEND="
	sci-physics/clhep:=
	root? ( >=sci-physics/root-6.14:=[c++11] )
	geant4? ( >=sci-physics/geant-4.10.03 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-physics/geant-vmc[g4root] )"
RESTRICT="
	!geant4? ( test )
	!root? ( test )
	!test? ( test )"

DOCS=(
	doc/README
	doc/todo.txt
	doc/VGMhistory.txt
	doc/VGM.html
	doc/VGMversions.html
)
PATCHES=(
	"${FILESDIR}"/"${PN}-fix-FindCLHEP.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCLHEP_DIR="${EPREFIX}/usr"
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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
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
	cmake_src_install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
