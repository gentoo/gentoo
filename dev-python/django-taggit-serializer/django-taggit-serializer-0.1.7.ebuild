# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="the django taggit serializer for the django rest framework"
HOMEPAGE="https://github.com/glemmaPaul/django-taggit-serializer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
