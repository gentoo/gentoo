# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-multilib python-single-r1

DESCRIPTION="Tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
LICENSE+=" BSD CC-BY-3.0 CC-BY-4.0 public-domain" #bundled snappy
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+cli egl qt5 system-snappy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/libpng:0=
	media-libs/mesa[egl?,${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	sys-process/procps
	x11-libs/libX11
	egl? (
		>=media-libs/mesa-8.0[gles1,gles2]
		media-libs/waffle[egl]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2]
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5[-gles2]
	)
	system-snappy? ( >=app-arch/snappy-1.1.1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1-glxtrace-only.patch
	"${FILESDIR}"/${PN}-7.1-disable-multiarch.patch
	"${FILESDIR}"/${PN}-7.1-docs-install.patch
	"${FILESDIR}"/${PN}-7.1-snappy-license.patch
)

src_prepare() {
	cmake-utils_src_prepare

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
		local mycmakeargs=(
			-DENABLE_EGL=$(usex egl)
			-DENABLE_STATIC_SNAPPY=$(usex !system-snappy)
		)
		if multilib_is_native_abi ; then
			mycmakeargs+=(
				-DENABLE_CLI=$(usex cli)
				-DENABLE_GUI=$(usex qt5)
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

	rm docs/INSTALL.markdown || die
	dodoc docs/* README.markdown

	exeinto /usr/$(get_libdir)/${PN}/scripts
	doexe $(find scripts -type f -executable)
}
