# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A library to do [jobs, tasks, flows] in a HA manner using different backends"
HOMEPAGE="https://github.com/openstack/taskflow"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/futurist-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.10[${PYTHON_USEDEP}]
	<dev-python/networkx-2.0[${PYTHON_USEDEP}]
	>=dev-python/contextlib2-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/automaton-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/tenacity-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/cachetools-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]"
