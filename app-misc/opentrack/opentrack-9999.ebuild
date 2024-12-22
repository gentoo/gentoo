# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic toolchain-funcs

DESCRIPTION="Head tracking software for MS Windows, Linux, and Apple OSX"
HOMEPAGE="https://github.com/opentrack/opentrack"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/opentrack/opentrack.git"
else
	SRC_URI="https://github.com/opentrack/opentrack/archive/refs/tags/${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/opentrack-${P}"
fi

LICENSE="ISC"
SLOT="0"

IUSE="neuralnet wine opencv openmp"

REQUIRED_USE="neuralnet? ( openmp opencv )"

DEPEND="
	neuralnet? ( sci-libs/onnxruntime-bin )
	opencv? ( media-libs/opencv )
	wine? ( virtual/wine )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	sys-process/procps
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	# work around hard-coded docs path
	sed -e 's#share/doc/opentrack#share/doc/'${P}'#g' \
		-i cmake/*.cmake || die

	cmake_src_prepare
}

src_configure() {
	use openmp && append-cxxflags -fopenmp

	local mycmakeargs=(
		$(cmake_use_find_package neuralnet ONNXRuntime)
		$(cmake_use_find_package opencv OpenCV)
		$(cmake_use_find_package openmp OpenMP)
	)

	# opentrack overwrites emerge cflags unconditionally: we can prevent
	# that by pretending they've already been set
	mycmakeargs+=(
		-D__otr_compile_flags_set=TRUE
	)

	# HACK: "/opt/opentrack" allows its wine components to be visible in
	# Valve's pressure-vessel which replace /usr with the container runtime
	use wine && mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX=/opt/opentrack
		-DOPENTRACK_WINE_ARCH="-m64"
		-DSDK_WINE=$(usex wine ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use wine && dosym -r /opt/opentrack/bin/opentrack /usr/bin/opentrack

	newicon gui/images/opentrack.png opentrack.png
	make_desktop_entry /usr/bin/opentrack OpenTrack /usr/share/pixmaps/opentrack.png Utility
}
