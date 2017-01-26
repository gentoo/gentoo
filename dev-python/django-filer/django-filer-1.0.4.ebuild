# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="File management application for django that makes handling of files and images"
HOMEPAGE="https://pypi.python.org/pypi/django-filer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.5
	>=dev-python/django_polymorphic-0.2
	>=dev-python/easy-thumbnails-1.0
	dev-python/django-mptt
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
