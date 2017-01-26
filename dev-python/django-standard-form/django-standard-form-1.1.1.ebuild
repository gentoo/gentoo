# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Quick and simple django templatetags for displaying forms"
HOMEPAGE="https://pypi.python.org/pypi/django-standard-form"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.3
	>=dev-python/django-classy-tags-0.3.3
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
