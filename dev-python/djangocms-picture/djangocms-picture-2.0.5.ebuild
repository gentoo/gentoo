# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Picture plugin for django CMS"
HOMEPAGE="https://pypi.org/project/djangocms-picture/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/djangocms-attributes-field-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/django-filer-1.2.4[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
PDEPEND=">=dev-python/django-cms-3.2.0[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i 's/find_packages()/find_packages(exclude=["tests"])/g' "${S}/setup.py"
	eapply_user
}
