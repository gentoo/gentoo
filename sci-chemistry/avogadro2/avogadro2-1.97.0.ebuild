# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN=avogadroapp

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
DOCS_DIR="${WORKDIR}/${MY_PN}-${PV}_build/docs"
# docs/CMakeLists.txt overwrites docs.eclass outdir if we do not set this
DOCS_OUTDIR="${DOCS_DIR}/html"
DOCS_CONFIG_NAME="doxyfile"
inherit desktop docs cmake xdg

I18N_COMMIT="13c4286102373658cea48a33b86536ab5793da66"

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="https://www.openchemistry.org/"
SRC_URI="
	https://github.com/OpenChemistry/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenChemistry/avogadro-i18n/archive/${I18N_COMMIT}.tar.gz -> ${P}-i18n.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="rpc test vtk"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sci-libs/avogadrolibs-${PV}[qt5,vtk?]
	sci-libs/hdf5:=
	rpc? ( sci-chemistry/molequeue )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-qt/qttest:5 )
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.95.1-qttest.patch"
)

src_unpack() {
	default
	mv "${WORKDIR}/avogadro-i18n-${I18N_COMMIT}" "${WORKDIR}/avogadro-i18n" || die
}

src_prepare() {
	cmake_src_prepare
	sed -e "/LICENSE/d" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DAvogadro_ENABLE_RPC=$(usex rpc)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
	)
	# Need this to prevent overwriting the documentation OUTDIR
	use doc && mycmakeargs+=( -DChemData_BINARY_DIR="${DOCS_OUTDIR}" )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install
	for size in 64 128 256 512; do
		newicon -s "${size}" avogadro/icons/"${PN}"_"${size}".png "${PN}".png
	done
}
