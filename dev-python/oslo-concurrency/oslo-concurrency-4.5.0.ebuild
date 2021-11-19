# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Oslo Concurrency library"
HOMEPAGE="https://pypi.org/project/oslo.concurrency/ https://github.com/openstack/oslo.concurrency"
SRC_URI="mirror://pypi/o/${PN/-/.}/${PN/-/.}-${PV}.tar.gz"
S="${WORKDIR}/${PN/-/.}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND=">dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.19.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest
