# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 python3_8 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Quantum API"
HOMEPAGE="https://launchpad.net/neutron"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.28.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.5.1[${PYTHON_USEDEP}]"

python_install() {
	distutils-r1_python_install
	#stupid stupid
	local SITEDIR="${D}$(python_get_sitedir)" || die
	cd "${SITEDIR}" || die
	local egg=( python_neutronclient*.egg-info )
	#[[ -f ${egg[0]} ]] || die "python_quantumclient*.egg-info not found"
	ln -s "${egg[0]}" "${egg[0]/neutron/quantum}" || die
	ln -s neutronclient quantumclient || die
	ln -s neutron quantumclient/quantum || die
}
