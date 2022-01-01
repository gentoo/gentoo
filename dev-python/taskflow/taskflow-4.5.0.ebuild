# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

DESCRIPTION="A library to do [jobs, tasks, flows] in a HA manner using different backends"
HOMEPAGE="https://github.com/openstack/taskflow"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/futurist-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/contextlib2-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/automaton-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/tenacity-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/cachetools-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pydot-1.2.4[${PYTHON_USEDEP}]"
