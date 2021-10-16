# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ library for developing web applications"
HOMEPAGE="https://www.webtoolkit.eu/wt https://github.com/emweb/wt"
LICENSE="GPL-2"
SLOT="0"

IUSE="dbo fastcgi firebird graphicsmagick haru mariadb mysql odbc opengl pango postgres qt5 sqlite ssl test unwind zlib"
REQUIRED_USE="
	dbo? ( || ( firebird mariadb mysql postgres sqlite ) )
	opengl? ( graphicsmagick )
"
RESTRICT="!test? ( test )"

if [[ ${PV} == *9999 ]] ; then
    EGIT_REPO_URI="https://github.com/emweb/wt.git"
    EGIT_SUBMODULES=()
    inherit git-r3
else
    SRC_URI="https://github.com/emweb/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

RDEPEND="
	>=dev-libs/boost-1.50.0
	fastcgi? ( dev-libs/fcgi )
	firebird? ( dev-db/firebird )
	graphicsmagick? ( media-gfx/graphicsmagick )
	haru? ( media-libs/libharu )
	mariadb? ( dev-db/mariadb-connector-c )
	mysql? ( dev-db/mysql-connector-c )
	odbc? ( dev-db/unixODBC )
	opengl? (
		x11-libs/libX11
		media-libs/glew:0
		virtual/opengl
	)
	pango? ( x11-libs/pango )
	postgres? ( dev-db/postgresql:* )
	qt5? ( dev-qt/qtcore:5 )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	unwind? ( sys-libs/libunwind )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user

	# Remove postinstall script
	echo "" > WtInstall.cmake

	# Replace lib/ with the correct libdir
	sed -i "s/LIB_INSTALL_DIR \"lib\"/LIB_INSTALL_DIR \"$(get_libdir)\"/g" CMakeLists.txt || die "Could not set correct install dir"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(use graphicsmagick && echo -DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick)
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_CXX_STANDARD=17
		-DCONNECTOR_FCGI=$(usex fastcgi)
		-DENABLE_FIREBIRD=$(usex firebird)
		-DENABLE_HARU=$(usex haru)
		-DENABLE_MYSQL=$(usex mysql)
		-DENABLE_LIBWTDBO=$(usex dbo)
		-DENABLE_MSSQLSERVER=$(usex odbc)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_PANGO=$(usex pango)
		-DENABLE_POSTGRES=$(usex postgres)
		-DENABLE_QT4=OFF
		-DENABLE_QT5=$(usex qt5)
		-DENABLE_SQLITE=$(usex sqlite)
		-DENABLE_SSL=$(usex ssl)
		-DENABLE_UNWIND=$(usex unwind)
		$(cmake_use_find_package zlib ZLIB)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
