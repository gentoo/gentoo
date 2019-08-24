# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Build is broken with ninja
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-multilib flag-o-matic versionator

MAJOR="$(get_version_component_range 1-2 $PV)"
MY_PN="mysql-connector-odbc"
MY_P="${MY_PN}-${PV/_p/r}-src"

DESCRIPTION="ODBC driver for MySQL"
HOMEPAGE="http://www.mysql.com/products/myodbc/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-ODBC/${MAJOR}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="${MAJOR}"
KEYWORDS="amd64 ppc x86"
IUSE=""

# Does not build with libmariadb
RDEPEND="
	dev-db/unixODBC[${MULTILIB_USEDEP}]
	<dev-db/mysql-connector-c-8.0:0=[${MULTILIB_USEDEP}]
	!>=dev-db/mariadb-10.2.0[client-libs(+)]
	!dev-db/mariadb-connector-c[mysqlcompat(-)]
"
DEPEND="${RDEPEND}"
S=${WORKDIR}/${MY_P}

# Careful!
DRIVER_NAME="${PN}-${SLOT}"

# Patch document path so it doesn't install files to /usr
PATCHES=(
	"${FILESDIR}/${MAJOR}-cmake-doc-path.patch"
	"${FILESDIR}/5.3.10-cxxlinkage.patch"
	"${FILESDIR}/5.3.10-mariadb.patch"
)

src_prepare() {
	# Remove Tests
	sed -i -e "s/ADD_SUBDIRECTORY(test)//" \
		"${S}/CMakeLists.txt"

	# Fix as-needed on the installer binary
#	echo "TARGET_LINK_LIBRARIES(myodbc-installer odbc)" >> "${S}/installer/CMakeLists.txt"

	cmake-utils_src_prepare
}

multilib_src_configure() {
	# MYSQL_CXX_LINKAGE expects "mysql_config --cxxflags" which doesn't exist on MariaDB
	mycmakeargs+=(
		-DMYSQL_CXX_LINKAGE=0
		-DWITH_UNIXODBC=1
		-DWITH_DOCUMENTATION_INSTALL_PATH=/usr/share/doc/${PF}
		-DMYSQL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DLIB_SUBDIR="$(get_libdir)/${PN}-${MAJOR}"
		-DMYSQL_INCLUDE_DIR="$(mysql_config --variable=pkgincludedir)"
		-DMYSQLCLIENT_NO_THREADS=ON
		-DDISABLE_GUI=ON
		# The NUMA and LIBWRAP options are not really used.
		# They are just copied from the server code
		-DWITH_NUMA=OFF
		-DWITH_LIBWRAP=OFF
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	debug-print-function ${FUNCNAME} "$@"

	dodir /usr/share/${PN}-${SLOT}
	for i in odbc.ini odbcinst.ini; do
		einfo "Building $i"
			sed \
			-e "s,__PN__,${DRIVER_NAME},g" \
			-e "s,__PF__,${MAJOR},g" \
			-e "s,lib/libmyodbc3.so,$(get_libdir)/${PN}-${MAJOR}/libmyodbc${SLOT:0:1}a.so,g" \
			>"${D}"/usr/share/${PN}-${SLOT}/${i} \
			<"${FILESDIR}"/${i}.m4 \
			|| die "Failed to build $i"
	done;
	mv "${D}/usr/bin/myodbc-installer" \
		"${D}/usr/bin/myodbc-installer-${MAJOR}" || die "failed to move slotted binary"
}

pkg_config() {

	[ "${ROOT}" != "/" ] && \
		die 'Sorry, non-standard ROOT setting is not supported :-('

	local msg='MySQL ODBC driver'
	local drivers=$(/usr/bin/odbcinst -q -d)

	if echo $drivers | grep -vq "^\[${DRIVER_NAME}\]$" ; then
		ebegin "Installing ${msg}"
		/usr/bin/odbcinst -i -d -f /usr/share/${PN}-${SLOT}/odbcinst.ini
		rc=$?
		eend $rc
		[ $rc -ne 0 ] && die
	else
		einfo "Skipping already installed ${msg}"
	fi

	local sources=$(/usr/bin/odbcinst -q -s)
	msg='sample MySQL ODBC DSN'
	if echo $sources | grep -vq "^\[${DRIVER_NAME}-test\]$"; then
		ebegin "Installing ${msg}"
		/usr/bin/odbcinst -i -s -l -f /usr/share/${PN}-${SLOT}/odbc.ini
		rc=$?
		eend $rc
		[ $rc -ne 0 ] && die
	else
		einfo "Skipping already installed ${msg}"
	fi
}

pkg_postinst() {

	elog "If this is a new install, please run the following command"
	elog "to configure the MySQL ODBC drivers and sources:"
	elog "emerge --config =${CATEGORY}/${PF}"
	elog "Please note that the driver name used to form the DSN now includes the SLOT."
	elog "The myodbc-install utility is installed as myodbc-install-${MAJOR}"
}
