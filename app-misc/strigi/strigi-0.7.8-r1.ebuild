# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="http://www.vandenoever.info/software/strigi/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/strigi" )
	GIT_ECLASS="git-r3"
	KEYWORDS=""
fi

inherit cmake-utils ${GIT_ECLASS}

DESCRIPTION="Fast crawling desktop search engine with Qt4 GUI"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/strigi/strigi"

LICENSE="GPL-2"
SLOT="0"
IUSE="clucene +dbus debug exif fam ffmpeg +inotify libav log +qt4 test"

RDEPEND="
	app-arch/bzip2
	dev-libs/libxml2:2
	sys-libs/zlib
	virtual/libiconv
	clucene? ( >=dev-cpp/clucene-0.9.21[-debug] )
	dbus? (
		sys-apps/dbus
		qt4? ( dev-qt/qtdbus:4 )
	)
	exif? ( media-gfx/exiv2:= )
	fam? ( virtual/fam )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	log? ( >=dev-libs/log4cxx-0.10.0 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.8.patch"
	"${FILESDIR}/${P}-libav10.patch"
)

if [[ ${PV} == 9999 ]] ; then
	src_unpack() {
		git config --global url."git://anongit.kde.org/".insteadOf "kde:" || die
		git-r3_src_unpack
		pushd "${S}" > /dev/null || die
		git submodule foreach git checkout master || die
		popd > /dev/null || die
	}
fi

src_configure() {
	# Enabled: POLLING (only reliable way to check for files changed.)
	# Disabled: xine - recommended upstream to keep it this way
	local mycmakeargs=(
		-DENABLE_POLLING=ON
		-DFORCE_DEPS=ON
		-DENABLE_REGENERATEXSD=OFF
		-DENABLE_XINE=OFF
		$(cmake-utils_use_enable clucene CLUCENE)
		$(cmake-utils_use_enable clucene CLUCENE_NG)
		$(cmake-utils_use_enable dbus)
		$(cmake-utils_use_enable exif EXIV2)
		$(cmake-utils_use_enable fam)
		$(cmake-utils_use_enable ffmpeg)
		$(cmake-utils_use_enable inotify)
		$(cmake-utils_use_enable log LOG4CXX)
		$(cmake-utils_use_enable qt4)
		$(cmake-utils_use_find_package test CPPUNIT)
	)

	if use qt4; then
		mycmakeargs+=( -DENABLE_DBUS=ON )
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	if ! use clucene ; then
		elog "Because you didn't enable the clucene backend, strigi may not be functional."
		elog "If you intend to use standalone strigi indexer (not needed for KDE),"
		elog "be sure to reinstall app-misc/strigi with the clucene USE flag enabled."
	fi
}
