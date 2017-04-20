# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib eutils python-single-r1

DESCRIPTION="A tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
LICENSE+=" BSD CC-BY-3.0 CC-BY-4.0 public-domain" #bundled snappy
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+cli egl qt5 system-snappy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=sys-devel/gcc-4.7:*
	system-snappy? ( >=app-arch/snappy-1.1.1[${MULTILIB_USEDEP}] )
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=media-libs/mesa-9.1.6[egl?,${MULTILIB_USEDEP}]
	egl? ( || (
		>=media-libs/mesa-8.0[gles1,gles2]
		<media-libs/mesa-8.0[gles]
		)
		media-libs/waffle[egl]
	)
	media-libs/libpng:0=
	sys-process/procps
	x11-libs/libX11
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1-glxtrace-only.patch
	"${FILESDIR}"/${PN}-7.1-disable-multiarch.patch
	"${FILESDIR}"/${PN}-7.1-docs-install.patch
	"${FILESDIR}"/${PN}-7.1-snappy-license.patch
)

src_prepare() {
	enable_cmake-utils_src_prepare

	# The apitrace code grubs around in the internal zlib structures.
	# We have to extract this header and clean it up to keep that working.
	# Do not be surprised if a zlib upgrade breaks things ...
	rm -rf "${S}"/thirdparty/{getopt,less,libpng,zlib,dxerr,directxtex,devcon} || die
	if use system-snappy ; then
		rm -rf "${S}"/thirdparty/snappy || die
	fi
}

src_configure() {
	my_configure() {
		mycmakeargs=(
			-DARCH_SUBDIR=
			$(cmake-utils_use_enable egl EGL)
			$(cmake-utils_use_enable !system-snappy STATIC_SNAPPY)
		)
		if multilib_is_native_abi ; then
			mycmakeargs+=(
				$(cmake-utils_use_enable cli CLI)
				$(cmake-utils_use_enable qt5 GUI)
			)
		else
			mycmakeargs+=(
				-DBUILD_LIB_ONLY=ON
				-DENABLE_CLI=OFF
				-DENABLE_GUI=OFF
			)
		fi
		cmake-utils_src_configure
	}

	multilib_parallel_foreach_abi my_configure
}

src_install() {
	cmake-multilib_src_install

	dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so
	dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1
	dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1.2

	rm docs/INSTALL.markdown
	dodoc docs/* README.markdown

	exeinto /usr/$(get_libdir)/${PN}/scripts
	doexe $(find scripts -type f -executable)
}
