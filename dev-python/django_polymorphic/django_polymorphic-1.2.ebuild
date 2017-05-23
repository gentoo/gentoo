# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_{6,7},3_{2,3,4,5}} )

inherit distutils-r1

DESCRIPTION="Seamless Polymorphic Inheritance for Django Models"
HOMEPAGE="https://pypi.python.org/pypi/django-polymorphic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P//_/-}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.4[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
