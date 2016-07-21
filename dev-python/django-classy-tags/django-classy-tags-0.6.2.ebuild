# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit distutils-r1

DESCRIPTION="Class based template tags for Django"
HOMEPAGE="https://github.com/ojii/django-classy-tags https://pypi.python.org/pypi/django-classy-tags"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=">=dev-python/django-1.6"

DEPEND="
	${RDEPEND}
	dev-python/setuptools"