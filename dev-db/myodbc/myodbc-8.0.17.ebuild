# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

MAJOR="$(ver_cut 1-2)"
MY_PN="mysql-connector-odbc"
MY_P="${MY_PN}-${PV/_p/r}-src"

DESCRIPTION="ODBC driver for MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/odbc/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-ODBC/${MAJOR}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="${MAJOR}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

# Broken when built dynamically against libmysqlclient.so
RDEPEND="
	dev-db/unixODBC[${MULTILIB_USEDEP}]
	>=dev-db/mysql-connector-c-8.0:0=[static-libs,${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
S=${WORKDIR}/${MY_P}

# Careful!
DRIVER_NAME="${PN}-${SLOT}"

# Patch document path so it doesn't install files to /usr
PATCHES=(
	"${FILESDIR}/${MAJOR}-cmake-doc-path.patch"
	"${FILESDIR}/8.0.16-cxxlinkage.patch"
)

src_prepare() {
	# Remove Tests
	sed -i -e "s/ADD_SUBDIRECTORY(test)//" \
		"${S}/CMakeLists.txt"

	cmake-utils_src_prepare
}

multilib_src_configure() {
	mycmakeargs+=(
		-DMYSQLCLIENT_STATIC_LINKING=1
		-DMYSQL_CXX_LINKAGE=1
		-DWITH_UNIXODBC=1
		-DWITH_DOCUMENTATION_INSTALL_PATH=/usr/share/doc/${PF}
		-DLIB_SUBDIR="$(get_libdir)/${PN}-${MAJOR}"
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
