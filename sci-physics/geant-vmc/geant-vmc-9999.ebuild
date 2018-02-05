# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/geant4_vmc.git"
else
	DOWN_PV=$(ver_cut 2-)
	SRC_URI="http://root.cern.ch/download/vmc/geant4_vmc.${DOWN_PV}.tar.gz"
	SOURCE_PV=$(ver_rs 1- - ${DOWN_PV})
	S="${WORKDIR}/geant4_vmc-${SOURCE_PV}"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Virtual Monte Carlo Geant4 implementation"
HOMEPAGE="http://root.cern.ch/root/vmc/VirtualMC.html"

LICENSE="GPL-2"
SLOT="4"
IUSE="doc examples geant3 +g4root +mtroot vgm test"

# sci-physics/root[root7] flag activates std=c++14, which we could only support if also Geant is built with it.
# Disable for now.
RDEPEND="
	>=sci-physics/geant-4.10.03:=[opengl,geant3?]
	sci-physics/root:=[-root7]
	vgm? ( >=sci-physics/vgm-4.4:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
RESTRICT="
	!geant3? ( test )
	!g4root? ( test )
	!mtroot? ( test )
	!vgm? ( test )"

DOCS=(
	history
	README.md
)

src_configure() {
	local mycmakeargs=(
		-DGeant4VMC_USE_VGM="$(usex vgm)"
		-DGeant4VMC_USE_GEANT4_G3TOG4="$(usex geant3)"
		-DGeant4VMC_USE_G4Root="$(usex g4root)"
		-DGeant4VMC_BUILD_MTRoot="$(usex mtroot)"
		-DGeant4VMC_BUILD_EXAMPLES="$(usex test)"
		-DGeant4VMC_INSTALL_EXAMPLES="$(usex examples)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
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
	# Required by sci-physics/root for pointer validity checking,
	# see e.g. https://sft.its.cern.ch/jira/browse/ROOT-8146 .
	addwrite /dev/random
	cd examples || die
	./test_suite.sh --g3=off --builddir="${BUILD_DIR}" || die
	./test_suite_exe.sh --g3=off --builddir="${BUILD_DIR}" || die
}

src_install() {
	cmake-utils_src_install
	use doc && local HTML_DOCS=(doc/.)
	einstalldocs
}
