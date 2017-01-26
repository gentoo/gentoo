# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="Text Plugin for django CMS with CKEditor support"
HOMEPAGE="https://pypi.python.org/pypi/djangocms-text-ckeditor/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
PDEPEND=">=dev-python/django-cms-3.2.0"

src_prepare() {
	sed -i 's/find_packages()/find_packages(exclude=["tests"])/g' "${S}/setup.py"
	eapply_user
}
