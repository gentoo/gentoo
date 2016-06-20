# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Allows re-usable apps to provide sets of templates and staticfiles"
HOMEPAGE="https://pypi.python.org/pypi/aldryn-boilerplates"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.5
	dev-python/django-appconf
	>=dev-python/YURL-0.13
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
