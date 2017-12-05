# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit cmake-utils eutils gnome2-utils python-single-r1 qmake-utils xdg-utils

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"
SRC_URI="
	https://qgis.org/downloads/qgis-${PV}.tar.bz2
	examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples georeferencer grass mapserver oracle postgres python"

REQUIRED_USE="
	mapserver? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	app-crypt/qca:2[qt4,ssl]
	>=dev-db/spatialite-4.1.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/qjson
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	sci-libs/gdal:=[geos,python?,${PYTHON_USEDEP}]
	sci-libs/geos
	sci-libs/libspatialindex:=
	sci-libs/proj
	x11-libs/qscintilla:=[qt4(-)]
	>=x11-libs/qwt-6.1.2:6=[svg,qt4(-)]
	>=x11-libs/qwtpolar-1[qt4(-)]
	georeferencer? ( sci-libs/gsl:= )
	grass? ( >=sci-geosciences/grass-7.0.0:= )
	mapserver? ( dev-libs/fcgi )
	oracle? (
		dev-db/oracle-instantclient:=
		sci-libs/gdal:=[oracle]
	)
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS}
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/PyQt4[X,sql,svg,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/qscintilla-python[qt4(+),${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

PATCHES=(
	# TODO upstream
	"${FILESDIR}/${PN}-2.18.6-featuresummary.patch"
	# Taken from redhat
	"${FILESDIR}/${PN}-2.18.12-sip.patch"
	# git master
	"${FILESDIR}/${PN}-2.18.12-cmake-lib-suffix.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e "s:\${QT_BINARY_DIR}:$(qt4_get_bindir):" \
		CMakeLists.txt || die "Failed to fix lrelease path"

	cd src/plugins || die
	use georeferencer || cmake_comment_add_subdirectory georeferencer
}

src_configure() {
	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=/share/man/
		-DBUILD_SHARED_LIBS=ON
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt4.so
		-DWITH_INTERNAL_QWTPOLAR=OFF
		-DPEDANTIC=OFF
		-DWITH_APIDOC=OFF
		-DWITH_QSPATIALITE=ON
		-DENABLE_TESTS=OFF
		-DWITH_GRASS=$(usex grass)
		-DWITH_SERVER=$(usex mapserver)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_QTWEBKIT=OFF
	)

	if has_version '<x11-libs/qscintilla-2.10'; then
		mycmakeargs+=(
			-DQSCINTILLA_LIBRARY=/usr/$(get_libdir)/qt4/libqscintilla2.so
		)
	fi

	if use grass; then
		mycmakeargs+=(
			-DWITH_GRASS7=ON
			-DGRASS_PREFIX7=/usr/$(get_libdir)/grass70
		)
	fi

	if use python; then
		mycmakeargs+=(
			-DBINDINGS_GLOBAL_INSTALL=ON
			-DWITH_PYSPATIALITE=ON
			-DWITH_INTERNAL_DATEUTIL=OFF
			-DWITH_INTERNAL_FUTURE=OFF
			-DWITH_INTERNAL_MARKUPSAFE=OFF
			-DWITH_INTERNAL_PYTZ=OFF
			-DWITH_INTERNAL_SIX=OFF
			-DWITH_INTERNAL_YAML=OFF
		)
	fi

	# bug 612956
	addpredict /dev/dri/renderD128

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	domenu debian/qgis.desktop

	local size type
	for size in 16 22 24 32 48 64 96 128 256; do
		newicon -s ${size} debian/${PN}-icon${size}x${size}.png ${PN}.png
		newicon -c mimetypes -s ${size} debian/${PN}-mime-icon${size}x${size}.png ${PN}-mime.png
		for type in qgs qml qlr qpt; do
			newicon -c mimetypes -s ${size} debian/${PN}-${type}${size}x${size}.png ${PN}-${type}.png
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

pkg_preinst() {
	gnome2_icon_savelist
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
