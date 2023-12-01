# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
HOMEPAGE="https://github.com/vmc-project/vgm/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples +geant4 +root test"

RDEPEND="
	sci-physics/clhep:=
	geant4? ( >=sci-physics/geant-4.11:= )
	root? ( sci-physics/root:= )"
DEPEND="${RDEPEND}
	test? (
		>=sci-physics/geant-4.11:=[gdml]
		sci-physics/geant4_vmc[g4root]
	)"
BDEPEND="
	doc? ( app-doc/doxygen[dot] )
"
RESTRICT="
	!geant4? ( test )
	!root? ( test )
	!test? ( test )
	!examples? ( test )"

DOCS=(
	doc/README
	doc/VGMhistory.txt
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
		doxygen packages/Doxyfile || die
	fi
}

src_test() {
	cd "${BUILD_DIR}"/test || die
	PATH="${BUILD_DIR}"/test:${PATH} ./test_suite.sh || die
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
