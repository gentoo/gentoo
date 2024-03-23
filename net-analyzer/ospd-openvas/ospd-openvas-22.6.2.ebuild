# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 systemd

DESCRIPTION="This is an OSP server implementation to allow GVM to remotely control OpenVAS"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/ospd-openvas"
SRC_URI="https://github.com/greenbone/ospd-openvas/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc +notus"

DEPEND="
	acct-user/gvm
	>=dev-python/defusedxml-0.6[${PYTHON_USEDEP}]
	<dev-python/defusedxml-0.8[${PYTHON_USEDEP}]
	>=dev-python/deprecated-1.2.10[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.5.2[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	<dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.5.1[${PYTHON_USEDEP}]
	>=dev-python/redis-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-gnupg-0.4.8[${PYTHON_USEDEP}]
	<dev-python/python-gnupg-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/paho-mqtt-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/python-gnupg-0.4.8[${PYTHON_USEDEP}]
	net-libs/paho-mqtt-c
	app-misc/mosquitto
"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	>=net-analyzer/openvas-scanner-22.4
	notus? ( >=net-analyzer/notus-scanner-22.4 )
"

distutils_enable_tests unittest

python_compile() {
	if use doc; then
		bash "${S}"/docs/generate || die
		HTML_DOCS=( "${S}"/docs/. )
	fi
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install

	insinto /etc/gvm
	doins config/${PN}.conf
	if ! use prefix; then
		fowners -R gvm:gvm /etc/gvm
	fi

	newinitd "${FILESDIR}/${PN}-22.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-22.confd" "${PN}"

	systemd_dounit config/${PN}.service

	if use notus; then
		systemd_install_serviced "${FILESDIR}/ospd-openvas.service_notus.conf" \
			${PN}.service
	else
		systemd_install_serviced "${FILESDIR}/ospd-openvas.service.conf" \
			${PN}.service
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/ospd-openvas.logrotate" ospd-openvas

	# OSPD OpenVAS attempts to call openvas via sudo as network security
	# scanning often requires priviliged operations.
	insinto /etc/sudoers.d
	newins - openvas <<-EOF
	gvm  ALL = NOPASSWD: /usr/bin/openvas
EOF
	fperms 0750 /etc/sudoers.d
	fperms 0440 /etc/sudoers.d/openvas
}
