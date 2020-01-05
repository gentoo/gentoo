# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A Django template library for manipulating URLs"
HOMEPAGE="https://pypi.org/project/django-spurl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.4
	dev-python/six
	dev-python/nose
	dev-python/URLObject
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
