# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="no"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit gnome2 eutils flag-o-matic python-single-r1 cmake-utils

MY_P="${PN}-community-${PV}-src"

DESCRIPTION="MySQL Workbench"
HOMEPAGE="http://dev.mysql.com/workbench/"
SRC_URI="mirror://mysql/Downloads/MySQLGUITools/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc gnome-keyring"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# glibc: deprecated mutex functions, removed in 2.36.0
CDEPEND="${PYTHON_DEPS}
		dev-libs/glib:2
		dev-cpp/atkmm
		dev-cpp/pangomm
		>=dev-cpp/glibmm-2.14:2
		>=dev-cpp/gtkmm-2.14:2.4
		dev-libs/atk
		x11-libs/pango
		>=x11-libs/gtk+-2.20:2
		gnome-base/libglade:2.0
		>=x11-libs/cairo-1.5.12[glib,svg]
		dev-libs/libsigc++:2
		>=dev-libs/boost-1.55.0[nls]
		>=dev-cpp/ctemplate-0.95
		>=dev-libs/libxml2-2.6.2:2
		dev-libs/libzip
		>=virtual/mysql-5.1
		dev-libs/libpcre[cxx]
		>=sci-libs/gdal-1.11.1-r1[-mdb]
		virtual/opengl
		>=dev-lang/lua-5.1:0[deprecated]
		|| ( sys-libs/e2fsprogs-libs dev-libs/ossp-uuid )
		dev-libs/tinyxml[stl]
		dev-db/mysql-connector-c++
		dev-db/vsqlite++
		|| ( dev-db/libiodbc dev-db/unixODBC )
		gnome-keyring? ( gnome-base/libgnome-keyring )
			dev-python/pexpect
			>=dev-python/paramiko-1.7.4
	"

# lua perhaps no longer needed? Was used via libgrt only

RDEPEND="${CDEPEND}
		app-admin/sudo
		>=sys-apps/net-tools-1.60_p20120127084908"

DEPEND="${CDEPEND}
		dev-lang/swig
		virtual/pkgconfig"

S="${WORKDIR}"/"${MY_P}"

src_unpack() {
	unpack ${PN}-community-${PV}-src.tar.gz
}

src_prepare() {
	## Patch CMakeLists.txt
	epatch "${FILESDIR}/${PN}-6.2.3-CMakeLists.patch" \
		"${FILESDIR}/${PN}-6.2.5-wbcopytables.patch" \
		"${FILESDIR}/${PN}-6.3.3-mysql_options4.patch" \
		"${FILESDIR}/${PN}-6.3.4-cxx11.patch" \
		"${FILESDIR}/${PN}-6.3.4-gtk.patch"

	sed -i -e '/target_link_libraries/ s/sqlparser.grt/sqlparser.grt sqlparser/' \
		modules/db.mysql.sqlparser/CMakeLists.txt

	## remove hardcoded CXXFLAGS
	sed -i -e 's/-O0 -g3//' ext/scintilla/gtk/CMakeLists.txt || die

	## package is very fragile...
	strip-flags

	cmake-utils_src_prepare
}

src_configure() {
	append-cxxflags -std=c++11
	local mycmakeargs=(
		$(cmake-utils_use_use gnome-keyring GNOME_KEYRING)
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake-utils_src_configure
}

src_compile() {
	# Work around parallel build issues, bug 507838
	cmake-utils_src_compile -j1
}
