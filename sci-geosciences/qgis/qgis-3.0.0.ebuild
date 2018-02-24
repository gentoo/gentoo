# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )
PYTHON_REQ_USE="sqlite"
QT_MIN_VER="5.9.1"

if [[ ${PV} != *9999 ]]; then
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
fi
inherit cmake-utils eutils ${GIT_ECLASS} gnome2-utils python-single-r1 qmake-utils xdg-utils
unset GIT_ECLASS

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="designer examples georeferencer grass mapserver oracle polar postgres python webkit"

REQUIRED_USE="
	mapserver? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	app-crypt/qca:2[qt5(+),ssl]
	>=dev-db/spatialite-4.2.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/libzip:=
	dev-libs/qtkeychain[qt5(+)]
	>=dev-qt/qtconcurrent-${QT_MIN_VER}:5
	>=dev-qt/qtcore-${QT_MIN_VER}:5
	>=dev-qt/qtgui-${QT_MIN_VER}:5
	>=dev-qt/qtnetwork-${QT_MIN_VER}:5
	>=dev-qt/qtpositioning-${QT_MIN_VER}:5
	>=dev-qt/qtprintsupport-${QT_MIN_VER}:5
	>=dev-qt/qtsvg-${QT_MIN_VER}:5
	>=dev-qt/qtsql-${QT_MIN_VER}:5
	>=dev-qt/qtwidgets-${QT_MIN_VER}:5
	>=dev-qt/qtxml-${QT_MIN_VER}:5
	>=sci-libs/gdal-2.2.3:=[geos,python?,${PYTHON_USEDEP}]
	sci-libs/geos
	sci-libs/libspatialindex:=
	sci-libs/proj
	>=x11-libs/qscintilla-2.10.1:=[qt5(+)]
	>=x11-libs/qwt-6.1.2:6=[qt5(+),svg]
	designer? ( >=dev-qt/designer-${QT_MIN_VER}:5 )
	georeferencer? ( sci-libs/gsl:= )
	grass? ( >=sci-geosciences/grass-7.0.0:= )
	mapserver? ( dev-libs/fcgi )
	oracle? (
		dev-db/oracle-instantclient:=
		sci-libs/gdal:=[oracle]
	)
	polar? ( >=x11-libs/qwtpolar-1.1.1-r1[qt5(+)] )
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS}
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
		dev-python/owslib[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/PyQt5[sql,svg,webkit?,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/qscintilla-python-2.10.1[qt5(+),${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	)
	webkit? ( >=dev-qt/qtwebkit-${QT_MIN_VER}:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/linguist-tools-${QT_MIN_VER}:5
	>=dev-qt/qttest-${QT_MIN_VER}:5
	>=dev-qt/qtxmlpatterns-${QT_MIN_VER}:5
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

PATCHES=(
	# git master
	"${FILESDIR}/${PN}-2.18.12-cmake-lib-suffix.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s:\${QT_BINARY_DIR}:$(qt5_get_bindir):" \
		-i CMakeLists.txt || die "Failed to fix lrelease path"

	sed -e "/QT_LRELEASE_EXECUTABLE/d" \
		-e "/QT_LUPDATE_EXECUTABLE/s/set/find_program/" \
		-e "s:lupdate-qt5:NAMES lupdate PATHS $(qt5_get_bindir) NO_DEFAULT_PATH:" \
		-i cmake/modules/ECMQt4To5Porting.cmake || die "Failed to fix ECMQt4To5Porting.cmake"

	cd src/plugins || die
}

src_configure() {
	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=/share/man/
		-DBUILD_SHARED_LIBS=ON
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
		-DPEDANTIC=OFF
		-DWITH_APIDOC=OFF
		-DWITH_QSPATIALITE=ON
		-DENABLE_TESTS=OFF
		-DWITH_CUSTOM_WIDGETS=$(usex designer)
		-DWITH_GEOREFERENCER=$(usex georeferencer)
		-DWITH_GRASS=$(usex grass)
		-DWITH_SERVER=$(usex mapserver)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_QWTPOLAR=$(usex polar)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_QTWEBKIT=$(usex webkit)
	)

	if use grass; then
		mycmakeargs+=(
			-DWITH_GRASS7=ON
			-DGRASS_PREFIX7=/usr/$(get_libdir)/grass70
		)
	fi

	use python && mycmakeargs+=( -DBINDINGS_GLOBAL_INSTALL=ON )

	# bug 612956
	addpredict /dev/dri/renderD128

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	domenu debian/qgis.desktop

	local size type
	for size in 16 22 24 32 48 64 96 128 256; do
		newicon -s ${size} debian/icons/${PN}-icon${size}x${size}.png ${PN}.png
		newicon -c mimetypes -s ${size} debian/icons/${PN}-mime-icon${size}x${size}.png ${PN}-mime.png
		for type in qgs qml qlr qpt; do
			newicon -c mimetypes -s ${size} debian/icons/${PN}-${type}${size}x${size}.png ${PN}-${type}.png
		done
	done
	newicon -s scalable images/icons/qgis_icon.svg qgis.svg

	insinto /usr/share/mime/packages
	doins debian/qgis.xml

	if use examples; then
		docinto examples
		dodoc -r "${WORKDIR}"/qgis_sample_data/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	python_optimize "${ED%/}"/usr/share/qgis/python

	if use grass; then
		python_fix_shebang "${ED%/}"/usr/share/qgis/grass/scripts
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	elif use python; then
		elog "Support of PostgreSQL is disabled."
		elog "But some installed python-plugins import the psycopg2 module."
		elog "If you do not need these plugins just disable them"
		elog "in the Plugins menu, else you need to set USE=\"postgres\""
	fi

	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
