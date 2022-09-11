# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GCONF_DEBUG="no"

PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="sqlite"

ANTLR_VERSION=4.9.1

inherit gnome2 flag-o-matic python-single-r1 cmake

MY_P="${PN}-community-${PV}-src"

DESCRIPTION="MySQL Workbench"
HOMEPAGE="https://www.mysql.com/products/workbench/"
SRC_URI="https://cdn.mysql.com/Downloads/MySQLGUITools/${MY_P}.tar.gz
	https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# glibc: deprecated mutex functions, removed in 2.36.0
CDEPEND="${PYTHON_DEPS}
		app-crypt/libsecret
		dev-libs/glib:2
		dev-cpp/antlr-cpp:4
		dev-cpp/atkmm:*
		dev-cpp/pangomm:1.4
		>=dev-cpp/glibmm-2.14:2
		dev-cpp/gtkmm:3.0
		dev-libs/atk
		>=net-libs/libssh-0.8.5[server]
		x11-libs/pango
		x11-libs/gtk+:3
		gnome-base/libglade:2.0
		>=x11-libs/cairo-1.5.12[glib,svg]
		>=dev-libs/rapidjson-1.1.0
		dev-libs/libsigc++:2
		dev-libs/boost[nls]
		>=dev-cpp/ctemplate-0.95
		>=dev-libs/libxml2-2.6.2:2
		dev-libs/libzip
		dev-libs/libpcre[cxx]
		>=sci-libs/gdal-1.11.1-r1
		virtual/opengl
		|| ( sys-fs/e2fsprogs dev-libs/ossp-uuid )
		dev-libs/tinyxml[stl]
		>=dev-db/mysql-connector-c++-1.1.8 =dev-db/mysql-connector-c++-1*
		dev-db/vsqlite++
		|| ( dev-db/libiodbc dev-db/unixODBC )
		dev-python/pexpect
		>=dev-python/paramiko-1.7.4
"

RDEPEND="${CDEPEND}
		app-admin/sudo
		>=sys-apps/net-tools-1.60_p20120127084908"

DEPEND="${CDEPEND}
		dev-lang/swig
		virtual/jre
		virtual/pkgconfig"

S="${WORKDIR}"/"${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.5-wbcopytables.patch"
	"${FILESDIR}/${PN}-8.0.19-mysql-connector-8.patch"
)

src_unpack() {
	unpack ${PN}-community-${PV}-src.tar.gz
}

src_prepare() {
	## remove hardcoded CXXFLAGS
	sed -i -e 's/-O0 -g3//' ext/scintilla/gtk/CMakeLists.txt || die
	## And avoid -Werror
	sed -i -e 's/-Werror//' CMakeLists.txt || die
	## Fix doc install directory
	sed -i -e "/WB_INSTALL_DOC_DIR/ s/mysql-workbench/${P}/ ; /WB_INSTALL_DOC_DIR/ s/-community//" CMakeLists.txt || die

	## package is very fragile...
	strip-flags

	cmake_src_prepare
}

src_configure() {
	if has_version dev-db/libiodbc ; then
		IODBC="-DIODBC_CONFIG_PATH=/usr/bin/iodbc-config"
	fi

	append-cxxflags -std=c++11
	ANTLR_JAR_PATH="${DISTDIR}/antlr-${ANTLR_VERSION}-complete.jar"
	local mycmakeargs=(
		-DWITH_ANTLR_JAR=${ANTLR_JAR_PATH}
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DIODBC_INCLUDE_PATH="/usr/include/iodbc"
		${IODBC}
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DMySQL_CONFIG_PATH="/usr/bin/mysql_config"
	)
	cmake_src_configure
}
