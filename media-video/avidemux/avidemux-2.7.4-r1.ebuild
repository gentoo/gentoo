# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake desktop qmake-utils xdg

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="https://github.com/mean00/avidemux2/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls nvenc opengl qt5 sdl vaapi vdpau xv"

COMMON_DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,xv?,nvenc?]
	nvenc? ( amd64? ( media-video/nvidia_video_sdk:0 ) )
	opengl? ( virtual/opengl:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	vaapi? ( x11-libs/libva:0= )
"
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl:0 )
	!<media-video/avidemux-${PV}
"
PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,qt5?]"

S="${WORKDIR}/avidemux2-${PV}"

src_prepare() {
	processes="buildCli:avidemux/cli"
	use qt5 && processes+=" buildQt4:avidemux/qt4"

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake_src_prepare
	done

	if use qt5; then
		# Fix icon name -> avidemux-2.7
		sed -i -e "/^Icon/ s:${PN}\.png:${PN}-${SLOT}:" appImage/${PN}.desktop || \
			die "Icon name fix failed."

		# The desktop file is broken. It uses avidemux3_portable instead of avidemux3_qt5
		sed -i -re '/^Exec/ s:(avidemux3_)portable:\1qt5:' appImage/${PN}.desktop || \
			die "Desktop file fix failed."

		# QA warnings: missing trailing ';' and 'Application' is deprecated.
		sed -i -e 's/Application;AudioVideo/AudioVideo;/g' appImage/${PN}.desktop || \
			die "Desktop file fix failed."

		# Now rename the desktop file to not collide with 2.6.
		mv appImage/${PN}.desktop ${PN}-${SLOT}.desktop || die "Collision rename failed."
	fi

	# Remove "Build Option" dialog because it doesn't reflect
	# what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/common/ADM_commonUI/myOwnMenu.h || \
		die "Couldn't remove \"Build Option\" dialog."
}

src_configure() {
	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	# The build relies on an avidemux-core header that uses 'nullptr'
	# which is from >=C++11. Let's use the GCC-6 default C++ dialect.
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLibVA="$(usex vaapi)"
		-DOPENGL="$(usex opengl)"
		-DVDPAU="$(usex vdpau)"
		-DXVIDEO="$(usex xv)"
	)

	use qt5 && mycmakeargs+=(
			-DENABLE_QT5="$(usex qt5)"
			-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
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

	if use qt5; then
		cd "${S}" || die "Can't enter source folder"
		newicon ${PN}_icon.png ${PN}-${SLOT}.png
		domenu ${PN}-${SLOT}.desktop
	fi
}
