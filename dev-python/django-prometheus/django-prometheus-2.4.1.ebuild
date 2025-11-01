# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/django-commons/django-prometheus
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Library to export Django metrics for Prometheus"
HOMEPAGE="
	https://github.com/django-commons/django-prometheus/
	https://pypi.org/project/django-prometheus/
"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
	>=dev-python/prometheus-client-0.7[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
