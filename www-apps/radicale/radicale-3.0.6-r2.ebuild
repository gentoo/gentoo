# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 systemd

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="https://radicale.org/"
SRC_URI="https://github.com/Kozea/Radicale/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

MY_P="Radicale-${PV}"

RDEPEND="
	acct-user/radicale
	acct-group/radicale
	dev-python/defusedxml
	dev-python/passlib[bcrypt,${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
	dev-python/waitress[${PYTHON_USEDEP}]
	sys-apps/util-linux
"

BDEPEND="test? ( ${RDEPEND} )"

S="${WORKDIR}/${MY_P}"

RDIR=/var/lib/"${PN}"

DOCS=( DOCUMENTATION.md NEWS.md )

src_prepare() {
	sed -i '/^addopts =/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_install_all() {
	rm README* || die
	# init file
	newinitd "${FILESDIR}"/radicale-r3.init.d radicale
	systemd_dounit "${FILESDIR}/${PN}.service"

	# directories
	keepdir "${RDIR}"
	fperms 0750 "${RDIR}"
	fowners "${PN}:${PN}" "${RDIR}"

	# config file
	insinto /etc/"${PN}"
	doins config

	# fcgi and wsgi files
	exeinto /usr/share/"${PN}"
	doexe radicale.wsgi

	distutils-r1_python_install_all
}

distutils_enable_tests pytest

pkg_postinst() {
	local _erdir="${EROOT}${RDIR}"

	einfo "A sample WSGI script has been put into ${EROOT}/usr/share/${PN}."
	einfo "You will also find there an example FastCGI script."
	if [[ $(stat --format="%U:%G:%a" "${_erdir}") != "${PN}:${PN}:750" ]]
	then
		ewarn ""
		ewarn "Unsafe file permissions detected on ${_erdir}."
		ewarn "This probably comes from an earlier version of this ebuild."
		ewarn "To fix run:"
		ewarn "#  \`chown -R ${PN}:${PN} ${_erdir}\`"
		ewarn "#  \`chmod 0750 ${_erdir}\`"
		ewarn "#  \`chmod -R o= ${_erdir}\`"
	fi
}
