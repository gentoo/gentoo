# Copyright 2019 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="simple tagging for django"
HOMEPAGE="https://github.com/jazzband/django-taggit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
