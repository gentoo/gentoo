# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Library to export django metrics for prometheus"
HOMEPAGE="https://github.com/korfuri/django-prometheus"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/prometheus_client-0.7[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
