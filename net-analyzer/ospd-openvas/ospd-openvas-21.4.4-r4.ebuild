# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 systemd

DESCRIPTION="This is an OSP server implementation to allow GVM to remotely control OpenVAS"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/ospd-openvas"
SRC_URI="https://github.com/greenbone/ospd-openvas/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	acct-user/gvm
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/redis-3.5.3[${PYTHON_USEDEP}]
	!net-analyzer/ospd[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	>=net-analyzer/openvas-scanner-${PV}
"

distutils_enable_tests unittest

src_prepare() {
	default

	# https://github.com/greenbone/ospd-openvas/pull/649
	sed -i '/^Group=gvm/d' config/ospd-openvas.service || die

	# https://github.com/greenbone/ospd-openvas/pull/653
	sed -i 's;/usr/local/bin/;/usr/bin/;' config/ospd-openvas.service || die
}

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

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	systemd_dounit config/${PN}.service

	# OSPD OpenVAS attempts to call openvas via sudo as network security
	# scanning often requires priviliged operations.
	insinto /etc/sudoers.d
	newins - openvas <<-EOF
	gvm  ALL = NOPASSWD: /usr/bin/openvas
EOF
}
