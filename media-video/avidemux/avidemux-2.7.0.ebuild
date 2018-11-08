# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]] ; then
	MY_P="${P}"
	EGIT_REPO_URI="https://github.com/mean00/avidemux2.git"
	inherit git-r3
else
	MY_P="${PN}_${PV}"
	SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils qmake-utils xdg-utils

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.7"
IUSE="debug nls nvenc opengl qt5 sdl vaapi vdpau xv"

COMMON_DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,xv?,nvenc?]
	nvenc? ( amd64? ( media-video/nvidia_video_sdk:0 ) )
	opengl? ( virtual/opengl:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
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

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply "${FILESDIR}/${P}-glibc-2.27.patch"
	eapply "${FILESDIR}/${P}-qt-5.11.patch"

	processes="buildCli:avidemux/cli"
	if use qt5 ; then
		processes+=" buildQt4:avidemux/qt4"
	fi

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake-utils_src_prepare
	done

	# Fix icon name -> avidemux-2.7.png
	sed -i -e "/^Icon/ s:${PN}:${PN}-${SLOT}:" ${PN}2.desktop || \
		die "Icon name fix failed."

	# The desktop file is broken. It uses avidemux2 instead of avidemux3
	# so it will actually launch avidemux-2.7 if it is installed.
	sed -i -e "/^Exec/ s:${PN}2:${PN}3:" ${PN}2.desktop || \
		die "Desktop file fix failed."
	if use qt5; then
		sed -i -re '/^Exec/ s:(avidemux3_)gtk:\1qt5:' ${PN}2.desktop || \
			die "Desktop file fix failed."
	fi

	# QA warnings: missing trailing ';' and 'Application' is deprecated.
	sed -i -e 's/Application;AudioVideo/AudioVideo;/g' ${PN}2.desktop || \
		die "Desktop file fix failed."

	# Now rename the desktop file to not collide with 2.6.
	mv ${PN}2.desktop ${PN}-${SLOT}.desktop || die "Collision rename failed."

	# Remove "Build Option" dialog because it doesn't reflect
	# what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/common/ADM_commonUI/myOwnMenu.h || \
		die "Couldn't remove \"Build Option\" dialog."
}

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	# The build relies on an avidemux-core header that uses 'nullptr'
	# which is from >=C++11. Let's use the GCC-6 default C++ dialect.
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLibVA="$(usex vaapi)"
		-DVDPAU="$(usex vdpau)"
		-DXVIDEO="$(usex xv)"
	)

	if use qt5 ; then
		mycmakeargs+=(
			-DENABLE_QT5="$(usex qt5)"
			-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
		)
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
	newicon ${PN}_icon.png ${PN}-${SLOT}.png

	if [[ -f "${ED}"/usr/bin/avidemux3_qt5 ]] ; then
		fperms +x /usr/bin/avidemux3_qt5
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs_qt5 ]] ; then
		fperms +x /usr/bin/avidemux3_jobs_qt5
	fi

	if use qt5 ; then
		domenu ${PN}-${SLOT}.desktop
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
