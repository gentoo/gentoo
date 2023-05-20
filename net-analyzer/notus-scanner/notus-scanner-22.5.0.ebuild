# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 systemd

DESCRIPTION="Notus is a vulnerability scanner for creating results from local security checks"
HOMEPAGE="https://github.com/greenbone/notus-scanner"
SRC_URI="https://github.com/greenbone/notus-scanner/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3 AGPL-3+"
KEYWORDS="~amd64 ~x86"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/gvm
	dev-libs/paho-mqtt-c
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/python-gnupg-0.5.0[${PYTHON_USEDEP}]
	<dev-python/packaging-23.2[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-1.22.2[${PYTHON_USEDEP}]
	>=dev-python/rope-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/paho-mqtt-1.5.1[${PYTHON_USEDEP}]
	<dev-python/tomli-3[${PYTHON_USEDEP}]
"

RDEPEND="
	${DEPEND}
	app-misc/mosquitto
"

distutils_enable_tests unittest

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install
	insinto /etc/gvm
	doins "${FILESDIR}/${PN}.toml"
	fowners gvm:gvm "/etc/gvm/${PN}.toml"

	# Set proper permissions on required files/directories
	keepdir /var/lib/notus
	keepdir /var/lib/notus/products
	keepdir /var/lib/notus/advisories
	if ! use prefix; then
		fowners -R gvm:gvm /var/lib/notus
	fi

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	systemd_dounit config/${PN}.service

	systemd_install_serviced "${FILESDIR}/notus-scanner.service.conf" \
			${PN}.service
}
