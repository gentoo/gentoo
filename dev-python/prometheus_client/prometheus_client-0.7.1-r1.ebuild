# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
inherit distutils-r1

DESCRIPTION="Python client for the Prometheus monitoring system"
HOMEPAGE="https://pypi.org/project/prometheus_client/
	https://github.com/prometheus/client_python"
SRC_URI="https://github.com/prometheus/client_python/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/client_python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/twisted[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
