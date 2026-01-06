# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic qmake-utils xdg

MY_COMMIT="376c1469eebedcc724dbbcc0d45030f32c9d13f5"
MY_COMMIT_LANG="b7393340eda6fa2aebaeeeae9014b923ad82e407"
DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="
	https://github.com/mean00/avidemux2/archive/${MY_COMMIT}.tar.gz -> avidemux-${PV}.tar.gz
	https://github.com/mean00/avidemux2_i18n/archive/${MY_COMMIT_LANG}.tar.gz -> ${PN}-i18n-${PV}.tar.gz
"
S="${WORKDIR}/avidemux2-${MY_COMMIT}"

# Multiple licenses because of all the bundled stuff.
# See License.txt.
LICENSE="GPL-2 MIT PSF-2 LGPL-2 OFL-1.1"
SLOT="2.7"
KEYWORDS="~amd64 ~x86"
IUSE="gui nls nvenc opengl sdl vaapi vdpau xv"

BDEPEND="
	dev-lang/yasm[nls=]
	gui? ( dev-qt/qttools:6[linguist] )
"
DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,nvenc=,vaapi=,vdpau=,xv?]
	gui? (
		dev-qt/qtbase:6[gui,network,opengl,widgets,X]
		opengl? (
			media-libs/glu
			media-libs/libglvnd
		)
		sdl? ( media-libs/libsdl2[sound,video] )
		xv? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXv
		)
	)
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
	!<media-video/avidemux-${PV}
"
PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,gui?]"

PATCHES=(
	"${FILESDIR}/avidemux-2.8.1_p20251019-cmake.patch"
	"${FILESDIR}/avidemux-2.8.1_p20251019-optional_sdl2.patch"
	"${FILESDIR}/avidemux-2.8.1_p20251019-qtengine.patch"
)

src_unpack() {
	default
	mv -f -T avidemux2_i18n-"${MY_COMMIT_LANG}" "${S}"/avidemux/qt4/i18n >/dev/null || die
}

src_prepare() {
	default

	TARGETDIRS=(
		buildCli:avidemux/cli
		$(usev gui buildQt4:avidemux/qt4)
	)

	local target
	for target in "${TARGETDIRS[@]}"; do
		CMAKE_USE_DIR="${S}/${target#*:}" cmake_prepare
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

	# Enable X11 only for now, wayland is not ready
	use gui && append-cppflags -DUSE_X11

	# buildCli / buildQt4
	local all_mycmakeargs=(
		-DVERBOSE=ON
		-DGETTEXT="$(usex nls)"
	)

	# buildCli
	local cli_mycmakeargs=(
		"${all_mycmakeargs[@]}"
	)

	# buildQt4
	local gui_mycmakeargs=(
		"${all_mycmakeargs[@]}"
		-DENABLE_QT4=OFF
		-DENABLE_QT5=OFF
		-DENABLE_QT6=True
		-DLRELEASE_EXECUTABLE="$(qt6_get_bindir)/lrelease"
		-DOPENGL="$(usex opengl)"
		-DSDL="$(usex sdl)"
		-DXVIDEO="$(usex xv)"
	)

	local target
	local mycmakeargs
	for target in "${TARGETDIRS[@]}" ; do
		case "${target%%:*}" in
			"buildCli")
				mycmakeargs=( "${cli_mycmakeargs[@]}" ) ;;
			"buildQt4")
				mycmakeargs=( "${gui_mycmakeargs[@]}" ) ;;
			*)
				die "target not available" ;;
		esac
		CMAKE_USE_DIR="${S}/${target#*:}" BUILD_DIR="${WORKDIR}/${P}_build/${target%%:*}" cmake_src_configure
	done
}

multi_targets() {
	local target
	for target in "${TARGETDIRS[@]}" ; do
		BUILD_DIR="${WORKDIR}/${P}_build/${target%%:*}" "${@}"
	done
}

src_compile() {
	multi_targets cmake_src_compile
}

src_install() {
	multi_targets cmake_src_install
}
