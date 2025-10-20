# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic qmake-utils xdg

MY_COMMIT="376c1469eebedcc724dbbcc0d45030f32c9d13f5"
MY_COMMIT_LANG="b7393340eda6fa2aebaeeeae9014b923ad82e407"

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="
	https://github.com/mean00/avidemux2/archive/${MY_COMMIT}.tar.gz -> avidemux-${PV}.tar.gz
	https://github.com/mean00/avidemux2_i18n/archive/${MY_COMMIT_LANG}.tar.gz -> ${PN}-i18n-${PV}.tar.gz
"

# Multiple licenses because of all the bundled stuff.
# See License.txt.
LICENSE="GPL-2 MIT PSF-2 LGPL-2 OFL-1.1"
SLOT="2.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls nvenc opengl gui sdl vaapi vdpau xv"

BDEPEND="
	dev-lang/yasm
	gui? ( dev-qt/qttools:6 )
"
DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,xv?]
	opengl? ( virtual/opengl )
	gui? ( dev-qt/qtbase:6[gui,network,opengl,widgets] )
	vaapi? ( media-libs/libva:= )
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
	!<media-video/avidemux-${PV}
"

PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,gui?]"

S=${WORKDIR}/avidemux2-${MY_COMMIT}

src_unpack() {
	default
	mv -f -T avidemux2_i18n-"${MY_COMMIT_LANG}" "${S}"/avidemux/qt4/i18n >/dev/null || die
}

src_prepare() {
	# prevent cmake.eclass warnings
	sed -i -e "s/cmake_minimum_required(VERSION 3.7)/cmake_minimum_required(VERSION 3.20)/" \
		avidemux/qt4/xdg_data/CMakeLists.txt || die

	processes="buildCli:avidemux/cli"
	use gui && processes+=" buildQt4:avidemux/qt4"

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake_src_prepare
	done

	# Remove "Build Option" dialog because it doesn't reflect
	# what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/qt4/ADM_commonUI/myOwnMenu.h || die "Couldn't remove \"Build Option\" dialog."
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/915773
	#
	# Upstream has abandoned sourceforge for github. And doesn't enable github issues.
	# Message received, no bug reported.
	filter-lto

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	# The build relies on an avidemux-core header that uses 'nullptr'
	# which is from >=C++11. Let's use the GCC-6 default C++ dialect.
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DOPENGL="$(usex opengl)"
		-DNVENC="$(usex nvenc)"
		-DXVIDEO="$(usex xv)"
		-DENABLE_QT4=OFF
		-DENABLE_QT5=OFF
	)

	use gui && mycmakeargs+=(
			-DENABLE_QT6="$(usex gui)"
			-DLRELEASE_EXECUTABLE="$(qt6_get_bindir)/lrelease"
	)

	use debug && mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )

	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${build}" cmake_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake_src_compile
	done
}

src_test() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake_src_test
	done
}

src_install() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake_src_install
	done
}
