# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=avogadroapp
inherit cmake xdg

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="https://www.openchemistry.org/ https://two.avogadro.cc/"
SRC_URI="
	https://github.com/OpenChemistry/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenChemistry/avogadro-i18n/archive/${PV}.tar.gz -> ${P}-i18n.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc vtk"

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,opengl,ssl,widgets]
	~sci-libs/avogadrolibs-${PV}[qt6,vtk?]
	vtk? ( sci-libs/vtk:= )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	vtk? ( dev-libs/pegtl )
"
BDEPEND="doc? ( app-text/doxygen )"

src_unpack() {
	default
	mv "${WORKDIR}"/avogadro-i18n-${PV} "${WORKDIR}"/avogadro-i18n || die
}

src_prepare() {
	if use doc; then
		doxygen -u docs/doxyfile.in 2>/dev/null || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_DOCUMENTATION=$(usex doc)
		# rpc/molequeue is abandoned
		# see https://github.com/OpenChemistry/avogadroapp/issues/561
		-DAvogadro_ENABLE_RPC=OFF
		# test requires qttesting/paraview
		-DENABLE_TESTING=OFF
		-DQT_VERSION=6
		-DUSE_VTK=$(usex vtk)
	)

	# Need this to prevent overwriting the documentation OUTDIR
	use doc && mycmakeargs+=(
			-DChemData_SOURCE_DIR="${S}"
			-DChemData_BINARY_DIR="${BUILD_DIR}"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_build documentation
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )

	cmake_src_install

	# remove CONTRIBUTING, LICENSE and duplicate README
	rm -r "${ED}"/usr/share/doc/${PF}/avogadro2 || die
}
