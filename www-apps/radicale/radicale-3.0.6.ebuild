# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 eutils systemd

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="https://radicale.org/"
SRC_URI="https://github.com/Kozea/Radicale/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+bcrypt"

MY_P="Radicale-${PV}"

RDEPEND="
	acct-user/radicale
	acct-group/radicale
	dev-python/defusedxml
	>=dev-python/vobject-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	sys-apps/util-linux
	bcrypt? ( dev-python/passlib[bcrypt,${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

RDIR=/var/lib/${PN}

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
	doins config

	# fcgi and wsgi files
	exeinto /usr/share/${PN}
	doexe radicale.wsgi

	distutils-r1_python_install_all
}

pkg_postinst() {
	local _erdir="${EROOT}${RDIR}"

	einfo "A sample WSGI script has been put into ${EROOT}/usr/share/${PN}."
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
