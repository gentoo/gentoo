# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Automated generation of Swagger/OpenAPI 2.0 schemas from Django Rest framework"
HOMEPAGE="https://github.com/axnsan12/drf-yasg"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+validation"

RDEPEND=">=dev-python/django-1.11.7[${PYTHON_USEDEP}]
	>=dev-python/djangorestframework-3.7.7[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/coreapi-2.3.3[${PYTHON_USEDEP}]
	>=dev-python/coreschema-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.34[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
	validation? ( >=dev-python/swagger-spec-validator-2.1.0[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
dev-python/setuptools[${PYTHON_USEDEP}]"
