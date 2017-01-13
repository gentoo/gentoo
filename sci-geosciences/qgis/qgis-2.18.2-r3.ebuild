# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils fdo-mime gnome2-utils cmake-utils python-single-r1

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="
	http://qgis.org/downloads/qgis-${PV}.tar.bz2
	examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples georeferencer grass mapserver oracle postgres python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	mapserver? ( python )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/expat
	sci-geosciences/gpsbabel
	>=sci-libs/gdal-1.6.1:=[geos,oracle?,python?,${PYTHON_USEDEP}]
	sci-libs/geos
	sci-libs/libspatialindex:=
	sci-libs/proj
	dev-libs/qjson
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	x11-libs/qscintilla:=[qt4(-)]
	|| (
		( || ( <x11-libs/qwt-6.1.2:6[svg] >=x11-libs/qwt-6.1.2:6[svg,qt4] ) >=x11-libs/qwtpolar-1 )
		( x11-libs/qwt:5[svg] <x11-libs/qwtpolar-1 )
	)
	georeferencer? ( sci-libs/gsl:= )
	grass? ( || ( >=sci-geosciences/grass-7.0.0:= ) )
	mapserver? ( dev-libs/fcgi )
	oracle? ( dev-db/oracle-instantclient:= )
	postgres? ( dev-db/postgresql:= )
	python? (
		dev-python/PyQt4[X,sql,svg,webkit,${PYTHON_USEDEP}]
		<dev-python/sip-4.19:=[${PYTHON_USEDEP}]
		dev-python/qscintilla-python[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		${PYTHON_DEPS}
	)
	dev-db/sqlite:3
	>=dev-db/spatialite-4.1.0
	app-crypt/qca:2[qt4,ssl]
"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	cd src/plugins || die
	use georeferencer || cmake_comment_add_subdirectory "georeferencer"
}

src_configure() {
	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=/share/man/
		-DBUILD_SHARED_LIBS=ON
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis
		-DWITH_INTERNAL_DATEUTIL=OFF
		-DWITH_INTERNAL_HTTPLIB2=OFF
		-DWITH_INTERNAL_JINJA2=OFF
		-DWITH_INTERNAL_MARKUPSAFE=OFF
		-DWITH_INTERNAL_PYGMENTS=OFF
		-DWITH_INTERNAL_PYTZ=OFF
		-DWITH_INTERNAL_QWTPOLAR=OFF
		-DWITH_INTERNAL_SIX=OFF
		-DPEDANTIC=OFF
		-DWITH_APIDOC=OFF
		-DWITH_QSPATIALITE=ON
		-DENABLE_TESTS=OFF
		-DWITH_BINDINGS="$(usex python)"
		-DWITH_GRASS7="$(usex grass)"
		$(usex grass "-DGRASS_PREFIX=/usr/" "")
		-DWITH_ORACLE="$(usex oracle)"
		-DWITH_POSTGRESQL="$(usex postgres)"
		-DWITH_PYSPATIALITE="$(usex python)"
		-DWITH_SERVER="$(usex mapserver)"
	)

	if has_version '>=x11-libs/qwtpolar-1' &&  has_version 'x11-libs/qwt:5' ; then
		elog "Both >=x11-libs/qwtpolar-1 and x11-libs/qwt:5 installed. Force build with qwt6"
		mycmakeargs+=( "-DQWT_INCLUDE_DIR=/usr/include/qwt6" )
		if has_version '>=x11-libs/qwt-6.1.2' ; then
			mycmakeargs+=( "-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt4.so" )
		else
			mycmakeargs+=( "-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6.so" )
		fi
	fi

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
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r "${WORKDIR}"/qgis_sample_data/.
	fi

	python_optimize "${D}"/usr/share/qgis/python

	if use grass; then
		python_fix_shebang "${D}"/usr/share/qgis/grass/scripts
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
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
