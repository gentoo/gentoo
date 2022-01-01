# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="OpenStack logging config library, configuration for all openstack projects."
HOMEPAGE="https://pypi.org/project/oslo.log/ https://github.com/openstack/oslo.log"
SRC_URI="mirror://pypi/o/oslo.log/oslo.log-${PV}.tar.gz"
S="${WORKDIR}/oslo.log-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=">=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.19.0[${PYTHON_USEDEP}]
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]"
DEPEND=">=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]"
