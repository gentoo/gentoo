# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"

inherit cmake-utils l10n

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/${PN}"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.6"
IUSE="debug opengl nls nvenc qt4 qt5 sdl vaapi vdpau video_cards_fglrx xv"

if [[ ${PV} == *9999* ]] ; then
	MY_P="${P}"
	EGIT_REPO_URI="https://github.com/mean00/avidemux2.git"

	inherit git-r3
else
	MY_P="${PN}_${PV}"
	SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,video_cards_fglrx?,xv?,nvenc?]
	opengl? ( virtual/opengl:0 )
	qt4? ( >=dev-qt/qtgui-4.8.3:4 )
	qt5? ( dev-qt/qtgui:5 )
	vaapi? ( x11-libs/libva:0 )
	nvenc? ( amd64? ( media-video/nvidia_video_sdk:0 ) )
	video_cards_fglrx? (
		|| ( >=x11-drivers/ati-drivers-14.12-r3
			x11-libs/xvba-video:0 )
		)"
RDEPEND="
	$DEPEND
	nls? ( virtual/libintl:0 )
"
PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,qt4?,qt5?]"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	processes="buildCli:avidemux/cli"
	use qt4 && processes+=" buildQt4:avidemux/qt4"

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake-utils_src_prepare
	done

	# Fix icon name -> avidemux-2.6.png
	sed -i -e "/^Icon/ s:${PN}:${PN}-2.6:" ${PN}2.desktop || die "Icon name fix failed."

	# The desktop file is broken. It uses avidemux2 instead of avidemux3
	# so it will actually launch avidemux-2.5 if it is installed.
	sed -i -e "/^Exec/ s:${PN}2:${PN}3:" ${PN}2.desktop || die "Desktop file fix failed."
	sed -i -re '/^Exec/ s:(avidemux3_)gtk:\1qt'$(usex qt5 5 4)':' ${PN}2.desktop || die "Desktop file fix failed."

	# Fix QA warnings that complain a trailing ; is missing and Application is deprecated.
	sed -i -e 's/Application;AudioVideo/AudioVideo;/g' ${PN}2.desktop || die "Desktop file fix failed."

	# Now rename the desktop file to not collide with 2.5.
	mv ${PN}2.desktop ${PN}-2.6.desktop || die "Collision rename failed."

	# Remove "Build Option" dialog because it doesn't reflect what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/common/ADM_commonUI/myOwnMenu.h || die "Couldn't remove \"Build Option\" dialog."
}

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	local mycmakeargs=(
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLIBVA="$(usex vaapi)"
		-DVDPAU="$(usex vdpau)"
		-DXVBA="$(usex video_cards_fglrx)"
		-DXVIDEO="$(usex xv)"
	)

	if use qt5 ; then
		mycmakeargs+=( -DENABLE_QT5="$(usex qt5)" )
	fi

	if use debug ; then
		mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )
	fi

	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${build}" cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake-utils_src_compile
	done
}

src_test() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake-utils_src_test
	done
}

src_install() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake-utils_src_install
	done

	if [[ -f "${ED}"/usr/bin/avidemux3_cli ]] ; then
		fperms +x /usr/bin/avidemux3_cli
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs ]] ; then
		fperms +x /usr/bin/avidemux3_jobs
	fi

	cd "${S}" || die "Can't enter source folder."
	newicon ${PN}_icon.png ${PN}-2.6.png

	if [[ -f "${ED}"/usr/bin/avidemux3_qt4 ]] ; then
		fperms +x /usr/bin/avidemux3_qt4
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_qt5 ]] ; then
		fperms +x /usr/bin/avidemux3_qt5
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs_qt5 ]] ; then
		fperms +x /usr/bin/avidemux3_jobs_qt5
	fi

	if use qt4 || use qt5 ; then
		domenu ${PN}-2.6.desktop
	fi
}
