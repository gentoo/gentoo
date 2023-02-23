# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )
inherit cmake desktop python-single-r1 xdg

DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="https://ngsolve.org/ https://github.com/NGSolve/netgen"
SRC_URI="https://github.com/NGSolve/netgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"

IUSE="ffmpeg gui jpeg logging mpi opencascade python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( gui )
	jpeg? ( gui )
	python? ( gui )
"

DEPEND="
	sys-libs/zlib
	ffmpeg? ( media-video/ffmpeg:= )
	gui? (
		dev-lang/tcl:0/8.6
		dev-lang/tk:0/8.6
		media-libs/glu
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libxcb:=
	)
	jpeg? ( media-libs/libjpeg-turbo:0= )
	logging? ( dev-libs/spdlog:= )
	mpi? (
		sci-libs/metis
		virtual/mpi
	)
	opencascade? ( sci-libs/opencascade:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
			'
		)
		mpi? (
			$(python_gen_cond_dep 'dev-python/mpi4py[${PYTHON_USEDEP}]' )
		)
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/lsb-release
	virtual/pkgconfig
	gui? ( virtual/imagemagick-tools[png] )
	test? (
		<dev-cpp/catch-3:0
		python? ( $(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]') )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.2204-find-Tk-include-directories.patch"
	"${FILESDIR}/${PN}-6.2.2204-link-against-ffmpeg.patch"
	"${FILESDIR}/${PN}-6.2.2204-use-system-spdlog.patch"
	"${FILESDIR}/${PN}-6.2.2204-use-system-catch.patch"
	"${FILESDIR}/${PN}-6.2.2204-disable-failing-tests.patch"
	"${FILESDIR}/${PN}-6.2.2204-disable-python-tests.patch"
	"${FILESDIR}/${PN}-6.2.2301-find-libjpeg-turbo-library.patch"
	"${FILESDIR}/${PN}-6.2.2301-fix-nullptr-deref-in-archive.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# NOTE: need to manually check and update this string on version bumps!
	# git describe --tags --match "v[0-9]*" --long --dirty
	cat <<- EOF > "${S}/version.txt" || die
		v${PV}-0-g26d12898
	EOF
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# currently not working in a sandbox, expects netgen to be installed
		# see https://github.com/NGSolve/netgen/issues/132
		-DBUILD_STUB_FILES=OFF
		-DENABLE_UNIT_TESTS=$(usex test)
		-DINSTALL_PROFILES=OFF
		-DNG_INSTALL_DIR_CMAKE="$(get_libdir)/cmake/${PN}"
		-DNG_INSTALL_DIR_INCLUDE="include/${PN}"
		-DNG_INSTALL_DIR_LIB="$(get_libdir)"
		-DUSE_CCACHE=OFF
		# doesn't build with this version
		-DUSE_CGNS=OFF
		-DUSE_GUI=$(usex gui)
		-DUSE_INTERNAL_TCL=OFF
		-DUSE_JPEG=$(usex jpeg)
		-DUSE_MPEG=$(usex ffmpeg)
		# respect users -march= choice
		-DUSE_NATIVE_ARCH=OFF
		-DUSE_MPI=$(usex mpi)
		-DUSE_OCC=$(usex opencascade)
		-DUSE_PYTHON=$(usex python)
		-DUSE_SPDLOG=$(usex logging)
		-DUSE_SUPERBUILD=OFF
	)
	# no need to set this, if we only build the library
	if use gui; then
		mycmakeargs+=( -DTK_INCLUDE_PATH="/usr/$(get_libdir)/tk8.6/include" )
	fi
	if use python; then
		mycmakeargs+=(
			-DPREFER_SYSTEM_PYBIND11=ON
			# needed, so the value gets passed to NetgenConfig.cmake instead of ${T}/pythonX.Y
			-DPYTHON_EXECUTABLE="${PYTHON}"
		)
	fi
	if use mpi && use python; then
		mycmakeargs+=( -DUSE_MPI4PY=ON )
	else
		mycmakeargs+=( -DUSE_MPI4PY=OFF )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use python && python_optimize

	local NETGENDIR="/usr/share/${PN}"
	echo -e "NETGENDIR=${NETGENDIR}" > ./99netgen || die
	doenvd 99netgen

	if use gui; then
		mv "${ED}"/usr/bin/{*.tcl,*.ocf} "${ED}${NETGENDIR}" || die

		convert -deconstruct "${S}/windows/${PN}.ico" netgen.png || die
		newicon -s 32 "${S}"/${PN}-2.png ${PN}.png
		newicon -s 16 "${S}"/${PN}-3.png ${PN}.png
		make_desktop_entry ${PN} "Netgen" netgen Graphics
	fi

	mv "${ED}"/usr/share/${PN}/doc/ng4.pdf "${ED}"/usr/share/doc/${PF} || die
	dosym -r /usr/share/doc/${PF}/ng4.pdf /usr/share/${PN}/doc/ng4.pdf

	use python || rm -r "${ED}${NETGENDIR}"/py_tutorials || die
}
