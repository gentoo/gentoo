# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 eutils user systemd

MY_PN="Radicale"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="https://radicale.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+bcrypt"

RDEPEND="sys-apps/util-linux
	>=dev-python/vobject-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.3[${PYTHON_USEDEP}]
	bcrypt? ( dev-python/passlib[bcrypt,${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

RDIR=/var/lib/${PN}

pkg_pretend() {
	if [[ -f ${RDIR}/.props && ${MERGE_TYPE} != buildonly ]]; then
		eerror "It looks like you have a version 1 database in ${RDIR}."
		eerror "You must convert this database to version 2 format before upgrading."
		eerror "You may want to back up the old database before migrating."
		eerror
		eerror "If you have kept the Gentoo-default database configuration, this will work:"
		eerror "1. Stop any running instance of Radicale."
		eerror "2. Run \`radicale --export-storage ~/radicale-exported\`."
		eerror "3. Run \`chown -R radicale: ~/radicale-exported\`"
		eerror "4. Run \`mv \"${RDIR}\" \"${RDIR}.old\"\`."
		eerror "5. Install Radicale version 2."
		eerror "6. Run \`mv ~/radicale-exported \"${RDIR}/collections\"\`."
		eerror
		eerror "For more details, or if you are have a more complex configuration,"
		eerror "please see the migration guide: https://radicale.org/1to2/"
		eerror "If you do a custom migration, please ensure the database is cleaned out of"
		eerror "${RDIR}, including the hidden .props file."
		die
	fi
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 ${RDIR} ${PN}
}

python_install_all() {
	rm README* || die

	# init file
	newinitd "${FILESDIR}"/radicale-r2.init.d radicale
	systemd_dounit "${FILESDIR}/${PN}.service"

	# directories
	keepdir ${RDIR}
	fowners ${PN}:${PN} ${RDIR}
	fperms 0750 ${RDIR}

	# config file
	insinto /etc/${PN}
	doins config logging

	# fcgi and wsgi files
	exeinto /usr/share/${PN}
	doexe radicale.fcgi radicale.wsgi

	distutils-r1_python_install_all
}

pkg_postinst() {
	local _erdir="${EROOT%/}${RDIR}"

	einfo "A sample WSGI script has been put into ${EROOT%/}/usr/share/${PN}."
	einfo "You will also find there an example FastCGI script."
	if [[ $(stat --format="%U:%G:%a" "${_erdir}") != "${PN}:${PN}:750" ]]
	then
		ewarn "Unsafe file permissions detected on ${_erdir}. This probably comes"
		ewarn "from an earlier version of this ebuild."
		ewarn "To fix run:"
		ewarn "  \`chown -R ${PN}:${PN} ${_erdir}\`"
		ewarn "  \`chmod 0750 ${_erdir}\`"
		ewarn "  \`chmod -R o= ${_erdir}\`"
	fi
}
