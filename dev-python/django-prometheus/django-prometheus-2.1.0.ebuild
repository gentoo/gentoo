# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Library to export Django metrics for Prometheus"
HOMEPAGE="https://github.com/korfuri/django-prometheus"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/prometheus_client-0.7[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
