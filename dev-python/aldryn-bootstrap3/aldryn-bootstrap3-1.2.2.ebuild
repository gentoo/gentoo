# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="django CMS plugins for bootstrap3 markup"
HOMEPAGE="https://github.com/aldryn/aldryn-bootstrap3/"
SRC_URI="https://github.com/aldryn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-cms-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/django-appconf-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/django-filer-0.9.11[${PYTHON_USEDEP}]
	>=dev-python/djangocms-attributes-field-0.1.1[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
