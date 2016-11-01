# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="An extension to django CMS to provide multilingual Haystack indexes"
HOMEPAGE="https://pypi.python.org/pypi/aldryn-search"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/lxml
	>=dev-python/django-1.4
	dev-python/django-appconf
	>=dev-python/django-cms-3.0
	>=dev-python/django-haystack-2.0.0
	dev-python/django-spurl
	dev-python/django-standard-form
	>=dev-python/aldryn-common-1.0.2
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
