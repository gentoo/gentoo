# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/${PN}.git"
else
	MY_PV=$(ver_rs 1-2 -)
	SRC_URI="https://github.com/vmc-project/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Virtual Monte Carlo Geant4 implementation"
HOMEPAGE="https://github.com/vmc-project/geant4_vmc"

LICENSE="GPL-3"
SLOT="4"
IUSE="doc examples geant3 +g4root vgm test"

RDEPEND="
	sci-physics/clhep:=
	>=sci-physics/geant-4.11.1:=[opengl,geant3?]
	sci-physics/root:=
	>=sci-physics/vmc-2.0:=
	vgm? ( >=sci-physics/vgm-5.1:= )"
DEPEND="${RDEPEND}
	test? ( >=sci-physics/geant-4.11.1:=[gdml] )"
BDEPEND="doc? ( app-text/doxygen[dot] )"
RESTRICT="
	!examples? ( test )
	!geant3? ( test )
	!g4root? ( test )
	!test? ( test )
	!vgm? ( test )"

DOCS=(history README.md)

PATCHES=(
	 "${FILESDIR}"/${PN}-6.6-fix-preinstall-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DGeant4VMC_USE_VGM="$(usex vgm)"
		-DGeant4VMC_USE_GEANT4_G3TOG4="$(usex geant3)"
		-DGeant4VMC_USE_G4Root="$(usex g4root)"
		-DGeant4VMC_BUILD_EXAMPLES="$(usex test)"
		-DGeant4VMC_INSTALL_EXAMPLES="$(usex examples)"
		-DGeant4VMC_BUILD_G4Root_TEST="$(usex test)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc ; then
		local dirs=(
			source
			$(usev g4root)
			$(usev examples)
		)
		local d
		for d in "${dirs[@]}"; do
			doxygen "${d}"/Doxyfile || die
		done
	fi
}

src_test() {
	cd examples || die
	virtx ./test_suite.sh --debug --g3=off --garfield=off --builddir="${BUILD_DIR}" || die
	virtx ./test_suite_exe.sh --g3=off --garfield=off --garfield=off --builddir="${BUILD_DIR}" || die
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=(doc/.)
	einstalldocs
}
