# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="An app that provides django integration for RQ (Redis Queue)"
HOMEPAGE="https://github.com/rq/django-rq"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/django-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/rq-0.13[${PYTHON_USEDEP}]
	>=dev-python/redis-py-3.0.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
