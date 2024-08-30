# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 optfeature systemd

MY_P=${P^}
DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="https://radicale.org/"
SRC_URI="
	https://github.com/Kozea/Radicale/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	>=acct-user/radicale-0-r2
	acct-group/radicale
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-apps/util-linux
"

BDEPEND="
	test? (
		<dev-python/pytest-8[${PYTHON_USEDEP}]
		dev-python/waitress[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

RDIR=/var/lib/"${PN}"

DOCS=( DOCUMENTATION.md CHANGELOG.md )

python_test() {
	epytest -o addopts= radicale/tests/
}

python_install_all() {
	rm README* || die
	# init file
	newinitd "${FILESDIR}"/radicale-r4.init.d radicale
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

	optfeature "Publish changes to rabbitmq" dev-python/pika
}
