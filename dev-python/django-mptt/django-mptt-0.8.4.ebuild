# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="Utilities for implementing Modified Preorder Tree Traversal"
HOMEPAGE="https://pypi.python.org/pypi/django-mptt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/django-1.8
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"

src_prepare() {
	epatch "${FILESDIR}/exclude_tests.patch"
}
