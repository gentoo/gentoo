# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Efficient tree implementations for Django 1.6+"
HOMEPAGE="https://tabo.pe/projects/django-treebeard/ https://pypi.python.org/pypi/django-treebeard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-1.6
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"