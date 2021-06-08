# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# check the src files referenced in 51opencascade, i.e. resources and the like

EAPI=7

inherit cmake flag-o-matic

MY_PV="$(ver_rs 1- '_')"
PV_MAJ="$(ver_cut 1-2)"

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://www.opencascade.com"
SRC_URI="https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V${MY_PV};sf=tgz -> ${P}.tar.gz"
S="${WORKDIR}/occt-V${MY_PV}"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="${PV_MAJ}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug doc examples ffmpeg freeimage gles2 json optimize tbb vtk"

REQUIRED_USE="?? ( optimize tbb )"

# There's no easy way to test. Testing needs a rather big environment
# properly set up.
RESTRICT="test"

RDEPEND="
	app-eselect/eselect-opencascade
	dev-cpp/eigen
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-libs/rapidjson
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/tix
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/ftgl
	virtual/glu
	virtual/opengl
	x11-libs/libXmu
	examples? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtquickcontrols2:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	ffmpeg? ( media-video/ffmpeg )
	freeimage? ( media-libs/freeimage )
	json? ( dev-libs/rapidjson )
	tbb? ( dev-cpp/tbb )
	vtk? ( >=sci-libs/vtk-8.1.0[rendering] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	examples? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-allow-default-search-path-for-Qt5.patch
	"${FILESDIR}"/${P}-0002-remove-unnecessary-Qt5-check.patch
	"${FILESDIR}"/${P}-0003-add-Gentoo-configuration-type.patch
	"${FILESDIR}"/${P}-0004-fix-installation-of-cmake-config-files.patch
	"${FILESDIR}"/${P}-0005-fix-write-permissions-on-scripts.patch
	"${FILESDIR}"/${P}-0006-fix-creation-of-custom.sh-script.patch
)

src_prepare() {
	cmake_src_prepare

	if use debug; then
		append-cppflags -DDEBUG
		append-flags -g
	fi

	sed -e 's/\/lib\$/\/'$(get_libdir)'\$/' \
		-i adm/templates/OpenCASCADEConfig.cmake.in || die

	# There is an OCCT_UPDATE_TARGET_FILE cmake macro that fails due to some
	# assumptions it makes about installation paths. Rather than fixing it, just
	# get rid of the mechanism altogether - its purpose is to allow a
	# side-by-side installation of release and debug libraries.
	sed -e 's|\\${OCCT_INSTALL_BIN_LETTER}||' \
		-i "adm/cmake/occt_toolkit.cmake" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC_Overview=$(usex doc)
		-DBUILD_Inspector=$(usex examples)
		-DBUILD_WITH_DEBUG=$(usex debug)
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DINSTALL_DIR_BIN="$(get_libdir)/${P}/bin"
		-DINSTALL_DIR_CMAKE="$(get_libdir)/cmake/${P}"
		-DINSTALL_DIR_DOC="share/doc/${PF}"
		-DINSTALL_DIR_LIB="$(get_libdir)/${P}"
		-DINSTALL_DIR_SCRIPT="$(get_libdir)/${P}/bin"
		-DINSTALL_DIR_WITH_VERSION=ON
		-DINSTALL_SAMPLES=$(usex examples)
		-DINSTALL_TEST_CASES=NO
		-DUSE_D3D=NO
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREEIMAGE=$(usex freeimage)
		-DUSE_FREETYPE=ON
		-DUSE_GLES2=$(usex gles2)
		-DUSE_RAPIDJSON=$(usex json)
		-DUSE_TBB=$(usex tbb)
		-DUSE_VTK=$(usex vtk)
	)

	use doc && mycmakeargs+=( -DINSTALL_DOC_Overview=ON )

	if use examples; then
		mycmakeargs+=(
			-D3RDPARTY_QT_DIR="${ESYSROOT}"/usr
			-DBUILD_SAMPLES_QT=ON
		)
	fi

	if use vtk; then
		if has_version ">=sci-libs/vtk-9.0.0"; then
			mycmakeargs+=(
				-D3RDPARTY_VTK_DIR="${ESYSROOT}"/usr
				-D3RDPARTY_VTK_INCLUDE_DIR="${ESYSROOT}"/usr/include/vtk-9.0
				-D3RDPARTY_VTK_LIBRARY_DIR="${ESYSROOT}"/usr/$(get_libdir)
			)
		fi
	fi

	cmake_src_configure

	prepare_env_file() {
		# prepare /etc/env.d file
		sed -e 's|VAR_CASROOT|'${ESYSROOT}'/usr|g' < "${FILESDIR}/${PN}-${PV_MAJ}.env.in" >> "${T}/${PV_MAJ}" || die
		sed -e 's|lib/|'$(get_libdir)'/|g' -i "${T}/${PV_MAJ}" || die
		sed -e 's|VAR_PV|'${PV}'|g' -i "${T}/${PV_MAJ}" || die

		# use TBB for memory allocation optimizations?
		use tbb && (sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=2|' -i "${T}/${PV_MAJ}" || die)

		if use optimize ; then
			# use internal optimized memory manager?
			sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=1|' -i "${T}/${PV_MAJ}" || die
			# don't clear memory ?
			sed -e 's|^#MMGT_CLEAR=1$|MMGT_CLEAR=0|' -i "${T}/${PV_MAJ}" || die
		fi
	}

	prepare_env_file
}

src_install() {
	use doc && docompress -x /usr/share/doc/${PF}/overview/html
	cmake_src_install

	# respect slotting
	insinto "/etc/env.d/${PN}"
	doins "${T}/${PV_MAJ}"

	# remove examples
	if use !examples; then
		rm -r "${ED}/usr/share/${P}/samples" || die
	fi
}

pkg_postinst() {
	eselect ${PN} set ${PV_MAJ} || die "failed to switch to updated implementation"
	einfo "You can switch between available ${PN} implementations using eselect ${PN}"
}
