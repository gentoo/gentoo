# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit multilib-minimal versionator

MAJOR="$(get_version_component_range 1-2 $PV)"
MY_PN="mysql-connector-odbc"
MY_P="${MY_PN}-${PV/_p/r}-linux-debian9-x86"

DESCRIPTION="ODBC driver for MySQL"
HOMEPAGE="http://www.mysql.com/products/myodbc/"
BASE_URI="https://cdn.mysql.com/Downloads/Connector-ODBC/${MAJOR}/${MY_P}"
#https://cdn.mysql.com//Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.8-linux-debian8-x86-64bit.tar.gz
SRC_URI="amd64? ( ${BASE_URI}-64bit.tar.gz abi_x86_32? ( ${BASE_URI}-32bit.tar.gz ) )
	x86? ( ${BASE_URI}-32bit.tar.gz )"

LICENSE="GPL-2"
SLOT="${MAJOR}"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-db/unixODBC[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]"
S=${WORKDIR}

#src_configure(){ :; }

src_compile(){ :; }

multilib_src_install() {
	cd "${S}" || die
	local prefix
	if use amd64 && multilib_is_native_abi ; then
		prefix="${MY_P}-64bit"
	else
		prefix="${MY_P}-32bit"
	fi
	exeinto /usr/$(get_libdir)/${PN}-${MAJOR}
	doexe ${prefix}/lib/libmyodbc5a.so ${prefix}/lib/libmyodbc5w.so
#	use gtk && doexe ${prefix}/lib/libmyodbc5S.so
}

multilib_src_install_all() {
	local DRIVER_NAME="${PN}-${SLOT}"
	local prefix
	if use amd64 ; then
		prefix="${MY_P}-64bit"
	else
		prefix="${MY_P}-32bit"
	fi
	exeinto /usr/bin
	newexe "${prefix}/bin/myodbc-installer" myodbc-installer-${MAJOR}

	dodir /usr/share/${PN}-${SLOT}
	for i in odbc.ini odbcinst.ini; do
		einfo "Building $i"
			sed \
			-e "s,__PN__,${DRIVER_NAME},g" \
			-e "s,__PF__,${MAJOR},g" \
			-e "s,libmyodbc3.so,libmyodbc${SLOT:0:1}a.so,g" \
			-e "s,lib/libmyodbc,$(get_libdir)/${DRIVER_NAME}/libmyodbc,g" \
			>"${D}/usr/share/${DRIVER_NAME}/${i}" \
			<"${FILESDIR}"/${i}.m4 \
			|| die "Failed to build $i"
	done;

	dodoc ${prefix}/{ChangeLog,INSTALL,README,Licenses_for_Third-Party_Components.txt}
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
