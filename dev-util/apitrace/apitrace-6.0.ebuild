# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/apitrace/apitrace-6.0.ebuild,v 1.1 2015/01/11 19:14:30 radhermit Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib eutils python-single-r1

DESCRIPTION="A tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+cli egl qt4"

RDEPEND="${PYTHON_DEPS}
	>=app-arch/snappy-1.1.1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=media-libs/mesa-9.1.6[egl?,${MULTILIB_USEDEP}]
	egl? ( || (
		>=media-libs/mesa-8.0[gles1,gles2]
		<media-libs/mesa-8.0[gles]
	) )
	media-libs/libpng:0=
	sys-process/procps
	x11-libs/libX11
	qt4? (
		>=dev-qt/qtcore-4.7:4
		>=dev-qt/qtgui-4.7:4
		>=dev-qt/qtwebkit-4.7:4
		>=dev-libs/qjson-0.5
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-system-libs.patch
	"${FILESDIR}"/${PN}-5.0-glxtrace-only.patch
	"${FILESDIR}"/${P}-disable-multiarch.patch
)

src_prepare() {
	enable_cmake-utils_src_prepare

	# The apitrace code grubs around in the internal zlib structures.
	# We have to extract this header and clean it up to keep that working.
	# Do not be surprised if a zlib upgrade breaks things ...
	sed -r \
		-e 's:OF[(]([^)]*)[)]:\1:' \
		thirdparty/zlib/gzguts.h > gzguts.h
	rm -rf "${S}"/thirdparty/{getopt,less,libpng,snappy,zlib}
}

src_configure() {
	my_configure() {
		mycmakeargs=(
			-DARCH_SUBDIR=
			$(cmake-utils_use_enable egl EGL)
		)
		if multilib_is_native_abi ; then
			mycmakeargs+=(
				$(cmake-utils_use_enable cli CLI)
				$(cmake-utils_use_enable qt4 GUI)
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

	dodoc {BUGS,Dalvik,FORMAT,HACKING,NEWS,README,TODO}.markdown

	exeinto /usr/$(get_libdir)/${PN}/scripts
	doexe $(find scripts -type f -executable)
}
