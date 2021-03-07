# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# check the src files referenced in 51opencascade, i.e. resources and the like
# check where cmake gets it's '-s' linker flag to avoid pre-stripping (QA)

EAPI=7

inherit check-reqs cmake flag-o-matic java-pkg-opt-2

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://www.opencascade.com"
MY_PV="$(ver_rs 1- '_')"
SRC_URI="https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V${MY_PV};sf=tgz -> ${P}.tar.gz"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
# gl2ps
IUSE="debug doc examples ffmpeg freeimage gles2 inspector java optimize qt5 tbb +vtk"

REQUIRED_USE="
	inspector? ( qt5 )
	?? ( optimize tbb )
"

RDEPEND="
	app-eselect/eselect-opencascade
	dev-cpp/eigen
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/tix
	media-libs/freetype:2
	media-libs/ftgl
	virtual/glu
	virtual/opengl
	x11-libs/libXmu
	ffmpeg? ( media-video/ffmpeg )
	freeimage? ( media-libs/freeimage )
	java? ( virtual/jdk:1.8 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtquickcontrols2:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	tbb? ( dev-cpp/tbb )
	vtk? (
		>=sci-libs/vtk-8.1.0[rendering]
		<sci-libs/vtk-9
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		qt5? ( dev-qt/linguist-tools:5 )
	)
"

# There's no easy way to test. Testing needs a rather big environment
# properly set up.
RESTRICT="test"

CHECKREQS_MEMORY="256M"
CHECKREQS_DISK_BUILD="3584M"

CMAKE_BUILD_TYPE=Release

S="${WORKDIR}/occt-V${MY_PV}"

PATCHES=(
	"${FILESDIR}/${P}-find-qt.patch"
	"${FILESDIR}/${P}-fix-install.patch"
	"${FILESDIR}/${P}-fix-issue-with-cmake-path-variables.patch"
	"${FILESDIR}/${P}-Gentoo-specific-avoid-pre-stripping-files.patch"
	"${FILESDIR}/${P}-fix-flow-control-nesting.patch"
)

pkg_setup() {
	check-reqs_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	use java && java-pkg-opt-2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC_Overview=$(usex doc)
		-DBUILD_Inspector=$(usex inspector)
		-DBUILD_WITH_DEBUG=$(usex debug)
		-DCMAKE_CONFIGURATION_TYPES="Gentoo"
		-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/${P}/ros"
		-DINSTALL_DIR_DOC="/usr/share/doc/${PF}"
		-DINSTALL_DIR_CMAKE="/usr/$(get_libdir)/cmake"
		-DINSTALL_SAMPLES=$(usex examples)
		-DINSTALL_TEST_CASES=NO
		-DUSE_D3D=no
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREEIMAGE=$(usex freeimage)
		-DUSE_GLES2=$(usex gles2)
		-DUSE_TBB=$(usex tbb)
		-DUSE_VTK=$(usex vtk)
	)

	use doc && mycmakeargs+=( -DINSTALL_DOC_Overview=ON )
	use examples && mycmakeargs+=( -DBUILD_SAMPLES_QT=$(usex qt5) )

	cmake_src_configure

	# prepare /etc/env.d file
	sed -e 's|VAR_CASROOT|'${EROOT%}'/usr/'$(get_libdir)'/'${P}'/ros|g' < "${FILESDIR}/${P}.env.in" >> "${T}/${PV}" || die
	sed -i -e 's|ros/lib|ros/'$(get_libdir)'|' "${T}/${PV}" || die

	# use TBB for memory allocation optimizations?
	use tbb && (sed -i -e 's|^#MMGT_OPT=0$|MMGT_OPT=2|' "${T}/${PV}" || die)

	if use optimize ; then
		# use internal optimized memory manager?
		sed -i -e 's|^#MMGT_OPT=0$|MMGT_OPT=1|' "${T}/${PV}" || die
		# don't clear memory ?
		sed -i -e 's|^#MMGT_CLEAR=1$|MMGT_CLEAR=0|' "${T}/${PV}" || die
	fi
}

src_install() {
	cmake_src_install

	# respect slotting
	insinto "/etc/env.d/${PN}"
	doins "${T}/${PV}"

	# remove examples
	use examples || (rm -rf "${ED}/usr/$(get_libdir)/${P}/ros/share/${PN}/samples" || die)
	use java || (rm -rf "${ED}/usr/$(get_libdir)/${P}/ros/share/${PN}/samples/java" || die)
	use qt5 || (rm -rf "${ED}/usr/$(get_libdir)/${P}/ros/share/${PN}/samples/qt" || die)
}

pkg_postinst() {
	eselect ${PN} set ${PV} || die "failed to switch to updated implementation"
	einfo "You can switch between available ${PN} implementations using eselect ${PN}"
}
