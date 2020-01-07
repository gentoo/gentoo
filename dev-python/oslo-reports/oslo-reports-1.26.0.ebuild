# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="generified reports for openstack"
HOMEPAGE="http://docs.openstack.org/developer/oslo.reports"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.reports/oslo.reports-${PV}.tar.gz"
S="${WORKDIR}/oslo.reports-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.0[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.1[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.2[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.3[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.4[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
