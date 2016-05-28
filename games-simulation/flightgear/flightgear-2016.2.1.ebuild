# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils bash-completion-r1

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="mirror://sourceforge/flightgear/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus debug examples qt5 test +udev +utils vim-syntax"

COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.2.0[png]
	~dev-games/simgear-${PV}
	media-libs/openal
	media-libs/speex
	media-sound/gsm
	sys-libs/zlib
	x11-libs/libX11
	dbus? ( >=sys-apps/dbus-1.6.18-r1 )
	qt5? (
		>=dev-qt/qtcore-5.4.1:5
		>=dev-qt/qtgui-5.4.1:5
		>=dev-qt/qtwidgets-5.4.1:5
	)
	udev? ( virtual/udev )
	utils? (
		media-libs/freeglut
		media-libs/libpng:0
		virtual/opengl
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.44
	>=media-libs/plib-1.8.5
"
RDEPEND="${COMMON_DEPEND}
	~games-simulation/${PN}-data-${PV}
"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DENABLE_FGCOM=$(usex utils)
		-DENABLE_FGELEV=$(usex utils)
		-DENABLE_FGJS=$(usex utils)
		-DENABLE_FGVIEWER=$(usex utils)
		-DENABLE_FLITE=OFF
		-DENABLE_GPSSMOOTH=$(usex utils)
		-DENABLE_JS_DEMO=$(usex utils)
		-DENABLE_JSBSIM=ON
		-DENABLE_LARCSIM=ON
		-DENABLE_LOGGING=$(usex test)
		-DENABLE_METAR=$(usex utils)
		-DENABLE_PROFILE=OFF
		-DENABLE_QT=$(usex qt5)
		-DENABLE_RTI=OFF
		-DENABLE_TERRASYNC=$(usex utils)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_UIUC_MODEL=ON
		-DENABLE_YASIM=ON
		-DEVENT_INPUT=$(usex udev)
		-DFG_DATA_DIR=/usr/share/${PN}
		-DJSBSIM_TERRAIN=ON
		-DSIMGEAR_SHARED=ON
		-DSP_FDMS=ON
		-DSYSTEM_FLITE=ON
		-DSYSTEM_HTS_ENGINE=ON
		-DSYSTEM_SPEEX=ON
		-DSYSTEM_GSM=ON
		-DSYSTEM_SQLITE=ON
		-DUSE_DBUS=$(usex dbus)
		-DWITH_FGPANEL=$(usex utils)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Install icons and menu entry
	local s
	for s in 16 22 24 32 48 64 128; do
		doicon -s ${s} icons/${s}x${s}/apps/${PN}.png
		use utils && doicon -s ${s} icons/${s}x${s}/apps/fgcom.png
	done
	doicon -s scalable icons/scalable/${PN}.svg
	use utils && doicon -s scalable icons/scalable/fgcom.svg

	newmenu package/${PN}.desktop ${PN}.desktop

	# Install bash completion (TODO zsh)
	# Uncomment below when scripts stops writing files...
#	sed -e "s|/usr/local/share/FlightGear|${GAMES_DATADIR}/${PN}|" \
#		-i scripts/completion/fg-completion.bash || die 'unable to replace FG_ROOT'
#	newbashcomp scripts/completion/fg-completion.bash ${PN}

	# Install examples and other misc files
	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins -r scripts/java scripts/perl scripts/python
		insinto /usr/share/doc/"${PF}"/examples/c++
		doins -r scripts/example/*
		insinto /usr/share/doc/"${PF}"/tools
		doins -r scripts/atis scripts/tools/*
	fi

	# Install nasal script syntax
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/syntax/{ac3d,nasal}.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}"/{ac3d,nasal}.vim
	fi
}

pkg_postinst() {
	einfo "Please note that data files location changed to /usr/share/flightgear"
	if use qt5; then
		einfo "To use launcher, run fgfs with '--launcher' parameter"
	fi
}
