# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A library to do [jobs, tasks, flows] in a HA manner using different backends"
HOMEPAGE="https://github.com/openstack/taskflow"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/futurist-0.11.0[${PYTHON_USEDEP}]
	!~dev-python/futurist-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.10[${PYTHON_USEDEP}]
	>=dev-python/contextlib2-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/monotonic-0.6[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/automaton-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/cachetools-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]"
