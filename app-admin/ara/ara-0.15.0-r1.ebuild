# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="ARA Records Ansible"
HOMEPAGE="https://github.com/openstack/ara"
SRC_URI="https://github.com/openstack/ara/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-admin/ansible[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-migrate[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/flask-script[${PYTHON_USEDEP}]
	dev-python/frozen-flask[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/cliff[${PYTHON_USEDEP}]
	dev-python/subunit[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/debtcollector[${PYTHON_USEDEP}]
	dev-python/junit-xml[${PYTHON_USEDEP}]
	dev-python/pyfakefs[${PYTHON_USEDEP}]
	>=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]
	dev-python/oslo-serialization[${PYTHON_USEDEP}]
	dev-python/oslo-utils[${PYTHON_USEDEP}]
	dev-python/xstatic[${PYTHON_USEDEP}]
	dev-python/xstatic-bootstrap-scss[${PYTHON_USEDEP}]
	dev-python/xstatic-datatables[${PYTHON_USEDEP}]
	dev-python/xstatic-jquery[${PYTHON_USEDEP}]
	dev-python/xstatic-patternfly[${PYTHON_USEDEP}]
	dev-python/xstatic-patternfly-bootstrap-treeview[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_compile() {
	export PBR_VERSION="${PV}"
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
	einstalldocs
	dodoc -r doc
}
