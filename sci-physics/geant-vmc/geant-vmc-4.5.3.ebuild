# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/geant4_vmc.git"
	KEYWORDS=""
else
	MY_PV=$(ver_rs 1-2 - $(ver_cut 2-))
	SRC_URI="https://github.com/vmc-project/geant4-vmc/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/geant4_vmc-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Virtual Monte Carlo Geant4 implementation"
HOMEPAGE="http://root.cern.ch/root/vmc/VirtualMC.html"

LICENSE="GPL-3"
SLOT="4"
IUSE="+c++11 c++14 c++17 doc examples geant3 +g4root +mtroot rootvmc vgm test"

REQUIRED_USE="^^ ( c++11 c++14 c++17 )"

RDEPEND="
	rootvmc? (
		>=sci-physics/root-6.18:=[vmc]
		!!sci-physics/vmc
	)
	!rootvmc? (
		>=sci-physics/root-6.18:=[-vmc]
		sci-physics/vmc:=[c++11?,c++14?,c++17?]
	)
	>=sci-physics/geant-4.10.6[c++11?,c++14?,c++17?,opengl,geant3?]
	>=sci-physics/root-6.18:=[c++11?,c++14?,c++17?]
	vgm? ( >=sci-physics/vgm-4.8:=[c++11?,c++14?,c++17?] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
RESTRICT="
	!examples? ( test )
	!geant3? ( test )
	!g4root? ( test )
	!mtroot? ( test )
	!test? ( test )
	!vgm? ( test )"

DOCS=(history README.md)

src_configure() {
	local mycmakeargs=(
		-DGeant4VMC_USE_VGM="$(usex vgm)"
		-DGeant4VMC_USE_GEANT4_G3TOG4="$(usex geant3)"
		-DGeant4VMC_USE_G4Root="$(usex g4root)"
		-DGeant4VMC_BUILD_MTRoot="$(usex mtroot)"
		-DGeant4VMC_BUILD_EXAMPLES="$(usex test)"
		-DGeant4VMC_INSTALL_EXAMPLES="$(usex examples)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc ; then
		local dirs=(
			source
			$(usev g4root)
			$(usev mtroot)
			$(usev examples)
		)
		local d
		for d in "${dirs[@]}"; do
			pushd "${d}" > /dev/null || die
			doxygen || die
			popd > /dev/null || die
		done
	fi
}

src_test() {
	cd examples || die
	./test_suite.sh --debug --g3=off --garfield=off --builddir="${BUILD_DIR}" || die
	./test_suite_exe.sh --g3=off --garfield=off --garfield=off --builddir="${BUILD_DIR}" || die
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=(doc/.)
	einstalldocs
}
